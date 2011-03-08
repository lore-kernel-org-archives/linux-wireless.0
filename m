Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1CHOJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 09:09:44 -0500
Subject: Re: [RFC 1/9] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-2-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	 <1299011804-13899-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:09:39 +0100
Message-ID: <1299593379.4676.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 22:36 +0200, Eliad Peller wrote:

> + * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN (WoW) settings.
> + * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN (Wow) settings. Wake on
> + *	wireless makes use of standard Wake-on-LAN (WoL) frames, you receive
> + *	a WoW frame when your AP sends you a regular WOL frame. The difference
> + *	is you need to be associated to an AP in order to receive WoW frames,
> + *	so additional triggers are available for a wakeup.
> + *	A driver capable of WoW should initialize the wiphy with its supported
> + *	WoW triggers. Upon suspend cfg80211 will inform the driver of the user
> + *	enabled triggers. By default no WoW triggers are enabled.
> + *	For more information see:
> + *	http://wireless.kernel.org/en/users/Documentation/WoW

I wonder if we should restrict setting some WOW triggers to when we're
associated?

> + * @NL80211_ATTR_WOW_TRIGGERS_SUPPORTED: the supported WoW triggers
> + * @NL80211_ATTR_WOW_TRIGGERS_ENABLED: used by %NL80211_CMD_SET_WOW to
> + *	indicate which WoW triggers should be enabled. This is also
> + *	used by %NL80211_CMD_GET_WOW to get the currently enabled WoW
> + *	triggers.

These are u32 now (I think?), but I think they should be nested
attributes to allow nesting more data like pattern matching etc. without
using more global attributes.

> +/**
> + * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
> + *
> + * @NL80211_WOW_TRIGGER_MAGIC_PACKET: wake up when a magic packet is received.
> + * @NL80211_WOW_TRIGGER_BMISS: wake up on a beacon loss.
> + * @NL80211_WOW_TRIGGER_ANYTHING: wake up by any irq. in this mode there is no
> + *	need for any special hw support but staying up while the host is being
> + *	suspended. however, any hw capability might be used in order to avoid
> + *	unnecessary wake-ups (e.g. beacon-filtering, arp-filtering, etc.)
> + */
> +enum nl80211_wow_triggers {
> +	NL80211_WOW_TRIGGER_MAGIC_PACKET	= 1 << 0,
> +	NL80211_WOW_TRIGGER_BMISS		= 1 << 1,
> +	NL80211_WOW_TRIGGER_ANYTHING		= 1 << 2,
> +};

They can be nla flags in the nested struct then.

> - * @suspend: wiphy device needs to be suspended
> + * @suspend: wiphy device needs to be suspended.
> + *	@wow will contain the enabled Wake-on-Wireless triggers that should
> + *	be configured to the device.
>   * @resume: wiphy device needs to be resumed
> + *	@wow will contain the enabled Wake-on-Wireless triggers that were
> + *	configured to the device (it does not tell what was the actual
> + *	wake-up reason).

Why does resume need to get the triggers? That seems pointless? If the
driver really needs them it can just store them somewhere? Also, I think
we should somehow allow the driver to give us information about why it
woke up, if it was actually the cause for the system wakeup. That could
be valuable input for a suspend daemon, I think?

> +static int nl80211_set_wow(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	u32 requested_trig, supported_trig;
> +
> +	if (!info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED])
> +		return -EINVAL;
> +
> +	requested_trig =
> +		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
> +	supported_trig = rdev->wiphy.supported_wow_triggers;
> +
> +	/* check for unsupported triggers */
> +	if ((requested_trig & supported_trig) != requested_trig)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Apply changes.
> +	 * This information gets passed to the drivers during suspend.
> +	 */
> +	rdev->wow.enabled_triggers = requested_trig;

I think it might be worthwhile to allow drivers to validate the settings
here? Otherwise, we have to have absolutely perfect advertising. Magic
packet for instance can also require match patterns in some cases, as
far as I've seen. Alternatively, how about we just leave all of this
complexity out for a first draft -- wl12xx won't support it anyway.

> @@ -93,7 +93,7 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
>  
>  	if (rdev->ops->suspend) {
>  		rtnl_lock();
> -		ret = rdev->ops->suspend(&rdev->wiphy);
> +		ret = rdev->ops->suspend(&rdev->wiphy, &rdev->wow);
>  		rtnl_unlock();
>  	}
>  
> @@ -112,7 +112,7 @@ static int wiphy_resume(struct device *dev)
>  
>  	if (rdev->ops->resume) {
>  		rtnl_lock();
> -		ret = rdev->ops->resume(&rdev->wiphy);
> +		ret = rdev->ops->resume(&rdev->wiphy, &rdev->wow);

Should we pass NULL if no triggers were configured? That makes for an
easy check in the driver. Alternatively, there's no reason to be passing
the wow struct at all -- we could just store it in the wiphy instead of
here and the driver will have access.


One thing I'm a bit worried about is this with multiple interfaces, and
interface dependent triggers. iwlagn, for example, will only support a
single connection (as far as I know right now), and wake up when the
connection is lost. This wakeup event might not even be configurable. Do
we therefore need something like "wow profiles" that contain a set of
wakeup triggers etc?

johannes

