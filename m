Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57949 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAIS5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 13:57:40 -0500
Message-ID: <54B024A1.4040809@broadcom.com> (sfid-20150109_195747_960618_0D21C704)
Date: Fri, 9 Jan 2015 19:57:37 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<kvalo@qca.qualcomm.com>, <mathias.kretschmer@fokus.fraunhofer.de>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
References: <1420822458-531-1-git-send-email-sw@simonwunderlich.de>
In-Reply-To: <1420822458-531-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/15 17:54, Simon Wunderlich wrote:
> Performing spectral scans on 5 GHz channels may result in PHY errors
> sent by the hardware, even if DFS support is not enabled in the driver
> (e.g. channel scanning or passive monitoring). In that case channels may
> falsely get marked as 'unusable'. To fix that, only process radar PHY
> errors when radar is explicitly enabled in the driver.

Hi Simon,

Not an ath9k expert, but I would think those channels would already be 
marked as unusable, because DFS is disabled in the driver. Or does this 
also affect 5G channels that do not require DFS.

Regards,
Arend

> Cc: Stable<stable@vger.kernel.org>  [v3.10+]
> Reported-by: Mathias Kretschmer<mathias.kretschmer@fokus.fraunhofer.de>
> Signed-off-by: Simon Wunderlich<sw@simonwunderlich.de>
> ---
>   drivers/net/wireless/ath/ath9k/dfs.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> index 726271c..3d04905 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -152,6 +152,12 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
>   		return;
>   	}
>
> +	if (!sc->hw->conf.radar_enabled) {
> +		ath_dbg(common, DFS,
> +			"Error: received radar phyerr while radar was disabled\n");
> +		return;
> +	}
> +
>   	datalen = rs->rs_datalen;
>   	if (datalen == 0) {
>   		DFS_STAT_INC(sc, datalen_discards);

