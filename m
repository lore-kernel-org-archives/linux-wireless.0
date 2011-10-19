Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58444 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1JSOLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 10:11:07 -0400
From: <Marek.Kwaczynski@tieto.com>
To: <linux-wireless@vger.kernel.org>
Date: Wed, 19 Oct 2011 17:12:02 +0300
Subject: Crash in ieee80211_rx_h_michael_mic_verify()
Message-ID: <3A42A4F4F2ABA44EBD5853ED099266471642AC5171@EXMB02.eu.tieto.com> (sfid-20111019_161111_501368_0E745F6E)
References: <20111014151439.747074240@sipsolutions.net>
 <20111014151522.350015639@sipsolutions.net>
In-Reply-To: <20111014151522.350015639@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I had a crash in function 
ieee80211_rx_h_michael_mic_verify() during calling 
mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
					(void *) skb->data, NULL, GFP_ATOMIC);

The rx->key was a NULL pointer in this case. This situation was only in WPA2 mode. I investigated this issue and I found that the problem is related to decryption in function: ieee80211_rx_h_decrypt().

When I set rx->key the crash doesn't appear but I'm not sure if it is a good pleace.

The patch:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a247ffe..b16ad4f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -974,9 +974,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
                 * we somehow allow the driver to tell us which key
                 * the hardware used if this flag is set?
                 */
+
                if ((status->flag & RX_FLAG_DECRYPTED) &&
-                   (status->flag & RX_FLAG_IV_STRIPPED))
-                       return RX_CONTINUE;
+                    (status->flag & RX_FLAG_IV_STRIPPED)) {
+                        if (sta_ptk)
+                                rx->key = sta_ptk;
+                        return RX_CONTINUE;
+                }
+

                hdrlen = ieee80211_hdrlen(fc);

Can you send me a path to the git with the newest source code?

Best regards,
Marek Kwaczynski