Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:41552 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYLJRkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:40:18 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so878182ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 09:40:17 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: strip pointless notifier chain
Date: Wed, 10 Dec 2008 18:40:13 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1228927728.15837.10.camel@johannes.berg>
In-Reply-To: <1228927728.15837.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812101840.13977.IvDoorn@gmail.com> (sfid-20081210_184023_219499_BD8DADAC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008, Johannes Berg wrote:
> No users, so no reason to have it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  include/linux/rfkill.h |    7 ----
>  net/rfkill/rfkill.c    |   83 ++-----------------------------------------------
>  2 files changed, 5 insertions(+), 85 deletions(-)
> 
> --- everything.orig/include/linux/rfkill.h	2008-12-10 17:30:35.000000000 +0100
> +++ everything/include/linux/rfkill.h	2008-12-10 17:30:39.000000000 +0100
> @@ -149,11 +149,4 @@ static inline char *rfkill_get_led_name(
>  #endif
>  }
>  
> -/* rfkill notification chain */
> -#define RFKILL_STATE_CHANGED		0x0001	/* state of a normal rfkill
> -						   switch has changed */
> -
> -int register_rfkill_notifier(struct notifier_block *nb);
> -int unregister_rfkill_notifier(struct notifier_block *nb);
> -
>  #endif /* RFKILL_H */
> --- everything.orig/net/rfkill/rfkill.c	2008-12-10 17:32:17.000000000 +0100
> +++ everything/net/rfkill/rfkill.c	2008-12-10 17:35:38.000000000 +0100
> @@ -53,51 +53,6 @@ static struct rfkill_gsw_state rfkill_gl
>  static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
>  static bool rfkill_epo_lock_active;
>  
> -static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
> -
> -
> -/**
> - * register_rfkill_notifier - Add notifier to rfkill notifier chain
> - * @nb: pointer to the new entry to add to the chain
> - *
> - * See blocking_notifier_chain_register() for return value and further
> - * observations.
> - *
> - * Adds a notifier to the rfkill notifier chain.  The chain will be
> - * called with a pointer to the relevant rfkill structure as a parameter,
> - * refer to include/linux/rfkill.h for the possible events.
> - *
> - * Notifiers added to this chain are to always return NOTIFY_DONE.  This
> - * chain is a blocking notifier chain: notifiers can sleep.
> - *
> - * Calls to this chain may have been done through a workqueue.  One must
> - * assume unordered asynchronous behaviour, there is no way to know if
> - * actions related to the event that generated the notification have been
> - * carried out already.
> - */
> -int register_rfkill_notifier(struct notifier_block *nb)
> -{
> -	BUG_ON(!nb);
> -	return blocking_notifier_chain_register(&rfkill_notifier_list, nb);
> -}
> -EXPORT_SYMBOL_GPL(register_rfkill_notifier);
> -
> -/**
> - * unregister_rfkill_notifier - remove notifier from rfkill notifier chain
> - * @nb: pointer to the entry to remove from the chain
> - *
> - * See blocking_notifier_chain_unregister() for return value and further
> - * observations.
> - *
> - * Removes a notifier from the rfkill notifier chain.
> - */
> -int unregister_rfkill_notifier(struct notifier_block *nb)
> -{
> -	BUG_ON(!nb);
> -	return blocking_notifier_chain_unregister(&rfkill_notifier_list, nb);
> -}
> -EXPORT_SYMBOL_GPL(unregister_rfkill_notifier);
> -
>  
>  static void rfkill_led_trigger(struct rfkill *rfkill,
>  			       enum rfkill_state state)
> @@ -124,12 +79,9 @@ static void rfkill_led_trigger_activate(
>  }
>  #endif /* CONFIG_RFKILL_LEDS */
>  
> -static void notify_rfkill_state_change(struct rfkill *rfkill)
> +static void rfkill_uevent(struct rfkill *rfkill)
>  {
> -	rfkill_led_trigger(rfkill, rfkill->state);
> -	blocking_notifier_call_chain(&rfkill_notifier_list,
> -			RFKILL_STATE_CHANGED,
> -			rfkill);
> +	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
>  }
>  
>  static void update_rfkill_state(struct rfkill *rfkill)
> @@ -142,7 +94,7 @@ static void update_rfkill_state(struct r
>  			oldstate = rfkill->state;
>  			rfkill->state = newstate;
>  			if (oldstate != newstate)
> -				notify_rfkill_state_change(rfkill);
> +				rfkill_uevent(rfkill);
>  		}
>  		mutex_unlock(&rfkill->mutex);
>  	}
> @@ -220,7 +172,7 @@ static int rfkill_toggle_radio(struct rf
>  	}
>  
>  	if (force || rfkill->state != oldstate)
> -		notify_rfkill_state_change(rfkill);
> +		rfkill_uevent(rfkill);
>  
>  	return retval;
>  }
> @@ -405,7 +357,7 @@ int rfkill_force_state(struct rfkill *rf
>  	rfkill->state = state;
>  
>  	if (state != oldstate)
> -		notify_rfkill_state_change(rfkill);
> +		rfkill_uevent(rfkill);
>  
>  	mutex_unlock(&rfkill->mutex);
>  
> @@ -618,28 +570,6 @@ static int rfkill_resume(struct device *
>  #define rfkill_resume NULL
>  #endif
>  
> -static int rfkill_blocking_uevent_notifier(struct notifier_block *nb,
> -					unsigned long eventid,
> -					void *data)
> -{
> -	struct rfkill *rfkill = (struct rfkill *)data;
> -
> -	switch (eventid) {
> -	case RFKILL_STATE_CHANGED:
> -		kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return NOTIFY_DONE;
> -}
> -
> -static struct notifier_block rfkill_blocking_uevent_nb = {
> -	.notifier_call	= rfkill_blocking_uevent_notifier,
> -	.priority	= 0,
> -};
> -
>  static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
> @@ -943,14 +873,11 @@ static int __init rfkill_init(void)
>  		return error;
>  	}
>  
> -	register_rfkill_notifier(&rfkill_blocking_uevent_nb);
> -
>  	return 0;
>  }
>  
>  static void __exit rfkill_exit(void)
>  {
> -	unregister_rfkill_notifier(&rfkill_blocking_uevent_nb);
>  	class_unregister(&rfkill_class);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


