Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34325 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918AbbDUU7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 16:59:02 -0400
Date: Tue, 21 Apr 2015 16:58:57 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, keescook@chromium.org,
	casey@schaufler-ca.com, cocci@systeme.lip6.fr,
	Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 4/6] moduleparam.h: add module_param_config_*() helpers
Message-ID: <20150421205857.GG9455@htj.duckdns.org> (sfid-20150421_225923_185434_A758F822)
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
 <1429572637-30234-5-git-send-email-mcgrof@do-not-panic.com>
 <20150421152136.GC9455@htj.duckdns.org>
 <20150421165516.GL5622@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150421165516.GL5622@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Luis.

On Tue, Apr 21, 2015 at 06:55:16PM +0200, Luis R. Rodriguez wrote:
> A use then would be for instance:
> 
> module_param_config_on_off(power_efficient, wq_power_efficient, 0444,
> 			   IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT));
> 
> this as an alternative would enable use of other static / global variables but
> I'm not sure if these are good use cases to promote, given that all this is to
> help with initial set up, so I believe the restrictions are for the better.

I was thinking more of cases where CONFIG should be inverted or
and/or'd.  In general I don't think we conventionally embed
IS_ENABLED() in this sort of macros.  It just jumps at me as a weird
restriction.  What do others think?

Thanks.

-- 
tejun
