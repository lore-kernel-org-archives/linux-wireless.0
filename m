Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYKZIE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:04:27 -0500
Subject: Re: [PATCH] ipw2200: increase scan timeout
From: Zhu Yi <yi.zhu@intel.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>
In-Reply-To: <87bpw3ar04.fsf@nokia.com>
References: <200811251809.55461.helmut.schaa@gmail.com>
	 <200811260706.03160.hs4233@mail.mn-solutions.de> <87bpw3ar04.fsf@nokia.com>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 16:04:34 +0800
Message-Id: <1227686674.2548.398.camel@debian.sh.intel.com> (sfid-20081126_090431_794109_775566E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-26 at 15:24 +0800, Kalle Valo wrote:
> While the firmware was reset
> association state wasn't changed and I could, for example, run iperf
> tests while firmware was resetting without userspace noticing anything
> (expect a slight decreare of throughput of course). This might depend
> on firmware implementation, but at least with softmac devices it
> shouldn't be a problem.

This is fairly easy to be handled by hardmac as well. We didn't do it
because: 1) this is an unexpected behaviour so we simply put everything
to the initial state when this happens and didn't put a lot of effort on
the recovery 2) 'associate=1' used to be the default value, so the
driver associated automatically after the firmware restart cycle.

Patches are welcome.

Thanks,
-yi

