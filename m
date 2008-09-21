Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:39808 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYIUU2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 16:28:13 -0400
Date: Mon, 22 Sep 2008 00:26:56 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arjan van de Ven <arjan@infradead.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921202656.GC25052@2ka.mipt.ru> (sfid-20080921_222818_185317_D3D1BE9D)
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921200518.GK7736@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080921200518.GK7736@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 12:05:18AM +0400, Cyrill Gorcunov (gorcunov@gmail.com) wrote:
> Since it's that serious maybe we should change
> 
> 		IPW_DEBUG_INFO("%s: Fatal error value: 0x%08X\n",
> 			       priv->net_dev->name, priv->fatal_error);
> 
> to printk(KERN_WARN)? And here is why - as I see now we can't say what
> exactly is wrong - Evgeniy said he has a suspicious about firmware so
> this WARNS will be collected by Arjan thru kerneloops and we could not
> ask users to change debug level and repost problem - oops will have it
> by default - and if it really firmware problem - firmware engineers could
> find this _additional_ info usefull and resolve it (probably).

The only reason for this change is to make a mark at the kerneloops.
I.e. users know, there is a bug. Developers know, there is a bug.
Everyone knows that there is a bug, but until it is at the special place
we look to each other just like there is no bug.

Here are dumps for example:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=245

Bug existed even with 1.2 firmware and .11 kernel.
Intel, that's a great marketing slogan: stability everywhere!

-- 
	Evgeniy Polyakov
