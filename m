Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51719 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1B0UyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 15:54:19 -0500
Received: by bwz15 with SMTP id 15so3223999bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 12:54:17 -0800 (PST)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 2/2] staging: brcm80211: Remove unused variables and code clean up
Date: Sun, 27 Feb 2011 21:54:15 +0100
Message-Id: <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tsf_l and tsf_h variables where used in a code segment that is never compiled
so the variables remains unused. 

Remove those variables and the code never compiled as well.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c
index 464e421..69717ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c
@@ -6875,21 +6875,12 @@ static void
 prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 		     struct ieee80211_rx_status *rx_status)
 {
-	u32 tsf_l, tsf_h;
 	wlc_d11rxhdr_t *wlc_rxh = (wlc_d11rxhdr_t *) rxh;
 	int preamble;
 	int channel;
 	ratespec_t rspec;
 	unsigned char *plcp;
 
-#if 0
-	/* Clearly, this is bogus -- reading the TSF now is wrong */
-	wlc_read_tsf(wlc, &tsf_l, &tsf_h);	/* mactime */
-	rx_status->mactime = tsf_h;
-	rx_status->mactime <<= 32;
-	rx_status->mactime |= tsf_l;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU; /* clearly wrong */
-#endif
 
 	channel = WLC_CHAN_CHANNEL(rxh->RxChan);
 
-- 
1.7.2.3

