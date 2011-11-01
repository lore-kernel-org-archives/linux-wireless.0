Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22472 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1KAMN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 08:13:29 -0400
Message-ID: <4EAFE222.6050504@qca.qualcomm.com> (sfid-20111101_131332_138171_51A36A40)
Date: Tue, 1 Nov 2011 14:12:18 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix lockdep warning
References: <1320145730-3007-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1320145730-3007-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2011 01:08 PM, Vasanthakumar Thiagarajan wrote:
> The following is the lockdep warning which detects possible
> deadlock condition with the way ar->lock and ar->list_lock
> are being used.
> 
>   (&(&ar->lock)->rlock){+.-...}, at: [<ffffffffa0492d13>] ath6kl_indicate_tx_activity+0x83/0x110 [ath6kl]
>  but this lock took another, SOFTIRQ-unsafe lock in the past:
>   (&(&ar->list_lock)->rlock){+.+...}
> 
>  and interrupts could create inverse lock ordering between them.
> 
>  other info that might help us debug this:
>   Possible interrupt unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&(&ar->list_lock)->rlock);
>                                 local_irq_disable();
>                                 lock(&(&ar->lock)->rlock);
>                                 lock(&(&ar->list_lock)->rlock);
>    <Interrupt>
>      lock(&(&ar->lock)->rlock);
> 
>   *** DEADLOCK ***
> 
> softirqs have to be disabled when acquiring ar->list_lock to avoid
> the above deadlock condition. When the above warning printed the
> interface is still up and running without issue.
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
