Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48058 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751707AbbKKAW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 19:22:29 -0500
Message-ID: <1447201345.2475.15.camel@coelho.fi> (sfid-20151111_012233_672185_46FE9C66)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 11 Nov 2015 02:22:25 +0200
In-Reply-To: <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	 <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-11-10 at 09:52 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are many drivers with different behaviour, but in a lot of
> systems only a single driver will ever be built. In that case we
> could practically get rid of the code for the paths that this
> driver/device doesn't need. Doing that, however, would be rather
> dangerous.
> 
> As a decent alternative, use static keys to simply get into the
> required code path for the single built driver.
> 
> To achieve this associate with each flag an _ON and _OFF Kconfig
> symbol. Selecting this symbol in a driver will cause the system
> to take this as the default state (if both are selected, there's
> no optimisation at all.)
> 
> If, for example, the Kconfig selection said that a given flag is
> expected to always be turned off, then the code depending on it
> would be placed out-of-line and the jump to it NOPed out. If a
> different driver that actually requires the code contrary to the
> Kconfig selection is loaded, the jump will be patched in and the
> first thing in the out-of-line section will be to check the real
> hardware flag (since multiple drivers can be loaded.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> diff --git a/net/mac80211/Kconfig.hwflags
> b/net/mac80211/Kconfig.hwflags
> new file mode 100644
> index 000000000000..06f6ba12c86e
> --- /dev/null
> +++ b/net/mac80211/Kconfig.hwflags
> @@ -0,0 +1,192 @@
> +config MAC80211_HW_HAS_RATE_CONTROL_ON
> +	bool
> +	depends on MAC80211
> +config MAC80211_HW_HAS_RATE_CONTROL_OFF
> +	bool
> +	depends on MAC80211
> +config MAC80211_HW_RX_INCLUDES_FCS_ON
> +	bool
> +	depends on MAC80211
> +config MAC80211_HW_RX_INCLUDES_FCS_OFF
> +	bool
> +	depends on MAC80211
[...]

Now that you have all these options in Kconfig, wouldn't it be possible
to remove the calls to the "static" ieee80211_hw_set() in the drivers
and somehow set all the flags that are defined in Kconfig
automatically?

The driver could still call ieee80211_hw_clear() and ieee80211_hw_set()
if it needs to change dynamically.

--
Luca.
