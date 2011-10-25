Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51479 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab1JYMFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 08:05:54 -0400
Date: Tue, 25 Oct 2011 17:35:40 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: Re: [PATCH 34/34] ath6kl: Enable not more than one interface to
	workaround target assert
Message-ID: <20111025120539.GA22698@vasanth-laptop> (sfid-20111025_140557_955523_8E67522D)
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com> <1319537430-12459-35-git-send-email-vthiagar@qca.qualcomm.com> <4EA6A0CF.70806@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4EA6A0CF.70806@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 25, 2011 at 02:43:11PM +0300, Kalle Valo wrote:
> On 10/25/2011 01:10 PM, Vasanthakumar Thiagarajan wrote:
> > Configuring the firmware for three interfaces causes random
> > target assert. So restrict the number of vifs to just 1
> > to avoid this issue for now. Once it is fixed in firmware,
> > this patch would be reverted.
> 
> Patches 32-34 are problematic. They are changing functionality of
> patches earlier in the series. (I guess you created those patches
> later.) Instead you should edit the original patches, not just add extra
> patches on top.

Patch 32 and 33 are clean ups, i don't think integrating these
changes into respective patches would be trivial with the number
of patches that need to be rebased after the change. So I can drop
these two patches and send them sometime later. Regarding patch 34,
the target configuration changes needed for multi vif are done
in more than one patches and integrating this change into those
changes would not make sense to those configurations. Let me see
how I can integrate this.

> 
> For example, having this patch will break bisect as ath6kl will be
> broken between the patch enabling multi interface functionality
> (whatever patch that is) and this patch.

Agreed.

Vasanth
