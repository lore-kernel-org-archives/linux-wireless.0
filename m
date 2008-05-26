Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbYEZRdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 13:33:42 -0400
Date: Mon, 26 May 2008 19:29:14 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linville@tuxdriver.com, rusty@rustcorp.com.au, matthew@wil.cx,
	mingo@elte.hu, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Message-ID: <20080526192914.31045d09@brian.englab.brq.redhat.com> (sfid-20080526_193345_618063_88410679)
In-Reply-To: <20080522232103.120033152@mvista.com>
References: <20080522232103.120033152@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 May 2008 16:21:03 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> Signed-off-by: Daniel Walker <dwalker@mvista.com>
>  
> ---
>  drivers/net/wireless/airo.c |  107
> ++++++++++++++++++++++---------------------- 1 file changed, 54
> insertions(+), 53 deletions(-)
> 
> Index: linux-2.6.25/drivers/net/wireless/airo.c
> ===================================================================
> --- linux-2.6.25.orig/drivers/net/wireless/airo.c
> +++ linux-2.6.25/drivers/net/wireless/airo.c

> @@ -3211,7 +3212,7 @@ static irqreturn_t airo_interrupt(int ir
>  				set_bit(FLAG_UPDATE_UNI,
> &apriv->flags); set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
>  
> -				if (down_trylock(&apriv->sem) != 0) {
> +				if (mutex_trylock(&apriv->lock) ==
> 0) { set_bit(JOB_EVENT, &apriv->jobs);
>  					wake_up_interruptible(&apriv->thr_wait);
>  				} else


Mutexes are not allowed in interrupt context, not even mutex_trylock.

Michal
