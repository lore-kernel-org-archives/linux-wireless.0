Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36534 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZHZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 02:25:51 -0500
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net
Subject: Re: [PATCH] ipw2200: increase scan timeout
References: <200811251809.55461.helmut.schaa@gmail.com>
	<200811260706.03160.hs4233@mail.mn-solutions.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 26 Nov 2008 09:24:59 +0200
In-Reply-To: <200811260706.03160.hs4233@mail.mn-solutions.de> (ext Holger Schurig's message of "Wed\, 26 Nov 2008 07\:06\:03 +0000")
Message-ID: <87bpw3ar04.fsf@nokia.com> (sfid-20081126_082555_541234_D3675B06)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <hs4233@mail.mn-solutions.de> writes:

> Second thing: why should the association get's cleared if the 
> adapter get's reset?  Isn't one a (assoc) at protocol level and 
> the other (adapter) a hardware thing?

Good point. I once had a bad bug in stlc45xx tx queue handling and
firmware was crashing all the time. While the firmware was reset
association state wasn't changed and I could, for example, run iperf
tests while firmware was resetting without userspace noticing anything
(expect a slight decreare of throughput of course). This might depend
on firmware implementation, but at least with softmac devices it
shouldn't be a problem.

-- 
Kalle Valo
