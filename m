Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36174 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbDUPVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 11:21:40 -0400
Date: Tue, 21 Apr 2015 11:21:36 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, keescook@chromium.org,
	casey@schaufler-ca.com, cocci@systeme.lip6.fr,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 4/6] moduleparam.h: add module_param_config_*() helpers
Message-ID: <20150421152136.GC9455@htj.duckdns.org> (sfid-20150421_172158_313020_D1D13BED)
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
 <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2015 at 04:30:35PM -0700, Luis R. Rodriguez wrote:
>  /**
> + * module_param_config_on_off - bool parameter with run time override
> + * @name: a valid C identifier which is the parameter name.
> + * @value: the actual lvalue to alter.
> + * @perm: visibility in sysfs.
> + * @config: kernel parameter which will enable this option if this
> + * 	kernel configuration option has been enabled.
> + *
> + * This lets you define a bool module paramter which by default will be
> + * set to true if the config option has been set on your kernel's
> + * configuration, otherwise it is set to false.
> + */
> +#define module_param_config_on_off(name, var, perm, config) 		\
> +	static bool var = IS_ENABLED(config);				\
> +	module_param_named(name, var, bool, perm);

Maybe we want to make @config just a boolean initializer?
e.g. something like

#define module_param_config_on_off(name, var, perm, on_off) 		\
	static bool var = on_off;					\
	module_param_named(name, var, bool, perm);

so that the caller does IS_ENABLED() or whatever that's necessary?  It
just seems a bit too restricted.

Thanks.

-- 
tejun
