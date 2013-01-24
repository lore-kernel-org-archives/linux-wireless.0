Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42205 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3AXGrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 01:47:45 -0500
Message-ID: <1359010005.6252.185.camel@cumari.coelho.fi> (sfid-20130124_074748_898490_4683A2B1)
Subject: Re: [RFC v2] cfg80211/mac80211: support reporting wakeup reason
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Thu, 24 Jan 2013 08:46:45 +0200
In-Reply-To: <1358958882-14246-1-git-send-email-johannes@sipsolutions.net>
References: <1358958882-14246-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 17:34 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When waking up from WoWLAN, it is useful to know
> what triggered the wakeup. Support reporting the
> wakeup reason(s) in cfg80211 (and a pass-through
> in mac80211) to allow userspace to know.
> 
> Change-Id: I7766f071273f3e31020395cc74eabcc6d165fa3a
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

As I asked on IRC, what are these Change-Id tags you've been using
recently? Just curious.


> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 5470171..d0752c5 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h

[...]

> @@ -2881,8 +2891,25 @@ struct nl80211_wowlan_pattern_support {
>   * @NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE: wake up on 4-way handshake (flag)
>   * @NL80211_WOWLAN_TRIG_RFKILL_RELEASE: wake up when rfkill is released
>   *	(on devices that have rfkill in the device) (flag)
> + * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211: For wakeup reporting only, contains
> + *	the 802.11 packet that caused the wakeup, e.g. a deauth frame. The frame
> + *	may be truncated, the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN
> + *	attribute contains the original length.
> + * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN: Original length of the 802.11
> + *	packet, may be bigger than the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211
> + *	attribute if the packet was truncated somewhere.
> + * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023: For wakeup reporting only, contains the
> + *	802.11 packet that caused the wakeup, e.g. a magic packet. The frame may
> + *	be truncated, the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8022_LEN attribute
> + *	contains the original length.
> + * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8022_LEN: Original length of the 802.3
> + *	packet, may be bigger than the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023
> + *	attribute if the packet was truncated somewhere.

This seems wrong.  Why PKT_8023 and PKT_8022_LEN?

Also, is there any specific reason you want to know the original length?
Just to check whether the packet was truncated or not?



>   * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
>   * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
> + *
> + * These nested attributes are used to configure the wakeup triggers and
> + * to report the wakeup reason(s).
>   */
>  enum nl80211_wowlan_triggers {
>  	__NL80211_WOWLAN_TRIG_INVALID,
> @@ -2895,6 +2922,10 @@ enum nl80211_wowlan_triggers {
>  	NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST,
>  	NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE,
>  	NL80211_WOWLAN_TRIG_RFKILL_RELEASE,
> +	NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211,
> +	NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN,
> +	NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023,
> +	NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023_LEN,

This confirms my suspicion that the doc was wrong. ;)

--
Cheers,
Luca.

