Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13281 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2AIOzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 09:55:21 -0500
Date: Mon, 9 Jan 2012 20:24:57 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Use a mutex_lock to avoid race in diabling and
 handling irq
Message-ID: <20120109145455.GA14892@chvasanth-lnx> (sfid-20120109_155525_355838_B7E6BEFE)
References: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com>
 <4F0AF830.9000506@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F0AF830.9000506@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 09, 2012 at 04:22:40PM +0200, Kalle Valo wrote:
> On 01/04/2012 12:27 PM, Vasanthakumar Thiagarajan wrote:
> > Currently this race is handled but in a messy way an atomic
> > variable is being checked in a loop which sleeps upto ms
> > in every iteration. Remove this logic and use a mutex
> > to make sure irq is not disabled when irq handling is in
> > progress.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> 
> Thanks, applied.
> 
> There is one race, though. It's possible that the irq handler is
> executed once after the interrupts are disabled. Do we care about that?

I don't think so, we read interrupt status only when the interrupts
are enabled by checking dev->irq_en_reg.int_status_en in
proc_pending_irqs(), so it is already taken care.

Vasanth
