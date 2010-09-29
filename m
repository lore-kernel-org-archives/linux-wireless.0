Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0I2HKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 03:10:20 -0400
Subject: Re: [RFC] mac80211: fix rx monitor filter refcounters
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201009281836.24529.chunkeey@googlemail.com>
References: <201009281836.24529.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 09:10:18 +0200
Message-ID: <1285744218.3756.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 18:36 +0200, Christian Lamparter wrote:
> This patch fixes a refcounter & commit bug when monitor
> rx flags are changed by:
> 	iw dev moni set monitor [new flags]
> 
> while interface is up.
> 
> ---
> Is there a sane way to do that?

Is this not sane enough? Looks OK to me, even if it adds a bit of code.

> -	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
> +	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
> +		struct ieee80211_local *local = sdata->local;
> +		u32 changed_flags = sdata->u.mntr_flags ^ *flags;
> +
>  		sdata->u.mntr_flags = *flags;
> +		if (changed_flags & MONITOR_FLAG_FCSFAIL) {
> +			if (*flags & MONITOR_FLAG_FCSFAIL)
> +				local->fif_fcsfail++;
> +			else
> +				local->fif_fcsfail--;
> +		}
> +		if (changed_flags & MONITOR_FLAG_PLCPFAIL) {
> +			if (*flags & MONITOR_FLAG_PLCPFAIL)
> +				local->fif_plcpfail++;
> +			else
> +				local->fif_plcpfail--;
> +		}
> +		if (changed_flags & MONITOR_FLAG_COOK_FRAMES) {
> +			if (*flags & MONITOR_FLAG_COOK_FRAMES)
> +				local->cooked_mntrs++;
> +			else
> +				local->cooked_mntrs--;
> +		}
> +		if (changed_flags & MONITOR_FLAG_OTHER_BSS) {
> +			if (*flags & MONITOR_FLAG_OTHER_BSS)
> +				local->fif_other_bss++;
> +			else
> +				local->fif_other_bss--;
> +		}
> +		if (changed_flags & MONITOR_FLAG_CONTROL) {
> +			if (*flags & MONITOR_FLAG_CONTROL) {
> +				local->fif_pspoll++;
> +				local->fif_control++;
> +			} else {
> +				local->fif_pspoll--;
> +				local->fif_control--;
> +			}
> +		}

Although, come to think of it, one could do something like this:

static void adjust_flags(local, flags, offset)
{
#define ADJUST(_flg, _fif)	do { 		\
	if (flags & MONITOR_FLAG_#_flg)		\
		local->fif_#_fif += offset;	\
	} while (0)

	ADJUST(FCSFAIL, fcsfail);
	ADJUST(PLCPFAIL, plcpfail);
	ADJUST(CONTROL, control);
	ADJUST(CONTROL, pspoll);
	ADJUST(OTHER_BSS, other_bss);
#undef ADJUST
}

and then we can have four callers of this function.

Two here:
adjust_flags(local, sdata->u.mntr_flags, -1);
adjust_flags(local, *flags, 1)
sdata->u.mntr_flags = *flags;

and the same two in ieee80211_do_open / ieee80211_do_stop.

johannes

