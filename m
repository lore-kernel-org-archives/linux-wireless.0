Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38545 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbaEVNPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:15:34 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jim.epost@gmail.com
Subject: Re: [PATCH] ath9k: fix build error with disabled debug
References: <1400668835-22335-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Thu, 22 May 2014 16:15:31 +0300
In-Reply-To: <1400668835-22335-1-git-send-email-zefir.kurtisi@neratec.com>
	(Zefir Kurtisi's message of "Wed, 21 May 2014 12:40:35 +0200")
Message-ID: <877g5e3qfg.fsf@purkki.adurom.net> (sfid-20140522_151544_864477_08AA8075)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> DFS pulse interval printing is only available
> when CONFIG_ATH9K_DEBUGFS is set.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

[...]

> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -178,12 +178,14 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
>  	pe.ts = mactime;
>  	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
>  		struct dfs_pattern_detector *pd = sc->dfs_detector;
> +#ifdef CONFIG_ATH9K_DEBUGFS

IMHO config_enabled() is much nicer than ifdef.

-- 
Kalle Valo
