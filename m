Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38688 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000Ab3EHVFy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 17:05:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 8 May 2013 14:04:50 -0700
Subject: RE: [PATCH] mwifiex: fix setting of multicast filter
Message-ID: <477F20668A386D41ADCC57781B1F70430DD2CA04C1@SC-VEXCH1.marvell.com> (sfid-20130508_230558_682663_D2441343)
References: <20130508193719.BC51FFA9CF@dev.laptop.org>
In-Reply-To: <20130508193719.BC51FFA9CF@dev.laptop.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Thanks for the patch.

> A small bug in this code was causing the ALLMULTI filter to be set
> when in fact we were just wanting to program a selective multicast list
> to the hardware.
> 
> Fix that bug and remove a redundant if condition in the code that
> follows.
> 
> This fixes wakeup behaviour when multicast WOL is enabled. Previously,
> all multicast packets would wake up the system. Now, only those that the
> host intended to receive trigger wakeups.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Cc: <stable@vger.kernel.org>
Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/sta_ioctl.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)

