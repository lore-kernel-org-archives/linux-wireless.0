Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaGNNZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 09:25:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix unregister deadlock when fw probe fails
References: <1404120720-14649-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 14 Jul 2014 16:25:11 +0300
In-Reply-To: <1404120720-14649-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 30 Jun 2014 11:32:00 +0200")
Message-ID: <87r41okr7s.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_152520_402900_969D216E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If firmware probing worker failed it called
> device_release_driver() which synchronously called
> remove() pci callback. The callback in turn waited
> for the worker that called it to finish resulting
> in a deadlock.
>
> Waiting for a completion instead of a worker, like
> some other drivers do, doesn't seem like the best
> idea either:
>
>   Syscall                 Worker
>
>                           probe_fw()
>   rmmod
>   dev_lock()
>   pci->remove()
>   wait_for_completion()
>                           complete_all()
>                           device_release_driver()
>                           dev_lock()
>                           [sleep]
>   free(ar)
>   dev_unlock()
>                           [resume]
>
> There's no guarantee that Worker upon resuming can
> still access any data/code of the module.
>
> Leaving device bound to a driver is not as harmful
> as deadlocking so remove the call to
> device_release_driver() while a proper solution is
> figured out.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
