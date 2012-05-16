Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33935 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757341Ab2EPU60 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:58:26 -0400
Message-ID: <1337201904.10019.21.camel@joe2Laptop> (sfid-20120516_225829_821547_833CA746)
Subject: Re: [PATCH 3/3] iwlwifi: add __printf argument checking
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 16 May 2012 13:58:24 -0700
In-Reply-To: <1337200851-20469-4-git-send-email-johannes@sipsolutions.net>
References: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
	 <1337200851-20469-4-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 22:40 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Joe Perches suggested adding the __printf attribute
> to the __iwl_dbg function to check arguments; add it
> to all of the logging functions (err, warn, info, dbg
> and crit.)
> 
> Change-Id: I7a2ffcd3f625ff29c65519b0c3d474bace884f9d
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Reviewed-on: http://git-mwg.jer.intel.com/gerrit/2022
> Tested-by: Jenkins
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Trivial comments:

Odd Reviewed-on: and Tested-by: lines.
The intel.com link does not resolve here too.

> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
[]
> @@ -38,10 +38,10 @@ static inline bool iwl_have_debug_level(u32 level)
>  }
>  
>  void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
> -		const char *fmt, ...);
> -void __iwl_warn(struct device *dev, const char *fmt, ...);
> -void __iwl_info(struct device *dev, const char *fmt, ...);
> -void __iwl_crit(struct device *dev, const char *fmt, ...);
> +		const char *fmt, ...) __printf(4, 5);
> +void __iwl_warn(struct device *dev, const char *fmt, ...) __printf(2, 3);
> +void __iwl_info(struct device *dev, const char *fmt, ...) __printf(2, 3);
> +void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);

As far as I know, there are very few in-kernel uses of
__printf after the function prototype (6 out of 183).

$ git grep -E "\b__printf\s*\(\s*\w+\s*,\s*\w+\s*\)\s*;" | wc -l
6
$ git grep -E "\b__printf\s*\(\s*\w+\s*,\s*\w+\s*\)" | wc -l
183

I'd prefer to keep the __printf before the return type.


