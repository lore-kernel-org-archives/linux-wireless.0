Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:38655 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZBJPKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:10:30 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v4 2/2] mac80211: use ps-poll when dynamic power save mode is
	disabled
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	vivek.natraj@gmail.com
Date: Tue, 10 Feb 2009 17:09:31 +0200
Message-ID: <20090210150931.21245.52052.stgit@tikku> (sfid-20090210_161032_919459_5CD0FF85)
In-Reply-To: <20090210150822.21245.87099.stgit@tikku>
References: <20090210150822.21245.87099.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a directed tim bit is set, mac80211 currently disables power save
ands sends a null frame to the AP. But if dynamic power save is
disabled, mac80211 will not enable power save ever gain. Fix this by
adding ps-poll functionality to mac80211. When a directed tim bit is
set, mac80211 sends a ps-poll frame to the AP and checks for the more
data bit in the returned data frames.

Using ps-poll is slower than waking up with null frame, but it's saves more
power in cases where the traffic is low. Userspace can control if either
ps-poll or null wakeup method is used by enabling and disabling dynamic
power save.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    3 ++
 net/mac80211/mlme.c        |   54 ++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/rx.c          |   34 ++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5a1f19a..67bd522 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -728,6 +728,7 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool powersave;
+	bool pspolling;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
@@ -921,6 +922,8 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u8 *ssid, size_t ssid_len);
+void ieee80211_send_pspoll(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 05c8d13..169f10c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -511,6 +511,39 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
+void ieee80211_send_pspoll(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_pspoll *pspoll;
+	struct sk_buff *skb;
+	u16 fc;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for "
+		       "pspoll frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	pspoll = (struct ieee80211_pspoll *) skb_put(skb, sizeof(*pspoll));
+	memset(pspoll, 0, sizeof(*pspoll));
+	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL | IEEE80211_FCTL_PM;
+	pspoll->frame_control = cpu_to_le16(fc);
+	pspoll->aid = cpu_to_le16(ifsta->aid);
+
+	/* aid in PS-Poll has its two MSBs each set to 1 */
+	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
+
+	memcpy(pspoll->bssid, ifsta->bssid, ETH_ALEN);
+	memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
+
+	ieee80211_tx_skb(sdata, skb, 0);
+
+	return;
+}
+
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_bss *bss)
@@ -1868,9 +1901,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		directed_tim = ieee80211_check_tim(&elems, ifsta->aid);
 
 		if (directed_tim) {
-			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-			ieee80211_send_nullfunc(local, sdata, 0);
+			if (local->hw.conf.dynamic_ps_timeout > 0) {
+				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+				ieee80211_hw_config(local,
+						    IEEE80211_CONF_CHANGE_PS);
+				ieee80211_send_nullfunc(local, sdata, 0);
+			} else {
+				local->pspolling = true;
+
+				/*
+				 * Here is assumed that the driver will be
+				 * able to send ps-poll frame and receive a
+				 * response even though power save mode is
+				 * enabled, but some drivers might require
+				 * to disable power save here. This needs
+				 * to be investigated.
+				 */
+				ieee80211_send_pspoll(local, sdata);
+			}
 		}
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8e8ddbf..0e030d3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -731,6 +731,39 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	return result;
 }
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_local *local;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb;
+
+	local = rx->local;
+	skb = rx->skb;
+	hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (!local->pspolling)
+		return RX_CONTINUE;
+
+	if (!ieee80211_has_fromds(hdr->frame_control))
+		/* this is not from AP */
+		return RX_CONTINUE;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	if (!ieee80211_has_moredata(hdr->frame_control)) {
+		/* AP has no more frames buffered for us */
+		local->pspolling = false;
+		return RX_CONTINUE;
+	}
+
+	/* more data bit is set, let's request a new frame from the AP */
+	ieee80211_send_pspoll(local, rx->sdata);
+
+	return RX_CONTINUE;
+}
+
 static void ap_sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -1987,6 +2020,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 	CALL_RXH(ieee80211_rx_h_decrypt)
+	CALL_RXH(ieee80211_rx_h_check_more_data)
 	CALL_RXH(ieee80211_rx_h_sta_process)
 	CALL_RXH(ieee80211_rx_h_defragment)
 	CALL_RXH(ieee80211_rx_h_ps_poll)

