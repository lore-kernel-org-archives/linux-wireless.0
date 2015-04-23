Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:56826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbbDWDZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 23:25:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 4/8] moduleparam.h: add module_param_config_*() helpers
In-Reply-To: <1429739711-9415-5-git-send-email-mcgrof@do-not-panic.com>
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com> <1429739711-9415-5-git-send-email-mcgrof@do-not-panic.com>
Date: Thu, 23 Apr 2015 11:45:09 +0930
Message-ID: <87618noaj6.fsf@rustcorp.com.au> (sfid-20150423_052552_145387_F7221C96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This adds a couple of bool module_param_config_*() helpers
> which are designed to let us easily associate a boolean
> module parameter with an associated kernel configuration
> option.

OK.

> Folks can use this to avoid what typically would
> be #ifdef eyesores around module parameter declarations.

Really?  So you use this in two patches:

  /* see the comment above the definition of WQ_POWER_EFFICIENT */
 -static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
 -module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 +module_param_config_on_off(power_efficient, wq_power_efficient, 0444, CONFIG_WQ_POWER_EFFICIENT_DEFAULT);

And:

  static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
  #ifndef CONFIG_MODULE_SIG_FORCE
 -module_param(sig_enforce, bool_enable_only, 0644);
 +module_param_config_on(sig_enforce, sig_enforce, 0644, CONFIG_MODULE_SIG_FORCE);
  #endif /* !CONFIG_MODULE_SIG_FORCE */

But neither actually, y'know, cleans up any #ifdefs.

Simplicity is a major virtue.  Readability is a major virtue.  Brevity
is only a minor virtue.

So I have applied the following patches:

[PATCH v2 1/8] kernel/params: constify struct kernel_param_ops uses
[PATCH v2 2/8] kernel/module.c: use generic module param operaters for sig_enforce
[PATCH v2 3/8] kernel/params.c: generalize bool_enable_only
[PATCH v2 5/8] kernel/workqueue.c: remove ifdefs over wq_power_efficient
[PATCH v2 7/8] kernel/module.c: avoid ifdefs for sig_enforce declaration

Thanks,
Rusty.
