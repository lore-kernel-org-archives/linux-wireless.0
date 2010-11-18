Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46160 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0KRT4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 14:56:42 -0500
Message-ID: <4CE5849D.1060705@oracle.com>
Date: Thu, 18 Nov 2010 11:55:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: fix modular legacy build errors
References: <1290011797.12056.255.camel@wwguy-huron>	 <1290012580.3777.1.camel@jlt3.sipsolutions.net>	 <4CE40CF9.8090404@oracle.com> <1290013876.12056.260.camel@wwguy-huron>	 <20101118091138.80875baf.randy.dunlap@oracle.com>	 <1290101760.6131.1.camel@wwguy-ubuntu>	 <20101118175434.GC2468@tuxdriver.com>  <4CE57EB3.5070902@oracle.com> <1290109607.3801.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290109607.3801.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/10 11:46, Johannes Berg wrote:
> On Thu, 2010-11-18 at 11:29 -0800, Randy Dunlap wrote:
> 
>> It's listed as being part of the linux-next pull, so I guess that there is still
>> some sort of config/build problem.
>>
>> Same linker errors as above.  Here is today's config file that causes the error (attached).
>>
>>
>> CONFIG_IWLWIFI=m
>> CONFIG_IWLWIFI_DEBUG=y
>> # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
>> # CONFIG_IWLAGN is not set
>> CONFIG_IWL3945=m
> 
> Yeah, it's a bit confusing .. I'm pretty sure I tried all this when
> doing the non-5000+ patch. Can you try adding
> 
> iwlcore-objs += $(iwlcore-m)
> 
> to your Makefile after the iwl-legacy lines and see if that helps for
> you as well? It seems that the reason is that iwl-legacy never gets

Yes, that builds fine.

> added because it's -m?

Seems so.

> But then why did iwlagn-$(CONFIG_IWL4965) and iwl3945-$(CONFIG_IWL3945)
> work for you? That bit confuses me completely. It looks like this should
> be working? I mean -- why doesn't iwl-legacy.c now get compiled, but
> does if you move it to agn like you did here:
> 
> 
> -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
> +iwlagn-$(CONFIG_IWL4965) += iwl-4965.o iwl-legacy.o
> 
> Why does that work, but not iwlcore-$(CONFIG_IWL4965)??

I dunno, but I only tested my erroneous patch when building as loadable
modules, not builtin.  Testing error on my part.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
