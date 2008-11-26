Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYKZQUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 11:20:41 -0500
Subject: Re: [PATCH] ipw2200: increase scan timeout
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>
In-Reply-To: <1227686674.2548.398.camel@debian.sh.intel.com>
References: <200811251809.55461.helmut.schaa@gmail.com>
	 <200811260706.03160.hs4233@mail.mn-solutions.de> <87bpw3ar04.fsf@nokia.com>
	 <1227686674.2548.398.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 11:19:42 -0500
Message-Id: <1227716382.25339.8.camel@localhost.localdomain> (sfid-20081126_172046_012241_2BF2F7E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-26 at 16:04 +0800, Zhu Yi wrote:
> On Wed, 2008-11-26 at 15:24 +0800, Kalle Valo wrote:
> > While the firmware was reset
> > association state wasn't changed and I could, for example, run iperf
> > tests while firmware was resetting without userspace noticing anything
> > (expect a slight decreare of throughput of course). This might depend
> > on firmware implementation, but at least with softmac devices it
> > shouldn't be a problem.
> 
> This is fairly easy to be handled by hardmac as well. We didn't do it
> because: 1) this is an unexpected behaviour so we simply put everything
> to the initial state when this happens and didn't put a lot of effort on
> the recovery 2) 'associate=1' used to be the default value, so the
> driver associated automatically after the firmware restart cycle.
> 
> Patches are welcome.

Yeah, even with associate=0 we'll want to preserve the association
across restarts of the firmware, so we need to make the driver bring the
association back up if the firmware crashed.  But only on crash.

Dan


