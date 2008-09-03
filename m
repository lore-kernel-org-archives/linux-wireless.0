Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40105 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYICN7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 09:59:08 -0400
Subject: Re: [PATCH 4/9] iwlwifi: generic init calibrations framework
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: David Miller <davem@davemloft.net>, yi.zhu@intel.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
In-Reply-To: <1ba2fa240809030223m56ce47aqf9f41fab7d3453ca@mail.gmail.com>
References: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	 <20080902.203634.127434142.davem@davemloft.net>
	 <1220429411.6714.17.camel@californication>
	 <1ba2fa240809030223m56ce47aqf9f41fab7d3453ca@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 15:59:15 +0200
Message-Id: <1220450355.6714.26.camel@californication> (sfid-20080903_155912_521035_0BB1035D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> > This patch fixes a critical bug that only the last calibration result
> >> > was applied. On reception of one calibration result all the calibration
> >> > results were freed therefore only last was applied. The patch fixes this
> >> > problem by introducing a generic init calibration framework which allows
> >> > variable number of init calibrations and allows addition new HW.
> >> >
> >> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> >>
> >> This is borderline, I would rather hold off on such a sizable change
> >> for 2.6.27 as I'll have a hard time justifying it.
> >
> > do you see any way for fixing (or improving) this with the current code
> > and hold the whole framework change off until the next merge window.
> >
> > Maybe instead of iwl_free_calib_results(priv); just freeing them
> > individually in their case statements.
> > You know the hardware better than I do, but that should just work
> > (judging from the code).
> 
> In general it's possible, but we've already tested this fix. Because
> this is sensitive, even if the code looks okay I cannot approve it
> until we run the whole validation cycle and measurements in the lab so
> it will take some time. Last time we broke it code also looked good :)

if I understood Dave correctly, then we either come up with a temporary
fix that is small and simple (even if it is not a long term solution) or
no fix for this issue is going into 2.6.27 at all. The fix that I have
in mind removes one line and adds 6 new ones.

And of course it needs to be tested, but that should be true for
everything that goes into the kernel. I can write the temporary patch
for it, but you guys are the experts with this hardware. So I leave it
up to you.

Regards

Marcel


