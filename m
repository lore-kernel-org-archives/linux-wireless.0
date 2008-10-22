Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:14778 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbYJVRGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:06:04 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2056414ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 10:06:02 -0700 (PDT)
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] RFKILL: fix input layer initialisation
Date: Wed, 22 Oct 2008 19:05:58 +0200
Cc: linux-wireless@vger.kernel.org, linux-input@vger.kernel.org
References: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810221905.58169.IvDoorn@gmail.com> (sfid-20081022_190626_371668_774F35DF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 October 2008, Dmitry Baryshkov wrote:
> Initialise correctly last fields, so tasks can be actually executed.
> On some architectures the initial jiffies value is not zero, so later
> all rfkill incorrectly decides that rfkill_*.last is in future.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  net/rfkill/rfkill-input.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index e5b6955..cd93f48 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -255,6 +255,11 @@ static struct input_handler rfkill_handler = {
>  
>  static int __init rfkill_handler_init(void)
>  {
> +	unsigned long last_run = jiffies - msecs_to_jiffies(500);
> +	rfkill_wlan.last = last_run;
> +	rfkill_bt.last = last_run;
> +	rfkill_uwb.last = last_run;
> +	rfkill_wimax.last = last_run;
>  	return input_register_handler(&rfkill_handler);
>  }

I believe Dmitry Torokhov recently moved the rfkill structures for wlan, bt, etc
into an array which allowed for easy looping through all structures. That would
make updating all entries easier (and less prone to errors when a new structure
is added).

Could you rebase thise patch on top of that one?
Thanks,

Ivo
