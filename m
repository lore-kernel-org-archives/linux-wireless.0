Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34296 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbB0IKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:10:52 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: more_task flag for main_process
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423676547-5213-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <szli@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150227081051.979A913FB80@smtp.codeaurora.org> (sfid-20150227_091101_728685_F292B45E)
Date: Fri, 27 Feb 2015 08:10:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Shengzhen Li <szli@marvell.com>
> 
> This patch handles a corner case where TX packet would remain in
> driver queue till next packet comes in.
> Here is sequence:
> 1. TX packet is queued via hard_start_xmit and main_work is queued
> 2. SDIO interrupt comes in which directly call mwifiex_main_process.
> This starts executing main superloop.
> 3. Now work from step1 is scheduled but at first check itself it sees
> mwifiex_processing is set and exits.
> 4. Now if superloop from step2 has passed TX processing part of superloop
> this packet would remain in queue until next packet/command/SDIO interrupt
> arrives and queues main_work.
> 
> This patch fixes this corner case by defining more_task flag which is set when
> mwifiex_processing is found to be true. At end of superloop we again check if
> more_task flag is set and if set, execute superloop again.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

04c7b363c9f7 mwifiex: more_task flag for main_process
7521ce6eb2d3 mwifiex: do not process mgmt rx on uninitialized interface
b4e8aebbc7c2 mwifiex: change datatype to bool for device capability flags
1c4c24eb7e96 mwifiex: modify TX buff size for SD8887

Kalle Valo
