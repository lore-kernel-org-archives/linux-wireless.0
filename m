Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab2INOv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 10:51:26 -0400
Message-ID: <50534465.3080205@qca.qualcomm.com> (sfid-20120914_165130_225207_32BAA274)
Date: Fri, 14 Sep 2012 20:21:17 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Fix mesh related filtering issue for older chips
References: <1347633965-20218-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1347633965-20218-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 September 2012 08:16 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> We need to have the promiscus mode enabled for older
> chipset(ie rule out many frames being filtered in the
> hardware itself)if 'FIF_OTHER_BSS' flag is set, when we
> start the mesh mode. Fix this by enabling promiscus
> mode for all chipsets whose macversion <= AR9160
> chipsets. This should fix
> https://bugzilla.kernel.org/show_bug.cgi?id=45591
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 4480c0c..76db0b3 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -424,8 +424,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>   		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
>
>   	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
> -		/* The following may also be needed for other older chips */
> -		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
> +		/* This is needed for older chips, especially for mesh mode */
> +		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
>   			rfilt |= ATH9K_RX_FILTER_PROM;
>   		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
>   	}
>

John, kindly drop this. Had resent the v2 with proper author
name (Thomas) who suggested the change.


-- 
thanks,
shafi


