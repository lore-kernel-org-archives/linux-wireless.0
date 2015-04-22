Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbbDVPmM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 11:42:12 -0400
Date: Wed, 22 Apr 2015 17:42:08 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 4/6] moduleparam.h: add module_param_config_*() helpers
Message-ID: <20150422154207.GE5622@wotan.suse.de> (sfid-20150422_174241_569401_FA5CE8A9)
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
 <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
 <87mw20ocqv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mw20ocqv.fsf@rustcorp.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2015 at 04:45:04PM +0930, Rusty Russell wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > This adds a couple of bool module_param_config_*() helpers
> > which are designed to let us easily associate a booloean
> > module parameter with an associated kernel configuration
> > option, and to help us remove #ifdef'ery eyesores.
> 
> But they don't.  And I had to read the descriptions twice to understand
> what you're doing.
> 
> eg you use it like this:
> 
>  -#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
>  -static bool wq_power_efficient = true;
>  -#else
>  -static bool wq_power_efficient;
>  -#endif
>  -
>  -module_param_named(power_efficient, wq_power_efficient, bool, 0444);
>  +module_param_config_on_off(power_efficient, wq_power_efficient, 0444,
>  CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
> 
> It would be much clearer to do this:
> 
>  -#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
>  -static bool wq_power_efficient = true;
>  -#else
>  -static bool wq_power_efficient;
>  -#endif
>  +static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
> 
> I know exactly what that does without having to notice the difference
> between module_param_config_on_off() and module_param_config_on().

You're right, I forgot a small step patch in between to make the change
clearer. I can add that in my next respin, anything else or do the other
changes  look OK?

 Luis
