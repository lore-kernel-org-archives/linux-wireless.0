Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2597 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZGODdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 23:33:52 -0400
Subject: Re: [PATCH 3/3] ath9k: Add support for AR9287 based chipsets.
From: Joe Perches <joe@perches.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090715032412.GE4613@myhost>
References: <20090715032412.GE4613@myhost>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 20:28:32 -0700
Message-Id: <1247628512.3669.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-15 at 08:54 +0530, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
> index 1f0c5fe..d1bbb02 100644
> --- a/drivers/net/wireless/ath/ath9k/calib.c
> +++ b/drivers/net/wireless/ath/ath9k/calib.c
> @@ -116,7 +116,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
>  				"NF calibrated [ctl] [chain 1] is %d\n", nf);
>  		nfarray[1] = nf;
>  
> -		if (!AR_SREV_9280(ah)) {
> +		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {

This looks like it needs a helper function like IS_AR_SREV_928x(ah)

> +		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
> +	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah))
> +		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)

etc

