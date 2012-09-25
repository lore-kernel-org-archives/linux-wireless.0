Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2IYOIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 10:08:37 -0400
Message-ID: <1348582152.10041.36.camel@jlt4.sipsolutions.net> (sfid-20120925_160841_662058_C8D1B121)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Tue, 25 Sep 2012 16:09:12 +0200
In-Reply-To: <50617E2C.6050000@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
	  <1348477154.10257.2.camel@jlt4.sipsolutions.net>
	  <50614089.6020105@posedge.com>
	 <1348557902.10041.17.camel@jlt4.sipsolutions.net>
	 <50617E2C.6050000@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-25 at 15:19 +0530, Mahesh Palivela wrote:

> > OTOH, this would only matter to drivers that actually support all these
> > features, and those drivers could take care of not enabling the features
> > if their hardware doesn't support them. However, think of a driver that
> > is for different hardware, some that supports beamforming and some that
> > doesn't. Then if we mask out the beamforming capability of a station if
> > it's not locally supported, that driver could be simpler? Then again, if
> > we don't the driver just has to check if the hardware supports it, which
> > seems reasonable as well.
> >
> > Do you understand the issue?
> >
> 
> why should we mask out remote STA caps bits. Our local hw caps are in 
> sband->sta.vht_caps. remote caps sta_info->sta.vht_caps. In what way 
> drivers are connected with remote STA vht caps bits.

Well imagine you have a driver for some hardware that can do
beamforming, and the same driver can also work with hardware that
doesn't. If we restrict remote caps, like we do for HT, the driver
doesn't have to worry about this but can just do whatever the remote
caps say is possible. If we don't restrict it, the driver has to also
check its own caps.

We can do this, and I suspect it will be simpler, but it needs to be
*very clearly* documented since VHT will then be different from HT.

johannes

