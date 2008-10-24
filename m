Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47213 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbYJXSSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:18:50 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1224841176.6002.124.camel@johannes.berg>
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 20:18:48 +0200
Message-Id: <1224872328.7536.67.camel@californication> (sfid-20081024_201857_607775_ACE96704)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

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

we really only care about the case where we have no userspace capable of
setting the regulatory domain. So in only that case it makes sense to
fallback to the hardware regulatory support. So I would not make this
depend on world domain since that might not work good enough in the 5
GHz case. Can the mac80211 just track if userspace has set a regulatory
domain and then enforce it. Otherwise leave it to the hardware that
supports it or enforce the world domain to hardware that has no
regulatory support in hardware.

Can we also have a command that clears/resets the regulatory domain
setting so we get back to the initial state without rebooting. Would be
also good to have for testing.

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

This discussion started with having two adapters and disabling 5 GHz for
the second if the first one is BG only. This solution would make this
work when the second card sets the hardware regulatory flag. So it looks
good to me.

I don't see a big problem with restricting channels. Disabling a whole
band is an issue. However we could add printk's to tell the user when we
apply different regulatory domains to different devices, because one has
the hardware flag set.

Other than that, I think this idea makes a lot of sense. Having a much
more simpler logic is a good thing.

Regards

Marcel


