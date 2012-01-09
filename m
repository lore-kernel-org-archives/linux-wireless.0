Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54545 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2AIOW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 09:22:59 -0500
Message-ID: <4F0AF830.9000506@qca.qualcomm.com> (sfid-20120109_152304_104557_C467FAF9)
Date: Mon, 9 Jan 2012 16:22:40 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Use a mutex_lock to avoid race in diabling and
 handling irq
References: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2012 12:27 PM, Vasanthakumar Thiagarajan wrote:
> Currently this race is handled but in a messy way an atomic
> variable is being checked in a loop which sleeps upto ms
> in every iteration. Remove this logic and use a mutex
> to make sure irq is not disabled when irq handling is in
> progress.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

There is one race, though. It's possible that the irq handler is
executed once after the interrupts are disabled. Do we care about that?

AFAICS this race was before your patch so I'll take your patch anyway.

Kalle
