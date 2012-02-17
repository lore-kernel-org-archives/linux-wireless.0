Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751151Ab2BQUgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:36:39 -0500
Message-ID: <1329510996.584.39.camel@joe2Laptop> (sfid-20120217_213643_026108_47EE6FD0)
Subject: Re: [PATCH 04/26] iwlwifi: trace debug messages
From: Joe Perches <joe@perches.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 17 Feb 2012 12:36:36 -0800
In-Reply-To: <1329506034-1394-5-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1329506034-1394-5-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-17 at 11:13 -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Make iwlwifi record all debug messages into
> tracing, even if debug_level is not enabled.
[]
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
[]
> +#define __iwl_fn(fn)						\
> +void __iwl_ ##fn(struct device *dev, const char *fmt, ...)	\
> +{								\
> +	struct va_format vaf = {				\
> +		.fmt = fmt,					\
> +	};							\

Using initializers like this takes 1 more line
than the form I believe is used everywhere else.

> +	va_list args;						\
> +								\
> +	va_start(args, fmt);					\
> +	vaf.va = &args;						\

	struct va_format vaf;

	va_start(args, fmt);
	vaf.fmt  = fmt;
	vaf.va = &args;


