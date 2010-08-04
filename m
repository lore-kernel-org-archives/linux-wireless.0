Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0HDHv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 03:51:28 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87mxt3n9xh.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
	 <1280746705.3923.11.camel@jlt3.sipsolutions.net>
	 <878w4pvx5e.fsf@sycorax.lbl.gov>
	 <1280766201.24503.0.camel@jlt3.sipsolutions.net>
	 <87aap4z70b.fsf@sycorax.lbl.gov>
	 <1280817596.3874.0.camel@jlt3.sipsolutions.net>
	 <87mxt3n9xh.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:52:45 +0200
Message-ID: <1280908365.3768.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-03 at 05:43 -0700, Alex Romosan wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > Yes, thank you, but it's very strange. But it's probably ok, let's
> > remove the call then, it wasn't there before. Want to post a patch
> > yourself?
> 
> btw, the old code had this comment
> 
>  /* We avoid iwl_commit_rxon here to commit the new filter flags
>   * since mac80211 will call ieee80211_hw_config immediately.
>   * (mc_list is not supported at this time). Otherwise, we need to
>   * queue a background iwl_commit_rxon work.
>   */

Yes, but that predates this callback being able to sleep, which
according to the comment is the reason for not committing here. Now that
the callback could sleep, I figured we could safely commit there, I have
no idea why that caused issues with your AP.

I realised though that mac80211 will sometimes call the filter config
w/o calling hw_config() immediately, so I'd prefer actually figuring out
what the issue with your AP is. Could you rebuild your kernel with
CONFIG_MAC80211_DRIVER_API_TRACER and CONFIG_IWLWIFI_DEVICE_TRACING, get
trace-cmd from
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git and
record traces for me? I'd like to have
	trace-cmd record -e iwlwifi -e mac80211
for both the working and non-working case, preferably the same kernel
with that single line of code changed. Please compress the output.

johannes

