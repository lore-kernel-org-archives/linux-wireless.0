Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:26032 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYHCHqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:46:52 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2000100ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:46:51 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 6/8] rfkill: use the new WARN()
Date: Sun, 3 Aug 2008 10:10:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-7-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217700664-20792-7-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031010.14048.IvDoorn@gmail.com> (sfid-20080803_094655_291820_8D7A349C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Switch use of WARN_ON(1) to the new WARN() macro.  Do this on a separate
> patch to make rfkill backports easier on trees like wireless-compat.

I rather see it merged into the other patch, backporting shouldn't really
be kept in mind for development for the next kernel.
The WARN() macro can easily be backported, and it doesn't make a real difference
if this patch is provided seperately or merged with the pevious one.
Both patches will end up in the same backport package anyway ;)

> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |   28 +++++++++++++++++++++-------
>  1 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index d5f95cb..88368c4 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -204,7 +204,9 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  		 * RFKILL_STATE_HARD_BLOCKED */
>  		break;
>  	default:
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal state %d passed as parameter "
> +			"to rfkill_toggle_radio\n", state);
>  		return -EINVAL;
>  	}
>  
> @@ -240,7 +242,9 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>  	struct rfkill *rfkill;
>  
>  	if (unlikely(state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX)) {
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal state %d or type %d passed as "
> +			"parameter to __rfkill_switch_all\n", state, type);
>  		return;
>  	}
>  
> @@ -341,7 +345,9 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
>  
>  	BUG_ON(!rfkill);
>  	if (unlikely(state >= RFKILL_STATE_MAX)) {
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal state %d passed as parameter "
> +			"to rfkill_force_state\n", state);
>  		return -EINVAL;
>  	}
>  
> @@ -600,7 +606,9 @@ static int rfkill_check_duplicity(const struct rfkill *rfkill)
>  
>  	list_for_each_entry(p, &rfkill_list, node) {
>  		if (p == rfkill) {
> -			WARN_ON(1);
> +			WARN(1, KERN_WARNING
> +				"rfkill: illegal attempt to register "
> +				"an already registered rfkill struct\n");
>  			return -EEXIST;
>  		}
>  		set_bit(p->type, seen);
> @@ -671,7 +679,9 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
>  	struct device *dev;
>  
>  	if (type >= RFKILL_TYPE_MAX) {
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal type %d passed as parameter "
> +			"to rfkill_allocate\n", type);
>  		return NULL;
>  	}
>  
> @@ -751,7 +761,9 @@ int __must_check rfkill_register(struct rfkill *rfkill)
>  		     !rfkill->toggle_radio ||
>  		     rfkill->type >= RFKILL_TYPE_MAX ||
>  		     rfkill->state >= RFKILL_STATE_MAX)) {
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: attempt to register a "
> +			"badly initialized rfkill struct\n");
>  		return -EINVAL;
>  	}
>  
> @@ -827,7 +839,9 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
>  	if (type >= RFKILL_TYPE_MAX ||
>  	    (state != RFKILL_STATE_SOFT_BLOCKED &&
>  	     state != RFKILL_STATE_UNBLOCKED)) {
> -		WARN_ON(1);
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal state %d or type %d passed as "
> +			"parameter to rfkill_set_default\n", state, type);
>  		return -EINVAL;
>  	}
>  


