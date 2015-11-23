Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbbKWOwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 09:52:46 -0500
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary
 code
To: Johannes Berg <johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <5653283C.8050207@suse.com> (sfid-20151123_155250_670119_0D508FC3)
Date: Mon, 23 Nov 2015 15:52:44 +0100
MIME-Version: 1.0
In-Reply-To: <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-12 23:00, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are many drivers with different behaviour, but in a lot of
> systems only a single driver will ever be built. In that case we
> can get rid of code paths that this driver doesn't need and also
> optimize the ones that it always takes to not have a check.
> 
> To make that possible, make use Kconfig counters to
>  (a) the number of times each feature flag was desired
>  (b) the number of mac80211 drivers built
> and use Kconfig selects to select those flags that any drivers
> need to be dynamic (e.g. if they can only determine this flag's
> setting at runtime.)
> 
> If the dynamic request isn't set then
> 
>  if (a) > 0 then it was requested ON by at least one driver
>  if (a) < (b) then it was requested OFF by at least one driver

So one issue with this logic is that it is not safe to build and use an
out-of-tree mac80211 driver after the kernel has been built. Also, any
new driver needs the 'count MAC80211_NUM_DRIVERS' annotation, but there
is the runtime check to catch omissions. Since this is targeting users
of very specific configs, how about an opt-in scheme à la

- User has to select CONFIG_MAC80211_SINGLE_DRIVER, the help text
  explains the caveats and lists drivers known to work in such mode.
- mac80211 uses the Kconfig-defined constants + dynamic bits iff
  CONFIG_MAC80211_SINGLE_DRIVER=y, otherwise it behaves as before.
- Some build- or compile-time check ensuring that we are not building /
  loading multiple drivers with CONFIG_MAC80211_SINGLE_DRIVER=y.

? It's not very robust either, but at least it would only be used by
those who know what they are doing.

Michal
