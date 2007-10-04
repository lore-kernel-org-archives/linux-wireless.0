Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4345 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbXJDPig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 11:38:36 -0400
Date: Thu, 4 Oct 2007 11:19:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, johannes@sipsolutions.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix TX after monitor interface is converted
	to managed
Message-ID: <20071004151956.GE6037@tuxdriver.com> (sfid-20071004_163843_924216_1FB867D5)
References: <20071004113343.552139D502B@zog.reactivated.net> <200710041034.48533.flamingice@sourmilk.net> <200710041706.06182.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710041706.06182.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2007 at 05:06:05PM +0200, Michael Buesch wrote:
> On Thursday 04 October 2007 16:34:43 Michael Wu wrote:
> > On Thursday 04 October 2007 07:33, Daniel Drake wrote:
> > > Fix this by unsetting the hard_start_xmit handler in ieee80211_if_reinit.
> > > It will then be reinitialised to the default (ieee80211_subif_start_xmit)
> > > in ieee80211_if_set_type.
> > >
> > Well.. this kinda sucks, but we can clean up the logic here later.
> > 
> > > +	BUG_ON(netif_running(dev));
> > This will never happen, so there's no point.
> 
> The reason why BUG_ON exists is to catch bugs that happen, although
> they Should Never Happen (tm) ;)

Precisely.

-- 
John W. Linville
linville@tuxdriver.com
