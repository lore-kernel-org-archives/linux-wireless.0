Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:1076 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYGWSLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:11:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so929008nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 11:11:34 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: add default global states
Date: Wed, 23 Jul 2008 20:28:49 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216775046-9506-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807232028.49239.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  #endif /* __RFKILL_INPUT_H */
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 0a78e32..eaaabbd 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -45,6 +45,8 @@ MODULE_PARM_DESC(default_state,
>  		 "Default initial state for all radio types, 0 = radio off");
>  
>  static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
> +static enum rfkill_state rfkill_default_states[RFKILL_TYPE_MAX];
> +static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];

I have a slight distaste for using multiple arrays where each variable is a different
variable for the same object. Perhaps it is time to move it into a structure:

struct .. {
	enum rfkill_state current
	enum rfkill_state default
};

static struct .. rfkill_states[RFKILL_TYPE_MAX];

It probably won't optimize anything, but I think it looks a bit nicer.

Just a suggestion, if it easier to keep it as multiple arrays I would still ack it. ;)

>  	list_add_tail(&rfkill->node, &rfkill_list);
> @@ -689,6 +737,49 @@ void rfkill_unregister(struct rfkill *rfkill)
>  }
>  EXPORT_SYMBOL(rfkill_unregister);
>  
> +/**
> + * rfkill_set_default - set initial value for a switch type
> + * @type - the type of switch to set the default state of
> + * @state - the new default state for that group of switches
> + *
> + * Sets the initial state rfkill should use for a given type.  Only "soft"
> + * states are allowed, i.e. RFKILL_STATE_SOFT_BLOCKED and
> + * RFKILL_STATE_UNBLOCKED.
> + *
> + * This function is meant to be used by platform drivers for platforms that
> + * can save switch state across power down/reboot.

As sideinfo: I found a hardware bug in a broadcom rfkill key a few days ago
which would not work well with this function:

* laptop was powered on, HW rfkill was set to allow WiFi
* laptop halted, something about a missing power supply and a battery which was drained
	without any userspace tool checking the battery status. ;)
* laptop was powered on and booted,  HW rkfill decided to block WiFi.

In any case not really important for this patch, but just for information. ;)

>   * Rfkill module initialization/deinitialization.
>   */
> @@ -702,8 +793,8 @@ static int __init rfkill_init(void)
>  	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
>  		return -EINVAL;
>  
> -	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
> -		rfkill_states[i] = rfkill_default_state;
> +	for (i = 0; i < ARRAY_SIZE(rfkill_default_states); i++)
> +		rfkill_default_states[i] = rfkill_default_state;

rfkill_states[] is now no longer initialized, I guess that is a bad thing ;)

The rest of the patch looks good.

Ivo
