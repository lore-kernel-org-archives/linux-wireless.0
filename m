Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:17820 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753869AbcKUOrq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 09:47:46 -0500
Subject: Re: [PATCH] ath9k: Prevent radar detection and spectral scan to be
 used concurrently
To: Benjamin Berg <benjamin@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20161121140423.24367-1-benjamin@sipsolutions.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <7d04126f-0f24-b4a4-6d13-6f52046d7671@neratec.com> (sfid-20161121_154750_012117_8212F7EB)
Date: Mon, 21 Nov 2016 15:41:43 +0100
MIME-Version: 1.0
In-Reply-To: <20161121140423.24367-1-benjamin@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------81DB7B8680E9662AC7B071A0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------81DB7B8680E9662AC7B071A0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 11/21/2016 03:04 PM, Benjamin Berg wrote:
> In the case that a spectral scan is enabled the PHY errors sent by the
> hardware as part of the scanning might trigger the radar detection and
> channels might be marked as 'unusable' incorrectly. This patch fixes
> the issue by preventing the spectral scan to be enabled if DFS is used
> and only analysing the PHY errors for DFS if radar detection is enabled.
> 
> [...]

>From the relevant source code portion in channel.c:ath_set_channel()

80         /* Enable radar pulse detection if on a DFS channel. Spectral
81          * scanning and radar detection can not be used concurrently.
82          */
83         if (hw->conf.radar_enabled) {
84                 u32 rxfilter;
85
86                 rxfilter = ath9k_hw_getrxfilter(ah);
87                 rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
88                                 ATH9K_RX_FILTER_PHYERR;
89                 ath9k_hw_setrxfilter(ah, rxfilter);
90                 ath_dbg(common, DFS, "DFS enabled at freq %d\n",
91                         chan->center_freq);
92         } else {
93                 /* perform spectral scan if requested. */
94                 if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
95                         sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
96                         ath9k_cmn_spectral_scan_trigger(common, &sc->spec_priv);
97         }

it seems that spectral can't ever be activated while operating on a DFS channel.

If you need to catch the opposite case, i.e. prevent feeding pseudo-radar pulses
into the pattern detector, you just need to ensure that they depend on
hw->conf.radar_enabled. A patch like the attached one should be enough.


Cheers,
Zefir

--------------81DB7B8680E9662AC7B071A0
Content-Type: text/x-patch;
 name="0001-ath9k-feed-DFS-detector-only-if-operating-on-radar-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ath9k-feed-DFS-detector-only-if-operating-on-radar-c.pa";
 filename*1="tch"

>From c24edf82e1f509490ba9dd3e34eec3ac3b309321 Mon Sep 17 00:00:00 2001
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Date: Mon, 21 Nov 2016 15:33:45 +0100
Subject: [PATCH] ath9k: feed DFS detector only if operating on radar channel

---
 drivers/net/wireless/ath/ath9k/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6697342..e4701a7 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -867,7 +867,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * can be dropped.
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
-		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
+		if (hw->conf.radar_enabled)
+			ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
 		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
-- 
2.7.4


--------------81DB7B8680E9662AC7B071A0--
