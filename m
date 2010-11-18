Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab0KRTpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 14:45:19 -0500
Subject: Re: iwlwifi: fix modular legacy build errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CE57EB3.5070902@oracle.com>
References: <1290011797.12056.255.camel@wwguy-huron>
	 <1290012580.3777.1.camel@jlt3.sipsolutions.net>
	 <4CE40CF9.8090404@oracle.com> <1290013876.12056.260.camel@wwguy-huron>
	 <20101118091138.80875baf.randy.dunlap@oracle.com>
	 <1290101760.6131.1.camel@wwguy-ubuntu>
	 <20101118175434.GC2468@tuxdriver.com>  <4CE57EB3.5070902@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 11:46:47 -0800
Message-ID: <1290109607.3801.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 11:29 -0800, Randy Dunlap wrote:

> It's listed as being part of the linux-next pull, so I guess that there is still
> some sort of config/build problem.
> 
> Same linker errors as above.  Here is today's config file that causes the error (attached).
> 
> 
> CONFIG_IWLWIFI=m
> CONFIG_IWLWIFI_DEBUG=y
> # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
> # CONFIG_IWLAGN is not set
> CONFIG_IWL3945=m

Yeah, it's a bit confusing .. I'm pretty sure I tried all this when
doing the non-5000+ patch. Can you try adding

iwlcore-objs += $(iwlcore-m)

to your Makefile after the iwl-legacy lines and see if that helps for
you as well? It seems that the reason is that iwl-legacy never gets
added because it's -m?

But then why did iwlagn-$(CONFIG_IWL4965) and iwl3945-$(CONFIG_IWL3945)
work for you? That bit confuses me completely. It looks like this should
be working? I mean -- why doesn't iwl-legacy.c now get compiled, but
does if you move it to agn like you did here:


-iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
+iwlagn-$(CONFIG_IWL4965) += iwl-4965.o iwl-legacy.o

Why does that work, but not iwlcore-$(CONFIG_IWL4965)??

johannes

