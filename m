Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422892Ab2JDQdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 12:33:01 -0400
Message-ID: <1349368379.2008.16.camel@joe-AO722> (sfid-20121004_183315_600658_43E44B42)
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
From: Joe Perches <joe@perches.com>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, bzhao@marvell.com
Date: Thu, 04 Oct 2012 09:32:59 -0700
In-Reply-To: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-04 at 12:16 +0300, Andrei Emeltchenko wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> 
> Make output more readable and remove unneeded function call.
> 
> ...
> mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
> last_cmd_id: 00000000: 28 00 28 00 28                            (.(.(
> ...
> 
> would be changed to:
> 
> ...
> mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
> mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 28 00 28
> ...

(added Andy Shevchenko)

Hi Andrei.  That's probably a better output style too
as the ascii isn't likely useful.

One non-nit as a style issue for Andy Shevchenko:

> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
[]
> @@ -917,21 +917,20 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
[]
> +		dev_err(adapter->dev, "last_cmd_id: %*ph\n", DBG_CMD_NUM,
> +			adapter->dbg.last_cmd_id);
> +		dev_err(adapter->dev, "last_cmd_act: %*ph\n", DBG_CMD_NUM,
> +			adapter->dbg.last_cmd_act);

When the number of bytes is fixed, it might be nicer
to use a format like "%<num>ph" so that the function
argument stack doesn't have the width pushed but it's
fixed in the format.

This case would definitely not work well though as it's
a #define rather than a simple number and I think
using "%" stringize(some_define) "ph" is not nice.

Maybe this case argues more for always using "%*ph".
At least that's easily greppable.

Andy?

