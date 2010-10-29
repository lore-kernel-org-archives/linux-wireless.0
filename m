Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762169Ab0J2Xfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:42 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3037811bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:41 -0700 (PDT)
Message-Id: <82a8179f927ea34988b278a3f1726e3efea5fb3b.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 30 Oct 2010 00:49:52 +0200
Subject: [RFT] carl9170: improve rx ampdu software deaggregation
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the stateless ampdu rx filter to
scan and salvage intact MPDUs from otherwise "bad data".

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note: The search is expensive [compared to the other approach],
but it helps in my setup and if the stats are true it saves
around 10% of the otherwise lost data [but mostly small frames]. 
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    3 +
 drivers/net/wireless/ath/carl9170/main.c     |    1 +
 drivers/net/wireless/ath/carl9170/rx.c       |  117 +++++++++++++++++++++-----
 3 files changed, 101 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index f1212ba..17109cc 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -402,6 +402,9 @@ struct ar9170 {
 	/* rxstream mpdu merge */
 	struct ar9170_rx_head rx_plcp;
 	bool rx_has_plcp;
+	bool has_ampdu_id;
+	__le16 ampdu_id;
+	u8 ampdu_ra[ETH_ALEN];
 	struct sk_buff *rx_failover;
 	int rx_failover_missing;
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index b997844..1b1645a 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -561,6 +561,7 @@ static int carl9170_init_interface(struct ar9170 *ar,
 	}
 
 	memcpy(common->macaddr, vif->addr, ETH_ALEN);
+	memcpy(ar->ampdu_ra, vif->addr, ETH_ALEN);
 
 	if (modparam_nohwcrypt ||
 	    ((vif->type != NL80211_IFTYPE_STATION) &&
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 939a0e9..0ef658b 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -576,18 +576,13 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 	}
 }
 
-static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms)
-{
-	__le16 fc;
+/* FC + DU + RA + FCS */
+#define MIN_LEN	(2 + 2 + ETH_ALEN + FCS_LEN)
 
-	if ((ms & AR9170_RX_STATUS_MPDU) == AR9170_RX_STATUS_MPDU_SINGLE) {
-		/*
-		 * This frame is not part of an aMPDU.
-		 * Therefore it is not subjected to any
-		 * of the following content restrictions.
-		 */
-		return true;
-	}
+static bool carl9170_ampdu_check(struct ar9170 *ar, struct ieee80211_hdr *hdr,
+				 int len)
+{
+	__le16 fc = hdr->frame_control;
 
 	/*
 	 * "802.11n - 7.4a.3 A-MPDU contents" describes in which contexts
@@ -597,20 +592,103 @@ static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms)
 	 * stateless filter solely based on the frame control field.
 	 */
 
-	fc = ((struct ieee80211_hdr *)buf)->frame_control;
-	if (ieee80211_is_data_qos(fc) && ieee80211_is_data_present(fc))
+	if (ieee80211_has_tods(fc) &&
+	    memcmp(hdr->addr1, ar->ampdu_ra, ETH_ALEN) != 0)
+		return false;
+
+	if (ieee80211_is_data_qos(fc) && ieee80211_is_data_present(fc) &&
+	    !ieee80211_has_morefrags(fc) && !(hdr->seq_ctrl & cpu_to_le16(0xf))
+	    && !ieee80211_has_pm(fc) && len >= sizeof(*hdr) + FCS_LEN)
 		return true;
 
-	if (ieee80211_is_ack(fc) || ieee80211_is_back(fc) ||
-	    ieee80211_is_back_req(fc))
+	if ((ieee80211_is_ack(fc) && len == MIN_LEN) ||
+	   ((ieee80211_is_back(fc) || ieee80211_is_back_req(fc)) &&
+	     len >= sizeof(struct ieee80211_bar)))
 		return true;
 
-	if (ieee80211_is_action(fc))
+	if (ieee80211_is_action(fc) && len > MIN_LEN)
 		return true;
 
 	return false;
 }
 
+static bool carl9170_ampdu_checker(struct ar9170 *ar, u8 **buf, int *len)
+{
+	struct ieee80211_hdr *hdr;
+
+	do {
+		hdr = (struct ieee80211_hdr *) *(buf);
+
+		/*
+		 * 802.11n - 7.4a.3: "All the MPDUs within an A-MPDU are
+		 * addressed to the same RA."
+		 */
+		if ((memcmp(ar->ampdu_ra, hdr->addr1, ETH_ALEN) == 0)) {
+			/*
+			 * 802.11n - 7.4a.3: "The Duration/ID fields in the
+			 * MAC headers of all MPDUs in an A-MPDU carry the
+			 * same value."
+			 */
+			if (!(ar->has_ampdu_id &&
+			    (ar->ampdu_id != hdr->duration_id))) {
+				if (carl9170_ampdu_check(ar, hdr, *len))
+					return true;
+			}
+		}
+
+		(*buf)++;
+		(*len)--;
+	} while (*len >= MIN_LEN);
+
+	return false;
+}
+
+static bool carl9170_ampdu_state_check(struct ar9170 *ar, u8 **buf,
+				       u8 ms, int *len)
+{
+	int i;
+
+	if ((ms & AR9170_RX_STATUS_MPDU) == AR9170_RX_STATUS_MPDU_SINGLE ||
+	    unlikely(ar->sniffer_enabled)) {
+		/*
+		 * This frame is not part of an aMPDU.
+		 * Therefore it is not subjected to any
+		 * of the following content restrictions.
+		 *
+		 * Also, in sniffer mode we don't want
+		 * anything to touch the raw frames.
+		 */
+		return true;
+	}
+
+	if (carl9170_ampdu_checker(ar, buf, len))
+		return true;
+
+	if ((ms & AR9170_RX_STATUS_MPDU) != AR9170_RX_STATUS_MPDU_FIRST)
+		return false;
+
+	rcu_read_lock();
+	for_each_set_bit(i, &ar->vif_bitmap, ar->fw.vif_num) {
+		struct ieee80211_vif *vif;
+
+		vif = rcu_dereference(ar->vif_priv[i].vif);
+		if (vif) {
+			memcpy(ar->ampdu_ra, vif->addr, ETH_ALEN);
+
+			if (carl9170_ampdu_checker(ar, buf, len)) {
+				struct ieee80211_hdr *hdr = (void *)(*buf);
+
+				ar->has_ampdu_id = true;
+				ar->ampdu_id = hdr->duration_id;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	return i == ar->fw.vif_num;
+}
+
 /*
  * If the frame alignment is right (or the kernel has
  * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
@@ -660,7 +738,7 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 
 			mpdu_len -= sizeof(struct ar9170_rx_head);
 			buf += sizeof(struct ar9170_rx_head);
-
+			ar->has_ampdu_id = false;
 			ar->rx_has_plcp = true;
 		} else {
 			if (net_ratelimit()) {
@@ -722,15 +800,14 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 		break;
 	}
 
-	/* FC + DU + RA + FCS */
-	if (unlikely(mpdu_len < (2 + 2 + ETH_ALEN + FCS_LEN)))
+	if (unlikely(mpdu_len < MIN_LEN))
 		goto drop;
 
 	memset(&status, 0, sizeof(status));
 	if (unlikely(carl9170_rx_mac_status(ar, head, mac, &status)))
 		goto drop;
 
-	if (!carl9170_ampdu_check(ar, buf, mac_status))
+	if (!carl9170_ampdu_state_check(ar, &buf, mac_status, &mpdu_len))
 		goto drop;
 
 	if (phy)
-- 
1.7.2.3

