Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59335 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbaKUO4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 09:56:41 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so3249850pdj.9
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 06:56:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGKQeFgX+qZ2MSjRio+OKo5GZDzgZCRcZ3d=DAkYWcppC2nG3w@mail.gmail.com>
References: <CAGKQeFgX+qZ2MSjRio+OKo5GZDzgZCRcZ3d=DAkYWcppC2nG3w@mail.gmail.com>
Date: Fri, 21 Nov 2014 20:26:41 +0530
Message-ID: <CAGKQeFj=g356wU=V5v2AhhWAJwkJ7mDKts2zYf1yZw98dNyiPg@mail.gmail.com> (sfid-20141121_155644_620825_AB649F57)
Subject: Re: PN KEY MISMATCH: PACKET DROPPED MAC80211
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
This patch do recovers from PN-KEY mismatch packet drop in linux kernel 3.12.2.

diff -Nurp linux-custom_1/net/mac80211/wpa.c linux-custom/net/mac80211/wpa.c
--- linux-custom_1/net/mac80211/wpa.c 2014-11-09 23:14:57.000000000 -0800
+++ linux-custom/net/mac80211/wpa.c 2014-11-13 05:16:45.000000000 -0800
@@ -483,7 +483,7 @@ ieee80211_crypto_ccmp_encrypt(struct iee
return TX_CONTINUE;
}
-
+#define MAX_PN_TOLERANCE 0x05 //PN-KEY mismatch
ieee80211_rx_result
ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
{
@@ -495,6 +495,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
u8 pn[IEEE80211_CCMP_PN_LEN];
int data_len;
int queue;
+ static const u8 zero_pn[IEEE80211_CCMP_PN_LEN] = {0};
hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -537,8 +538,16 @@ ieee80211_crypto_ccmp_decrypt(struct iee
skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN))
return RX_DROP_UNUSABLE;
}
-
- memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+
+ //PN-KEY mismatch start
+ if (memcmp(key->u.ccmp.rx_pn[queue], zero_pn, IEEE80211_CCMP_PN_LEN) == 0)
+ {
+ if((memcmp(pn,zero_pn,(IEEE80211_CCMP_PN_LEN-1)) == 0) &&
(pn[IEEE80211_CCMP_PN_LEN-1] < MAX_PN_TOLERANCE))
+ memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+ }
+ else
+ memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+ //PN-KEY mismatch end
/* Remove CCMP header and MIC */
if (pskb_trim(skb, skb->len - IEEE80211_CCMP_MIC_LEN))

On Tue, Nov 11, 2014 at 3:49 PM, deepak kumar Pradhan <hydipu@gmail.com> wrote:
> We are using IXDP465 intel board which is running kernel 3.12.2 with a
> wireless >Atheros card (driver ath9k) for mesh networking using authsae for
> secured mesh >network.
> Under stress tests we are getting gap in wireless connectivity. On further
> investigation, we found that the Packet Number and Key is mismatched and
> packet >dropped.
> (In function: ieee80211_crypto_ccmp_decrypt, file net/mac80211/wpa.c file).
> To fix this we tried the below patch, but we still facing the same
> issue(gap).
> Has someone observed this issue. Any inputs on this is much appreciated.
> Please forgive me if I have posted to a wrong list, and please guide me
> where should I post this?



-- 
Deepak Kumar Pradhan
