Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:7644 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYGVOiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 10:38:17 -0400
Received: by gv-out-0910.google.com with SMTP id e6so139737gvc.37
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 07:38:13 -0700 (PDT)
Message-ID: <4885F055.8000304@gmail.com> (sfid-20080722_163824_213910_6E2D674A)
Date: Tue, 22 Jul 2008 16:36:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 12/12] ath5k: Fix a compilation error after reg list update
References: <20080720035221.GL7440@makis>
In-Reply-To: <20080720035221.GL7440@makis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2008 05:52 AM, Nick Kossifidis wrote:
>  Last minute fix...
> 
>  AR5K_CPCORN is changed to AR5K_CPCOVF in reg list update so we have to update debug.c in order to compile
> 
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> ---
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index 41d5fa3..6fa6c8e 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -129,7 +129,7 @@ static struct reg regs[] = {
>  	REG_STRUCT_INIT(AR5K_CPC1),
>  	REG_STRUCT_INIT(AR5K_CPC2),
>  	REG_STRUCT_INIT(AR5K_CPC3),
> -	REG_STRUCT_INIT(AR5K_CPCORN),
> +	REG_STRUCT_INIT(AR5K_CPCOVF),
>  	REG_STRUCT_INIT(AR5K_RESET_CTL),
>  	REG_STRUCT_INIT(AR5K_SLEEP_CTL),
>  	REG_STRUCT_INIT(AR5K_INTPEND),

Please amend this to the patch 1 to not break bisectability.
