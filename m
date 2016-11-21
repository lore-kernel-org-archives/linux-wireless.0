Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:64204 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932262AbcKUQQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 11:16:51 -0500
Subject: Re: [ath9k-devel] [PATCH] ath9k: Prevent radar detection and spectral
 scan to be used concurrently
To: Michal Kazior <michal.kazior@tieto.com>
References: <20161121140423.24367-1-benjamin@sipsolutions.net>
 <7d04126f-0f24-b4a4-6d13-6f52046d7671@neratec.com>
 <CA+BoTQm5do0pfMpQ=ua=Q3Uomd2jV6_xbRFK=BMzUi-D5z7C+A@mail.gmail.com>
Cc: Benjamin Berg <benjamin@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <d2611789-09d7-0382-b100-46ef0a94ea41@neratec.com> (sfid-20161121_171703_170422_8DD67438)
Date: Mon, 21 Nov 2016 17:16:42 +0100
MIME-Version: 1.0
In-Reply-To: <CA+BoTQm5do0pfMpQ=ua=Q3Uomd2jV6_xbRFK=BMzUi-D5z7C+A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------11A569B53BEACB1640D79D21"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------11A569B53BEACB1640D79D21
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 11/21/2016 04:10 PM, Michal Kazior wrote:
> On 21 November 2016 at 15:41, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> On 11/21/2016 03:04 PM, Benjamin Berg wrote:
>>> In the case that a spectral scan is enabled the PHY errors sent by the
>>> hardware as part of the scanning might trigger the radar detection and
>>> channels might be marked as 'unusable' incorrectly. This patch fixes
>>> the issue by preventing the spectral scan to be enabled if DFS is used
>>> and only analysing the PHY errors for DFS if radar detection is enabled.
>>>
>>> [...]
>>
>> From the relevant source code portion in channel.c:ath_set_channel()
>>
>> 80         /* Enable radar pulse detection if on a DFS channel. Spectral
>> 81          * scanning and radar detection can not be used concurrently.
>> 82          */
>> 83         if (hw->conf.radar_enabled) {
>> 84                 u32 rxfilter;
>> 85
>> 86                 rxfilter = ath9k_hw_getrxfilter(ah);
>> 87                 rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
>> 88                                 ATH9K_RX_FILTER_PHYERR;
>> 89                 ath9k_hw_setrxfilter(ah, rxfilter);
>> 90                 ath_dbg(common, DFS, "DFS enabled at freq %d\n",
>> 91                         chan->center_freq);
>> 92         } else {
>> 93                 /* perform spectral scan if requested. */
>> 94                 if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
>> 95                         sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
>> 96                         ath9k_cmn_spectral_scan_trigger(common, &sc->spec_priv);
>> 97         }
>>
>> it seems that spectral can't ever be activated while operating on a DFS channel.
>>
>> If you need to catch the opposite case, i.e. prevent feeding pseudo-radar pulses
>> into the pattern detector, you just need to ensure that they depend on
>> hw->conf.radar_enabled. A patch like the attached one should be enough.
> 
> Good point. I guess set_channel could be oversimplified as well. I
> mean, it makes sense to consider radar and spectral mutually exclusive
> if they use the same phyerr code. However some chips actually seem (as
> per the comment I mentioned) to distinguish the two so I don't know if
> the "mutually exclusive" is true for all chips per se. Just thinking
> out loud.
> 
You're right, blindly feeding PHYERR frames to spectral when spectral is not
enabled is as wrong as feeding them to the dfs-detector when not on a radar
channel. Therefore, the patch I proposed should be extended to make calling
ath_cmn_process_fft() depending on
a) not operating on radar channel, and
b) spectral scan is enabled

Updated patch attached as proposal.

> I also wonder if calling ieee80211_radar_detect() should have any
> effect if there are no radar operated interfaces in the first place?
> 
True, calling ieee80211_radar_detect() for a non-DFS channel is (or should be)
ignored by mac. But feeding the dfs-detector with invalid pulses causes quite some
computational overhead - dropping them if no radar detection is required is a good
thing to do.


Cheers,
Zefir





--------------11A569B53BEACB1640D79D21
Content-Type: text/x-patch;
 name="0001-ath9k-feed-DFS-detector-only-if-operating-on-radar-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ath9k-feed-DFS-detector-only-if-operating-on-radar-c.pa";
 filename*1="tch"

>From aaa28dcaf0879c6bfc7be96077c79894bb230dfb Mon Sep 17 00:00:00 2001
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Date: Mon, 21 Nov 2016 15:33:45 +0100
Subject: [PATCH] ath9k: feed DFS detector only if operating on radar channel

---
 drivers/net/wireless/ath/ath9k/recv.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6697342..48f8af1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -867,10 +867,21 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * can be dropped.
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
-		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
+		/*
+		 * DFS and spectral are mutually exclusive
+		 *
+		 * Since some chips use RXERR_PHY as indication for both, we
+		 * need to double check which feature is enabled to prevent
+		 * feeding spectral or dfs-detector with wrong frames.
+		 */
+		if (hw->conf.radar_enabled) {
+			ath9k_dfs_process_phyerr(sc, hdr, rx_stats,
+						 rx_status->mactime);
+		} else if (sc->spec_priv.spectral_mode != SPECTRAL_DISABLED &&
+			   ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats,
+					       rx_status->mactime)) {
 			RX_STAT_INC(rx_spectral);
-
+		}
 		return -EINVAL;
 	}
 
-- 
2.7.4


--------------11A569B53BEACB1640D79D21--
