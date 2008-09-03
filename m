Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47671 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYICIKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 04:10:03 -0400
Subject: Re: [PATCH 4/9] iwlwifi: generic init calibrations framework
From: Marcel Holtmann <holtmann@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: yi.zhu@intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	emmanuel.grumbach@intel.com
In-Reply-To: <20080902.203634.127434142.davem@davemloft.net>
References: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	 <20080902.203634.127434142.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:10:11 +0200
Message-Id: <1220429411.6714.17.camel@californication> (sfid-20080903_101009_141777_41477F45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> > This patch fixes a critical bug that only the last calibration result
> > was applied. On reception of one calibration result all the calibration
> > results were freed therefore only last was applied. The patch fixes this
> > problem by introducing a generic init calibration framework which allows
> > variable number of init calibrations and allows addition new HW.
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 
> This is borderline, I would rather hold off on such a sizable change
> for 2.6.27 as I'll have a hard time justifying it.

do you see any way for fixing (or improving) this with the current code
and hold the whole framework change off until the next merge window.

Maybe instead of iwl_free_calib_results(priv); just freeing them
individually in their case statements.

You know the hardware better than I do, but that should just work
(judging from the code).

Regards

Marcel


