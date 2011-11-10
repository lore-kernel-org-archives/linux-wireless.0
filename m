Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4622 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1KJTaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/19] brcm80211: smac: remove usage of brcmu_pkttotlen
Date: Thu, 10 Nov 2011 20:30:26 +0100
Message-ID: <1320953434-16859-13-git-send-email-arend@broadcom.com> (sfid-20111110_203108_130726_D424EF9C)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_pkttotlen calculates the total length of a sk_buff
chain following the next pointer. In brcmsmac this is not needed as
in each place where it was used the provided sk_buff had a NULL pointer
as next field value.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 ++----
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 7f27dbd..43f7a72 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -649,7 +649,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		len = roundup(len, 4);
 		ampdu_len += (len + (ndelim + 1) * AMPDU_DELIMITER_LEN);
 
-		dma_len += (u16) brcmu_pkttotlen(p);
+		dma_len += (u16) p->len;
 
 		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
 			" seg_cnt %d null delim %d\n",
@@ -741,9 +741,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		if (p) {
 			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
 			    ((u8) (p->priority) == tid)) {
-
-				plen = brcmu_pkttotlen(p) +
-				       AMPDU_MAX_MPDU_OVERHEAD;
+				plen = p->len + AMPDU_MAX_MPDU_OVERHEAD;
 				plen = max(scb_ampdu->min_len, plen);
 
 				if ((plen + ampdu_len) > max_ampdu_bytes) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 0e8873e..6a679c9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -949,7 +949,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	totlen = brcmu_pkttotlen(p);
+	totlen = p->len;
 	free_pdu = true;
 
 	brcms_c_txfifo_complete(wlc, queue, 1);
@@ -6716,7 +6716,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	qos = ieee80211_is_data_qos(h->frame_control);
 
 	/* compute length of frame in bytes for use in PLCP computations */
-	len = brcmu_pkttotlen(p);
+	len = p->len;
 	phylen = len + FCS_LEN;
 
 	/* Get tx_info */
-- 
1.7.5.4


