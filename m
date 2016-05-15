Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33456 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbcEOOX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 10:23:26 -0400
Received: by mail-io0-f176.google.com with SMTP id f89so183197786ioi.0
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2016 07:23:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 15 May 2016 07:23:25 -0700
Message-ID: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com> (sfid-20160515_162332_185331_914ABADF)
Subject: [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.
From: Adrian Chadd <adrian@freebsd.org>
To: b43-dev@lists.infradead.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Author: Adrian Chadd <adrian@freebsd.org>
Date:   Sun May 15 07:15:54 2016 -0700

    [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.

    Check the current PHY operating mode (gmode) to see if we should
    fall back from 6MB OFDM to 11MB CCK.  For 5GHz operation this isn't
    allowed.

    Note, the fallback lookup is only done for RTS rates; normal fallback
    rates are done via mac80211 and aren't affected by this change.

    Signed-off-by: Adrian Chadd <adrian@freebsd.org>

diff --git a/drivers/net/wireless/broadcom/b43/xmit.c
b/drivers/net/wireless/broadcom/b43/xmit.c
index f620126..fbf0e92 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -205,7 +205,7 @@ static u16 b43_generate_tx_phy_ctl1(struct
b43_wldev *dev, u8 bitrate)
        return control;
 }

-static u8 b43_calc_fallback_rate(u8 bitrate)
+static u8 b43_calc_fallback_rate(u8 bitrate, int gmode)
 {
        switch (bitrate) {
        case B43_CCK_RATE_1MB:
@@ -216,8 +216,16 @@ static u8 b43_calc_fallback_rate(u8 bitrate)
                return B43_CCK_RATE_2MB;
        case B43_CCK_RATE_11MB:
                return B43_CCK_RATE_5MB;
+
+       /*
+        * Don't just fallback to CCK; it may be in 5GHz operation
+        * and falling back to CCK won't work out very well.
+        */
        case B43_OFDM_RATE_6MB:
-               return B43_CCK_RATE_5MB;
+               if (gmode)
+                       return B43_CCK_RATE_5MB;
+               else
+                       return B43_OFDM_RATE_6MB;
        case B43_OFDM_RATE_9MB:
                return B43_OFDM_RATE_6MB;
        case B43_OFDM_RATE_12MB:
@@ -438,7 +446,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,

                rts_rate = rts_cts_rate ? rts_cts_rate->hw_value :
B43_CCK_RATE_1MB;
                rts_rate_ofdm = b43_is_ofdm_rate(rts_rate);
-               rts_rate_fb = b43_calc_fallback_rate(rts_rate);
+               rts_rate_fb = b43_calc_fallback_rate(rts_rate, phy->gmode);
                rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);

                if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
