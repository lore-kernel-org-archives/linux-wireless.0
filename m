Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbbDWTdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 15:33:42 -0400
Date: Thu, 23 Apr 2015 21:33:39 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
	Julia Lawall <julia.lawall@lip6.fr>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 4/8] moduleparam.h: add module_param_config_*() helpers
Message-ID: <20150423193339.GO5622@wotan.suse.de> (sfid-20150423_213432_697179_D7724C29)
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
 <1429739711-9415-5-git-send-email-mcgrof@do-not-panic.com>
 <87618noaj6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87618noaj6.fsf@rustcorp.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2015 at 11:45:09AM +0930, Rusty Russell wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > This adds a couple of bool module_param_config_*() helpers
> > which are designed to let us easily associate a boolean
> > module parameter with an associated kernel configuration
> > option.
> 
> OK.

So this is really the main gain.

> > Folks can use this to avoid what typically would
> > be #ifdef eyesores around module parameter declarations.
> 
> Really?  So you use this in two patches:
> 
>   /* see the comment above the definition of WQ_POWER_EFFICIENT */
>  -static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
>  -module_param_named(power_efficient, wq_power_efficient, bool, 0444);
>  +module_param_config_on_off(power_efficient, wq_power_efficient, 0444, CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
> 
> And:
> 
>   static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
>   #ifndef CONFIG_MODULE_SIG_FORCE
>  -module_param(sig_enforce, bool_enable_only, 0644);
>  +module_param_config_on(sig_enforce, sig_enforce, 0644, CONFIG_MODULE_SIG_FORCE);
>   #endif /* !CONFIG_MODULE_SIG_FORCE */
> 
> But neither actually, y'know, cleans up any #ifdefs.

OK, sure, its the use of IS_ENABLED() that does that as a first step.

> Simplicity is a major virtue.  Readability is a major virtue.  Brevity
> is only a minor virtue.

I was not shooting for brevity but instead aiming at the possible
grammatical gain of direct and immediate association between a bool, behaviour
(on_off, or just on), and a config. I don't have a need for the grammatical
association now so will drop this.

  Luis
