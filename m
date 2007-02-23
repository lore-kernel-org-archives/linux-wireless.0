Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:28672 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932638AbXBWU1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:27:05 -0500
Message-ID: <45DF4D4B.6010601@linux.intel.com>
Date: Fri, 23 Feb 2007 12:23:39 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] create net/wireless/Kconfig and make nl80211 optional
References: <45DDF22D.9000003@linux.intel.com>	 <1172229914.3870.13.camel@johannes.berg> <45DF176E.9090509@linux.intel.com> <1172261472.3870.50.camel@johannes.berg>
In-Reply-To: <1172261472.3870.50.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-02-23 at 08:33 -0800, James Ketrenos wrote:
>> Johannes Berg wrote:
>>> On Thu, 2007-02-22 at 11:42 -0800, James Ketrenos wrote:
>>>> Move the wireless Kconfig options into their own wireless/Kconfig and
>>>> add a CONFIG_NL80211 configuration option to allow nl80211 support to be
>>>> optionally included (default =y)
>>> Ack, but we'll need to modify core.h to stub out nl80211_init() and
>>> nl80211_exit() in case nl80211 isn't compiled in. The reason this worked
>>> for you is that I forgot to hook up nl80211 completely ;)
>>>
>>> Do you want me to take care of that?`
>> Something like this?
> 
> Yup. I'd prefer this instead, and then rolled into your original patch
> so it applies after my hookup patch.

Ya, I guess that follows standard kernel guidelines more... I tend to 
find it a lot easier in resolving problems with short spanning ifdef's 
sprinkled in code vs. hidden functionality in header files that changes 
based on CONFIG options.  But alas, I think I am in the minority on that.

I'll resend my prior 'make nl80211 optional' patch adding below to it.

Thanks,
James

> 
> johannes
> 
> --- wireless-dev.orig/net/wireless/nl80211.h	2007-02-23 21:08:45.353476868 +0100
> +++ wireless-dev/net/wireless/nl80211.h	2007-02-23 21:09:58.543476868 +0100
> @@ -1,7 +1,17 @@
>  #ifndef __NET_WIRELESS_NL80211_H
>  #define __NET_WIRELESS_NL80211_H
>  
> +#ifdef CONFIG_CFG80211_NL80211
>  extern int nl80211_init(void);
>  extern void nl80211_exit(void);
> +#else
> +static inline int nl80211_init(void)
> +{
> +	return 0;
> +}
> +static inline void nl80211_exit(void)
> +{
> +}
> +#endif /* CONFIG_CFG80211_NL80211 */
>  
>  #endif /* __NET_WIRELESS_NL80211_H */
