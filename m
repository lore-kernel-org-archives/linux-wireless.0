Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37181 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaKUPBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 10:01:22 -0500
Received: by mail-pd0-f171.google.com with SMTP id v10so5458515pde.30
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 07:01:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 21 Nov 2014 20:31:21 +0530
Message-ID: <CAGKQeFjfMwFE8d4FVOZY7n3R1=x3naDoxT4-YKUEnA3T7AJcLw@mail.gmail.com> (sfid-20141121_160125_227508_3AE6478A)
Subject: Linux kernel 3.12 PN-KEY Mismatch in wpa.c, packet drop
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
