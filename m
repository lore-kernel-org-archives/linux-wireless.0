Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33352 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdEISQc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 14:16:32 -0400
Received: by mail-ua0-f174.google.com with SMTP id e28so9651367uah.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 11:16:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mike@hellotwist.com
From: Michael Skeffington <mike@astro.ai>
Date: Tue, 9 May 2017 14:16:31 -0400
Message-ID: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com> (sfid-20170509_201636_052277_C75F492F)
Subject: [PATCH] mac80211: Validate michael MIC before attempting packet decode.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to allow wpa_supplicant to correctly identify a perceived WPA TKIP key
recovery attack the michael MIC must be checked before the packet decode is
attempted.  A packet with an invalid MIC will always fail a decrypt check which
previously was being checked first.  Therefore the MIC failure bit of
status flags
describing the error would remain unset.

Signed-off-by: Michael Skeffington <mike@hellotwist.com>

---

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc08185..71f1a56 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3176,9 +3176,10 @@ static void ieee80211_rx_handlers(struct
ieee80211_rx_data *rx,
                CALL_RXH(ieee80211_rx_h_check_more_data)
                CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
                CALL_RXH(ieee80211_rx_h_sta_process)
+               /* must be before decrypt so MIC failures are reported
to netlink */
+               CALL_RXH(ieee80211_rx_h_michael_mic_verify)
                CALL_RXH(ieee80211_rx_h_decrypt)
                CALL_RXH(ieee80211_rx_h_defragment)
-               CALL_RXH(ieee80211_rx_h_michael_mic_verify)
                /* must be after MMIC verify so header is counted in MPDU mic */
 #ifdef CONFIG_MAC80211_MESH
                if (ieee80211_vif_is_mesh(&rx->sdata->vif))
