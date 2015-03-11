Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33292 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbCKN1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 09:27:48 -0400
Received: by lbdu14 with SMTP id u14so8871917lbd.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 06:27:46 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: strip qos data bit always
Date: Wed, 11 Mar 2015 14:25:26 +0100
Message-Id: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com> (sfid-20150311_142751_625852_7560ADDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NativeWifi tx mode expects QoS Data frames to be
delivered as Data frames with QoS part (e.g. tid)
being delievered out-of-band in fw tx command.

The QoS bit wasn't stripped before submitting to
firmware.

Stripping fixes two known problems:

 * qca6174 IOT with some APs, e.g.
   Cisco AIR-AP 1252 (which would crash after
   ath10k association). Some ath9k APs would
   crash as well.

 * sniffing own tx frames via radiotap because,
   e.g. wireshark was seeing QoS bit set but
   since QoS Control was stripped in ath10k it
   would parse beginning of LLC/SNAP

>From debugability point of view this removes the
ability to distinguish QoS from non-QoS frames
when sniffing own tx via radiotap. On the other
hand frames can be now parsed correctly without
special software modification.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..625e2cb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2463,16 +2463,15 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 		skb->data, (void *)qos_ctl - (void *)skb->data);
 	skb_pull(skb, IEEE80211_QOS_CTL_LEN);
 
-	/* Fw/Hw generates a corrupted QoS Control Field for QoS NullFunc
-	 * frames. Powersave is handled by the fw/hw so QoS NyllFunc frames are
-	 * used only for CQM purposes (e.g. hostapd station keepalive ping) so
-	 * it is safe to downgrade to NullFunc.
+	/* Some firmware revisions don't handle sending QoS NullFunc well.
+	 * These frames are mainly used for CQM purposes so it doesn't really
+	 * matter whether QoS NullFunc or NullFunc are sent.
 	 */
 	hdr = (void *)skb->data;
-	if (ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 		cb->htt.tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
-	}
+
+	hdr->frame_control &= ~__cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 }
 
 static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
-- 
1.8.5.3

