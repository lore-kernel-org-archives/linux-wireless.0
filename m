Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12039 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZKIRTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 12:19:42 -0500
Subject: Re: [PATCH] iwlcore: Allow runtime configuration of
 no_sleep_autoadjust
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
References: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 09:19:47 -0800
Message-Id: <1257787187.21134.22331.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-11-08 at 11:30 -0800, Andrew Lutomirski wrote:
> Runtime adjustment of no_sleep_autoadjust seems fine, both looking at
> the code and in practice.  This makes it easier to test.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
> I've been running this patch (and twiddling the setting) for a couple
> months now, and it seems to work fine.  I think it's a bit late for
> 2.6.32, even though it's pretty much impossible for this to cause any
> regressions, but it would be nice to see it go in for 2.6.33 until
> no_sleep_autoadjust goes away.
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c
> b/drivers/net/wireless/iwlwifi/iwl-power.c
> index 60be976..4eba1ab 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-power.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-power.c
> @@ -54,7 +54,7 @@
>   * adjusting ...
>   */
>  bool no_sleep_autoadjust = true;
> -module_param(no_sleep_autoadjust, bool, S_IRUGO);
> +module_param(no_sleep_autoadjust, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(no_sleep_autoadjust,
>  		 "don't automatically adjust sleep level "
>  		 "according to maximum network latency");

I think this change is a bit deceiving since making this writable does
not result in what you write to it at runtime being communicated to the
device.

Reinette


