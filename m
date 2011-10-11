Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:55101 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942Ab1JKQSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 12:18:45 -0400
Received: by mail-bw0-f51.google.com with SMTP id zu17so11992826bkb.24
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 09:18:43 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Luciano Coelho <coelho@ti.com>
To: Shahar Lev <shahar@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318344193.9690.528.camel@cumari>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
	 <1318344193.9690.528.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 19:18:40 +0300
Message-ID: <1318349920.9690.529.camel@cumari> (sfid-20111011_181848_316279_148E6DE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 17:43 +0300, Luciano Coelho wrote: 
> On Fri, 2011-10-07 at 18:17 +0200, Shahar Lev wrote: 
> > mac80211 sets the carrier on an IBSS interface even when no network is
> > joined. Ignore garbage frames transmitted on a disconnected IBSS
> > interface without printing warnings.
> > 
> > Signed-off-by: Shahar Lev <shahar@wizery.com>
> > ---
> 
> Applied, thanks!

Actually I had to merge this with Eliad's vif patches, so I did this
before applying:

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1bc00ca..27a45e1 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -429,7 +429,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
        hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
        if (hlid == WL12XX_INVALID_LINK_ID) {
                if (wlvif->bss_type == BSS_TYPE_IBSS &&
-                   !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) {
+                   !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) {
                        /* It's ok to drop packets when not joined to IBSS */
                        wl1271_debug(DEBUG_TX, "dropping skb while IBSS not "
                                     " joined");


-- 
Cheers,
Luca.

