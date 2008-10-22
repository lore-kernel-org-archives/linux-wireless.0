Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40121 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757058AbYJVRPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:15:08 -0400
Date: Wed, 22 Oct 2008 15:15:02 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] RFKILL: fix input layer initialisation
Message-ID: <20081022171502.GD1069@khazad-dum.debian.net> (sfid-20081022_191520_607032_A30AEECB)
References: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 Oct 2008, Dmitry Baryshkov wrote:
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

This is not needed for wireless-testing's rfkill-input.

It is needed on 2.6.28, since AFAIK the stuff in wireless-testing is not
going to be sent for 2.6.28.

A similar patch to this was sent not a month ago, I think.  One of the two
needs to be merged for 2.6.28.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
