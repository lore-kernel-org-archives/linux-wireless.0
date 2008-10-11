Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8853 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYJKNyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:54:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so448350nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 06:54:00 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/5] rfkill: honour EPO state when resuming a rfkill controller
Date: Sat, 11 Oct 2008 15:53:50 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> <1223586933-17753-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1223586933-17753-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810111553.51049.IvDoorn@gmail.com> (sfid-20081011_155416_356909_4F086B03)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 October 2008, Henrique de Moraes Holschuh wrote:
> rfkill_resume() would always restore the rfkill controller state to its
> pre-suspend state.
> 
> Now that we know when we are under EPO, kick the rfkill controller to
> SOFT_BLOCKED state instead of to its pre-suspend state when it is resumed
> while EPO mode is active.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index e348eab..c9180c8 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -581,8 +581,17 @@ static int rfkill_resume(struct device *dev)
>  
>  		dev->power.power_state.event = PM_EVENT_ON;
>  
> -		/* restore radio state AND notify everybody */
> -		rfkill_toggle_radio(rfkill, rfkill->state, 1);
> +		/*
> +		 * If we are under EPO, kick transmitter offline,
> +		 * otherwise restore to pre-suspend state.
> +		 *
> +		 * Issue a notification in any case
> +		 */
> +		rfkill_toggle_radio(rfkill,
> +				rfkill_epo_lock_active ?
> +					RFKILL_STATE_SOFT_BLOCKED :
> +					rfkill->state,
> +				1);
>  
>  		mutex_unlock(&rfkill->mutex);
>  	}


