Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:49080 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030771AbXCHW1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:27:31 -0500
Date: Thu, 8 Mar 2007 14:17:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: jt@hpl.hp.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jkm@devicescape.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-Id: <20070308141756.efdfd6da.randy.dunlap@oracle.com>
In-Reply-To: <20070308221128.GA24884@bougret.hpl.hp.com>
References: <1173144447.15891.93.camel@johannes.berg>
	<20070306171316.GA19669@bougret.hpl.hp.com>
	<200703061943.07350.mb@bu3sch.de>
	<20070307020310.GA20466@bougret.hpl.hp.com>
	<1173364747.14001.7.camel@johannes.berg>
	<20070308184954.GA24485@bougret.hpl.hp.com>
	<1173382042.3248.63.camel@johannes.berg>
	<20070308193412.GG23040@devicescape.com>
	<1173382802.3248.68.camel@johannes.berg>
	<20070308221128.GA24884@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Mar 2007 14:11:28 -0800 Jean Tourrilhes wrote:

> On Thu, Mar 08, 2007 at 08:40:01PM +0100, Johannes Berg wrote:
> > On Thu, 2007-03-08 at 11:34 -0800, Jouni Malinen wrote:
> > 
> > > Yes, workaround in just iwlib is not enough. If the only possible
> > > solution is user space workaround, it better be documented (and
> > > communicated to maintainers of user space apps) well so that
> > > all user space programs not using iwlib can be modified, too.
> > 
> > The more I think about it the worse it gets. Think about wireless events
> > where both 32 and 64-bit userspace programs may be listening... That
> > means we can't even fix it in the kernel without breaking something.
> > 
> > johannes
> 
> 	This is exactly what I was pointing out earlier. Well,
> actually, there may be ways of fixing it in the kernel, but that would
> be real ugly, and I don't want to go there.
> 
> 	I've just released wireless_tools.29.pre15.tar.gz. This is
> supposed to include a "band-aid" for that problem. To the best of my
> knowledge, it should catch the problem and not introduce false
> positive. I would be glad if you guys would have a quick look into it,
> because obviously I can't test it.
> 
> 	Now, about the way forward...
> 	First possiblity, we could stick with this band-aid
> permanently.
> 
> 	Second possiblity : we do the right thing and plan a API
> change to return struct always aligned on 32 bits. This way, when we
> get 128 bit processor, we don't have to add another band aid ;-)
> 	It would work like the ESSID changeover. We pick a WE version
> changeover. We introduce userspace that can deal with before and
> after. After 1 or 2 years, we flip the switch. After another 1 or 2
> years, we get rid of backward compatibility.
> 
> 	Third possibility : we declare 32 bit userspace on 64 bit
> kernel as not supported and advise users to get a 64 bit
> userspace. The number of bug report on that issue would suggest that
> very few users are in this case.

I think that this is not actually an option since
powerpc64 is all 32-bit userspace.
Maybe some other arch-es are like this also (?).

> 	I know the userspace guys will hate (1) and hate even more (2).
> 
> 	Regards,
> 
> 	Jean



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
