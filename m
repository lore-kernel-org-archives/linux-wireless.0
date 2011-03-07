Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:46855 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab1CGRWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 12:22:09 -0500
Subject: Re: Powersave broken on p54
From: Michael Buesch <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kvalo@adurom.com, Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201103021918.30528.chunkeey@googlemail.com> (sfid-20110302_191848_281080_21A09A7E)
References: <1299003142.6461.12.camel@maggie>
	 <201103021813.52719.chunkeey@googlemail.com>
	 <1299086257.13604.17.camel@marge>
	 <201103021918.30528.chunkeey@googlemail.com>
	 (sfid-20110302_191848_281080_21A09A7E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 18:22:00 +0100
Message-ID: <1299518520.5665.16.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 19:18 +0100, Christian Lamparter wrote:
> Not sure, don't have any hardware to play with ATM.
> But maybe the attached "hack" helps a bit?
> ---
> diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
> index 2fab7d2..df56a82 100644
> --- a/drivers/net/wireless/p54/fwio.c
> +++ b/drivers/net/wireless/p54/fwio.c
> @@ -615,8 +615,8 @@ int p54_set_ps(struct p54_common *priv)
>  	psm->mode = cpu_to_le16(mode);
>  	psm->aid = cpu_to_le16(priv->aid);
>  	for (i = 0; i < ARRAY_SIZE(psm->intervals); i++) {
> -		psm->intervals[i].interval =
> -			cpu_to_le16(priv->hw->conf.listen_interval);
> +		psm->intervals[i].interval = cpu_to_le16(1);
> +//			cpu_to_le16(priv->hw->conf.listen_interval);
>  		psm->intervals[i].periods = cpu_to_le16(1);
>  	}

This doesn't help.


-- 
Greetings, Michael.

