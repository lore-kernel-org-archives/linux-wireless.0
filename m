Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64826 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZAGPu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:50:27 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] mac80211: extend/document powersave API
References: <1231264395.3654.10.camel@johannes>
	<1231273502.3767.4.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 07 Jan 2009 17:49:39 +0200
In-Reply-To: <1231273502.3767.4.camel@johannes> (ext Johannes Berg's message of "Tue\, 06 Jan 2009 21\:25\:02 +0100")
Message-ID: <878wpn5d64.fsf@nokia.com> (sfid-20090107_165032_907450_A3E9C4DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> This modifies hardware flags for powersave to support three different
> flags:
>  * IEEE80211_HW_SUPPORTS_PS - indicates general PS support
>  * IEEE80211_HW_PS_NULLFUNC_STACK - indicates nullfunc/... handling in software
>  * IEEE80211_HW_SUPPORTS_DYNAMIC_PS - indicates dynamic PS on the device
>
> It also adds documentation for all this which explains how to set the
> various flags.

Very good, this is just what was needed. I was planning to add similar
flags myself. Few comments though:

> + * @IEEE80211_HW_SUPPORTS_DYNAMIC_PS:
> + *	Hardware has support for dynamic PS.

The "dynamic power save" was a very bad term, it seems that people
misunderstand it all the time. Maybe we should rename it to something
else? We can do it later, though.

> + * DOC: Powersave support
> + *
> + * mac80211 has support for various powersave implementations.
> + *
> + * First, it can support hardware that handles all powersaving by
> + * itself, such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS
> + * hardware flag. In that case, it will be told about the desired
> + * powersave mode regardless of association status, and the driver or
> + * hardware must take care of enabling/disabling powersave depending on
> + * the association status and TIM bit and send nullfunc frames by
> + itself.

Actually I'm not aware of any hardware designs which enables and
disables power save according to association status (modulo fullmac
design, of course). Even iwlwifi, which I think has the most
sophisticated power save support, requires the host to enable power
save according to the association status. Hence I would like to have
the power save enable/disable logic based on association status in
mac80211.

We already have this support in ieee80211_set_associated() 

[Reads the function again] 

Or, actually we had it. I think Vivek's patch changed the
functionality. But anyway, it's very easy to add the support back.

The reason why I would like to have this in mac80211 is to avoid
having duplicate bugs in different drivers and make the driver
implementation easier.

> + * Additionally, such hardware may set the %IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> + * flag to indicate that it can support dynamic PS mode (see below).
> + *
> + * Other hardware designs cannot send nullfunc frames by themselves and
> + * need to be told explicitly about powersave transitions depending on
> + * association status, need software support for parsing the TIM bitmap
> + * and can implement dynamic PS mode in software. This is also supported
> + * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS and
> + * %IEEE80211_HW_PS_NULLFUNC_STACK flags.

stlc45xx (and p54spi) wakeup for multicast frames automatically, but
ath5/9k need the host to do it. I think we will need a separate flag
for that, but I can add it later.

> + * Dynamic powersave mode is an extension to normal powersave mode in which
> + * the hardware stays awake for a user-specified period of time after sending
> + * a frame so that reply frames need not be buffered and therefore delayed
> + * to the next wakeup. This can either be supported by hardware, in which case
> + * the driver needs to look at the @dynamic_ps_timeout hardware configuration
> + * value, or by the stack if all nullfunc handling is in the stack.
> + */

Good description of the feature. Hopefully people now better
understand what I meant with dynamic power save.

> @@ -858,8 +861,17 @@ static int ieee80211_ioctl_siwpower(stru
>  	if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
>  		return -EINVAL;
>  
> -	if (wrq->flags & IW_POWER_TIMEOUT)
> +	if (wrq->flags & IW_POWER_TIMEOUT) {
> +		/*
> +		 * dynamic PS only supported if nullfunc handling in stack
> +		 * or hardware supports dynamic PS itself
> +		 */
> +		if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
> +		    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +			return -EOPNOTSUPP;
> +
>  		timeout = wrq->value / 1000;
> +	}

Actually there are hardware designs which don't have dynamic power
save but have null frame creation in firmware (and hence don't need
IEEE80211_HW_PS_NULLFUNC_STACK). So IEEE80211_HW_SUPPORTS_DYNAMIC_PS
and IEEE80211_HW_PS_NULLFUNC_STACK are not related to each other in
any way. I suspect at76_usb is such design, but I need to recheck
that.

So I would like to implement this so that if
IEEE80211_HW_SUPPORTS_DYNAMIC_PS is not set mac80211 will always use
it's own timer, independent of IEEE80211_HW_PS_NULLFUNC_STACK. If you
agree, I can create a separate patch for this.

-- 
Kalle Valo
