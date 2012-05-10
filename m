Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2EJQuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:50:39 -0400
Message-ID: <1336668634.4334.23.camel@jlt3.sipsolutions.net> (sfid-20120510_185043_029152_81B6AB28)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 18:50:34 +0200
In-Reply-To: <1336667905.22495.18.camel@joe2Laptop>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 <1336667905.22495.18.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 09:38 -0700, Joe Perches wrote:
> Add gcc format and argument printf checking
> to reduce future defect introduction.

Good point, I'll pick this up.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-debug.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index 8376b84..d0c7c9e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -50,10 +50,12 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
>  #define IWL_CRIT(m, f, a...) __iwl_crit((m)->dev, f, ## a)
>  
>  #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
> +__printf(5, 6)
>  void __iwl_dbg(struct device *dev,
>  	       u32 level, bool limit, const char *function,
>  	       const char *fmt, ...);

But that looks a bit odd to me? It would seem more natural to me to put
the attribute after the parameter list?

johannes

