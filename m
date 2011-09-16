Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1IPNhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 09:37:32 -0400
Subject: Re: [PATCH] rfkill: properly assign a boolean type
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 15:37:17 +0200
Message-ID: <1316180237.4130.37.camel@jlt3.sipsolutions.net> (sfid-20110916_153734_506350_68AF992A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 19:03 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  net/rfkill/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index be90640..5be1957 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -235,7 +235,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
>  	else
>  		rfkill->state &= ~RFKILL_BLOCK_HW;
>  	*change = prev != blocked;
> -	any = rfkill->state & RFKILL_BLOCK_ANY;
> +	any = !!(rfkill->state & RFKILL_BLOCK_ANY);

I believe this is not necessary since "any" is a "bool" and as such
should cast correctly to 0/1.

johannes

