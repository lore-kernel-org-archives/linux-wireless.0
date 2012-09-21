Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab2IUMm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 08:42:27 -0400
Date: Fri, 21 Sep 2012 14:41:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC] mac80211: validate key before MIC verify
Message-ID: <20120921124141.GA3100@redhat.com> (sfid-20120921_144231_551799_5DDB2F3B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have strange crash on rt61pci hardware when switching off radio
by rfkill switch:
https://bugzilla.redhat.com/attachment.cgi?id=615362   

After debugging the issue, I figured out problem happens because
key->u.ccmp.tfm of group key get corrupted. Corruption happen in

ieee80211_rx_h_michael_mic_verify():

        /* update IV in key information to be able to detect replays */
        rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
        rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;

because rt61pci always set RX_FLAG_MMIC_STRIPPED and RX_FLAG_IV_STRIPPED
flags.

This problem was introduces in:

816c04f mac80211: consolidate MIC failure report handling

which already has fixes of invalid usage of rx->key pointer:

1140afa mac80211: fix rx->key NULL pointer dereference in promiscuous mode
a66b98d mac80211: fix rx->key NULL dereference during mic failure

This patch fix the problem by checking for key pointer is valid and if
key type is TKIP, before doing any other MIC verification.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

---
I did not test patch ...

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bdb53ab..6f800f7 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -97,6 +97,14 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	/*
+	 * Some hardware seems to generate Michael MIC failure reports; even
+	 * though, the frame was not encrypted with TKIP and therefore has no
+	 * MIC. Ignore the flag them to avoid triggering countermeasures.
+	 */
+	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP)
+		return RX_CONTINUE;
+
+	/*
 	 * No way to verify the MIC if the hardware stripped it or
 	 * the IV with the key index. In this case we have solely rely
 	 * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
@@ -106,19 +114,13 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
+		if (!(status->flag & RX_FLAG_IV_STRIPPED))
 			goto update_iv;
 
 		return RX_CONTINUE;
 	}
 
-	/*
-	 * Some hardware seems to generate Michael MIC failure reports; even
-	 * though, the frame was not encrypted with TKIP and therefore has no
-	 * MIC. Ignore the flag them to avoid triggering countermeasures.
-	 */
-	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
-	    !(status->flag & RX_FLAG_DECRYPTED))
+	if (!(status->flag & RX_FLAG_DECRYPTED))
 		return RX_CONTINUE;
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && rx->key->conf.keyidx) {
@@ -165,8 +167,7 @@ mic_fail:
 	 * a driver that supports HW encryption. Send up the key idx only if
 	 * the key is set.
 	 */
-	mac80211_ev_michael_mic_failure(rx->sdata,
-					rx->key ? rx->key->conf.keyidx : -1,
+	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
 					(void *) skb->data, NULL, GFP_ATOMIC);
 	return RX_DROP_UNUSABLE;
 }
