Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:59444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934224AbbDVIKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 04:10:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 4/6] moduleparam.h: add module_param_config_*() helpers
In-Reply-To: <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com> <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
Date: Wed, 22 Apr 2015 16:45:04 +0930
Message-ID: <87mw20ocqv.fsf@rustcorp.com.au> (sfid-20150422_101102_110694_6CA5FC4C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This adds a couple of bool module_param_config_*() helpers
> which are designed to let us easily associate a booloean
> module parameter with an associated kernel configuration
> option, and to help us remove #ifdef'ery eyesores.

But they don't.  And I had to read the descriptions twice to understand
what you're doing.

eg you use it like this:

 -#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
 -static bool wq_power_efficient = true;
 -#else
 -static bool wq_power_efficient;
 -#endif
 -
 -module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 +module_param_config_on_off(power_efficient, wq_power_efficient, 0444,
 CONFIG_WQ_POWER_EFFICIENT_DEFAULT);

It would be much clearer to do this:

 -#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
 -static bool wq_power_efficient = true;
 -#else
 -static bool wq_power_efficient;
 -#endif
 +static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);

I know exactly what that does without having to notice the difference
between module_param_config_on_off() and module_param_config_on().

Cheers,
Rusty.
