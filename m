Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44701 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbaKUPMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 10:12:15 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so5110976pad.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 07:12:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGKQeFjfMwFE8d4FVOZY7n3R1=x3naDoxT4-YKUEnA3T7AJcLw@mail.gmail.com>
References: <CAGKQeFjfMwFE8d4FVOZY7n3R1=x3naDoxT4-YKUEnA3T7AJcLw@mail.gmail.com>
Date: Fri, 21 Nov 2014 20:42:14 +0530
Message-ID: <CAGKQeFhjmo4LM9xTCSeuxu8R4VUwUSBiw-q9MaSiwB0eDpKBxg@mail.gmail.com> (sfid-20141121_161223_938651_58C628D0)
Subject: Fwd: Linux kernel 3.12 PN-KEY Mismatch in wpa.c, packet drop
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for interrupting you.
The below patch do recovers from pn-key mismatch in kernel 3.12 kernel
packet drop issue.
I don't know where I need to submit this patch for proper solution.


---------- Forwarded message ----------
From: deepak kumar Pradhan <hydipu@gmail.com>
Date: Fri, Nov 21, 2014 at 8:31 PM
Subject: Linux kernel 3.12 PN-KEY Mismatch in wpa.c, packet drop
To: linux-wireless@vger.kernel.org


Hi,
When I am sending heavy traffic through wireless, the packet number
and key is mismatching.
I have applied the below patch which solves my pn-key mismatch packet drop.
diff -Nurp linux-custom_1/net/mac80211/wpa.c linux-custom/net/mac80211/wpa.c
--- linux-custom_1/net/mac80211/wpa.c   2014-11-09 23:14:57.000000000 -0800
+++ linux-custom/net/mac80211/wpa.c     2014-11-13 05:16:45.000000000 -0800
@@ -483,7 +483,7 @@ ieee80211_crypto_ccmp_encrypt(struct iee
        return TX_CONTINUE;
 }

-
+#define MAX_PN_TOLERANCE 0x05  //PN-KEY mismatch
 ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 {
@@ -495,6 +495,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
        u8 pn[IEEE80211_CCMP_PN_LEN];
        int data_len;
        int queue;
+       static const u8 zero_pn[IEEE80211_CCMP_PN_LEN] = {0};

        hdrlen = ieee80211_hdrlen(hdr->frame_control);

@@ -537,8 +538,16 @@ ieee80211_crypto_ccmp_decrypt(struct iee
                            skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN))
                        return RX_DROP_UNUSABLE;
        }
-
-       memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+
+       //PN-KEY mismatch start
+       if (memcmp(key->u.ccmp.rx_pn[queue], zero_pn,
IEEE80211_CCMP_PN_LEN) == 0)
+       {
+               if((memcmp(pn,zero_pn,(IEEE80211_CCMP_PN_LEN-1)) == 0)
&& (pn[IEEE80211_CCMP_PN_LEN-1] < MAX_PN_TOLERANCE))
+                       memcpy(key->u.ccmp.rx_pn[queue], pn,
IEEE80211_CCMP_PN_LEN);
+       }
+       else
+               memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+       //PN-KEY mismatch end

        /* Remove CCMP header and MIC */
        if (pskb_trim(skb, skb->len - IEEE80211_CCMP_MIC_LEN))


--
Deepak Kumar Pradhan
