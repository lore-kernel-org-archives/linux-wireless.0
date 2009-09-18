Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19743 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZIRHi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 03:38:26 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
Date: Fri, 18 Sep 2009 09:37:42 +0200
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Bing Zhao <bzhao@marvell.com>, Dan Williams <dcbw@redhat.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com> <45e8e6c40909161347l23caaf4ct14d4ef7b416b3387@mail.gmail.com> <20090917161154.GA877@Chamillionaire.breakpoint.cc>
In-Reply-To: <20090917161154.GA877@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909180937.42727.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I agree on this. Debugfs is for debug only and should stay
> that way. What do other driver in regard to this?

I see this now as an example where a Manufacturer (Marvell) 
starts to work with the community, has a nice feature (probably 
bacause of customer-request) and cannot get this into the kernel 
because of this issue :-)


Debugfs isn't suitable for anything except debugging. It is, per 
definition, an interface for developers that want to debug it. 
The idea is that a kernel for end-user devices won't even have 
debugfs compiled in.

If libertas currently does use debugfs for something != 
debugging?  I don't know, but than that has been a lapse, an 
oversight. Let's not do that oversight again.


So you can use

* iwpriv
* sysfs
* kernel module parameters
* nl80211/cfg80211
* Maybe the new "stable debugfs" proposed by Rostedt (see the
  Article "A stable debugfs" on http://lwn.net/Articles/350463/,
  but here it's not even clear that this will come).

For me, iwpriv seems the best candidate as long as libertas 
doesn't have a cfg80211/nl80211 interface.



> I hardly belive that the libertas driver is the only "deep
> sleep" user. 

I think that ATH6K WLAN devices might be candidates for this, 
too. If the interface is "iwpriv XXX deepsleep 0" / "iwpriv XXX 
deepsleep 1" I don't see a reason they could do it similar.


> iwconfig has an interface for this I think:
> |interface power {period N|timeout N|saving N|off}

That's something very differently.


-- 
http://www.holgerschurig.de
