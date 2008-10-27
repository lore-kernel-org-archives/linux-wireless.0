Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYJ0DI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 23:08:58 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1224841176.6002.124.camel@johannes.berg>
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 11:08:49 +0800
Message-Id: <1225076929.2917.200.camel@debian.sh.intel.com> (sfid-20081027_040913_304871_D6A69EB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-24 at 02:39 -0700, Johannes Berg wrote:
> On Fri, 2008-10-24 at 10:43 +0800, Zhu Yi wrote:
> >         
> >         The patch extends the current regulatory framework to support regulatory
> >         enforcement by device hardware (firmware). If the regulatory check is
> >         performed by hardware, the driver uses a special flag to indicate the
> >         regulatory framework, so that the regulatory framework will bypass all
> >         the regulatory checks for this device and delegate it to the hardware.
> 
> The way I'm reading this, it's incorrect because it doesn't allow the
> user to override the hardware's idea of the regulatory domain. I think
> it's just a wrong description though.
> 
> However, there is another major problem with this, if I use a USB device
> that has no regulatory information on a laptop that has this virtual
> regdomain configured because of a built-in Intel device, my USB device
> will wrongly enable all channels.
> 
> But inspired by your patch, here's a different idea:
> 
>  * remove the struct regdomain hint thing
>  * introduce a "hardware has regulatory check" flag, which means that
>     - hardware will enforce regulatory compliance to whatever it thinks
>       the regulatory domain is
>     - the driver will, of course, still also enforce the information in
>       wiphy->bands as it does now
>  * if a wiphy has the "hw regulatory" flag set and the
>    cfg80211_regdomain is the world regdomain (whether hard-coded or
>    gotten from CRDA), then (and only then!) don't apply the
>    cfg80211_regdomain to it
> 
> This would have the following consequences:
>  + much less code since all the hint stuff goes away
>  + still works for users who move around with a hw-regulatory based
>    laptop if they set the regdomain to something other than world
>    manually
>  - secondary hardware cannot benefit of the, now no longer given, hint
>    which regdomain the laptop is in and will be restricted to world
>  - some degree of confusion possible when one device can use channel 13
>    (say iwl-agn hardware configured for Europe) and another cannot (say
>    a USB device without regulatory information, leading to the world
>    regdomain being the used one)

I totally agree.

Thanks,
-yi

