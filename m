Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52257 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab3GCWko convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 18:40:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 3 Jul 2013 15:39:50 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2E0674B@SC-VEXCH1.marvell.com> (sfid-20130704_004047_956989_5DAD5E8F)
References: <20130703015653.82651FAAD5@dev.laptop.org>
In-Reply-To: <20130703015653.82651FAAD5@dev.laptop.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Make the driver continue to ack interrupts during shutdown to avoid
> this. This is harder than it might sound.
> 
> We must be careful not to act upon the interrupt, only ack it.
> Otherwise, we end up setting int_status to something. And hw_status is
> set to MWIFIEX_HW_STATUS_CLOSING for obvious reasons. We would hit the
> following infinite loop in mwifiex_main_process:
> 
> 	process_start:
> 	do {
> 		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
> 		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
> 			break;
> 		[...]
> 	} while (true);
> 	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
> 		goto process_start;
> 
> We must also observe that ACKing interrupts involves reading a load
> of data into the mp_regs buffer. The driver doesn't do much in the
> way of ensuring that interrupts are disabled before freeing buffers
> such as mp_regs, but we do need something here to make sure that we
> don't get any interrupts after mp_regs is freed.
> 
> This whole thing feels rather fragile, but I couldn't see a clean
> way to do it, the driver seems a bit disorganised here. I would
> welcome a review from the designers.

Followings are the actions taken for driver unload.

   a) If device is connected, sync deauth command is sent.
   b) Auto deep sleep is cancelled by sending sync command
   c) Sync shutdown command is queued and HW_STATUS is changed to reset.
   d) Now no other command gets queued based on HW_STATUS.
   e) Wait for shutdown command response and handle it.
   f) Set surprise_removed flag which blocks SDIO interrupts

As per our design, we don't send any command to firmware after SHUTDOWN command. Also, firmware doesn't send any interrupt after SHUTDOWN command response.
The interrupt received after setting surprise_removed flag is unexpected. We need to get the exact procedure to replicate and figure out the root cause.

By thy way, I will be OOO for approximately two weeks. Amitkumar Karwar will continue to work with you to debug the issue.

Thanks,
Bing

