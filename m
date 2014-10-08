Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49836 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaJHMhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:37:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87a956hosb.fsf@kamboji.qca.qualcomm.com>
	<20141008104823.GB25666@qca.qualcomm.com>
	<CA+BoTQmOZiPQRWeiZ6QqZ5MhHbweMsdf94v1f5mkYpr2461j4A@mail.gmail.com>
Date: Wed, 8 Oct 2014 15:37:00 +0300
In-Reply-To: <CA+BoTQmOZiPQRWeiZ6QqZ5MhHbweMsdf94v1f5mkYpr2461j4A@mail.gmail.com>
	(Michal Kazior's message of "Wed, 8 Oct 2014 14:24:18 +0200")
Message-ID: <87fveyg2kz.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_143719_334009_D8DF795F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>>> Until now we have protected arvif->beacon_buf with data_lock. How do we
>>> know that this is safe to do without taking data_lock?
>>>
>> As said, spin_lock can not be used for dma_free_coherent.
>> arvif->beacon_buf is already protected by conf_mutex. At this state
>> in ath10k_halt path, no one can access beacon_buf. So mutex lock itself
>> is sufficient.
>
> beacon_buf is protected by conf_mutex implicitly. It wasn't the main
> intent. It is protected with data_lock spinlock.
>
> Do not trust the device - if there's a spurious SWBA event while
> ath10k_remove_interface() is running you could end up with invalid
> memory access.
>
> It might be acceptable to drop the spinlock for ath10k_halt() since
> the device is guaranteed to be stopped at that point (effectively
> reset) though.
>
> Anyway I'm hoping this bug can be fixed with the gfp flag.

Yeah, fixing this with the gfp flag would be much better solution.

-- 
Kalle Valo
