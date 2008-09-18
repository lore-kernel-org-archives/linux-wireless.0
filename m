Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:5803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYIRMth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 08:49:37 -0400
Received: by nf-out-0910.google.com with SMTP id d3so2003723nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 05:49:35 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
Date: Thu, 18 Sep 2008 14:49:31 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809181449.31495.IvDoorn@gmail.com> (sfid-20080918_144942_332260_B56987E0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 September 2008, Henrique de Moraes Holschuh wrote:
> The LED state was not being updated by rfkill_force_state(), which will
> cause regressions in wireless drivers that had old-style rfkill support and
> are updated to use rfkill_force_state().
> 
> The LED state was not being updated when a change was detected through the
> rfkill->get_state() hook, either.
> 
> Move the LED trigger update calls into notify_rfkill_state_change(), where
> it should have been in the first place.  This takes care of both issues.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
>  John, this one is quite likely something that should be sent for
>  merge in mainline BEFORE 2.6.27 is released.
> 
>  I am NOT sure it fixes regressions, that depends on whether the drivers
>  using rfkill that are in 2.6.27 had working LED support before rfkill
>  support was added to them.  Unfortunately, it cannot fix the b43
>  regression by itself.
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ea0dc04..f949a48 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -125,6 +125,7 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
>  
>  static void notify_rfkill_state_change(struct rfkill *rfkill)
>  {
> +	rfkill_led_trigger(rfkill, rfkill->state);
>  	blocking_notifier_call_chain(&rfkill_notifier_list,
>  			RFKILL_STATE_CHANGED,
>  			rfkill);
> @@ -217,10 +218,8 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  			rfkill->state = state;
>  	}
>  
> -	if (force || rfkill->state != oldstate) {
> -		rfkill_led_trigger(rfkill, rfkill->state);
> +	if (force || rfkill->state != oldstate)
>  		notify_rfkill_state_change(rfkill);
> -	}
>  
>  	return retval;
>  }


