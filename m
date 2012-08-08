Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47200 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2HHOxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:53:55 -0400
Date: Wed, 8 Aug 2012 20:25:33 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
Message-ID: <20120808145531.GB2041@vmraj-lnx.qualcomm.com> (sfid-20120808_165359_637483_B4556486)
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
 <1344344772-49459-2-git-send-email-nbd@openwrt.org>
 <1344344772-49459-3-git-send-email-nbd@openwrt.org>
 <1344344772-49459-4-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1344344772-49459-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 07, 2012 at 03:06:12PM +0200, Felix Fietkau wrote:
> This feature had been disabled in ath9k because the code to support
> it was incomplete, but now the code is in sync with the internal QCA
> codebase, so it's time to enable it.
> 
> On many newer devices, the calibration is assumed to be done with PA
> linearization enabled.
> 
> Tests with a particular AR933x device showed that the signal emitted
> at full power was highly distorted and unreliable with PA linearization
> disabled. With this patch, the signal becomes clear and stability
> is improved.
> 
We faced stability issues with 938x chipsets when paprd is enabled. The commit
6f4810101a629b31b5427872a09ea092cfc5c4bd states one of the issue. Even if it
helps for AR933x, let us enable it only for that chip alone.

-Rajkumar
