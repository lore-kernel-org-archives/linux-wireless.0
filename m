Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:50049 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaJHMYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:24:19 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so6609450vcb.30
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 05:24:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141008104823.GB25666@qca.qualcomm.com>
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87a956hosb.fsf@kamboji.qca.qualcomm.com>
	<20141008104823.GB25666@qca.qualcomm.com>
Date: Wed, 8 Oct 2014 14:24:18 +0200
Message-ID: <CA+BoTQmOZiPQRWeiZ6QqZ5MhHbweMsdf94v1f5mkYpr2461j4A@mail.gmail.com> (sfid-20141008_142422_725880_4611284A)
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2014 12:48, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> On Wed, Oct 08, 2014 at 12:52:04PM +0300, Kalle Valo wrote:
>> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>>
>> > The commit "ath10k: workaround fw beaconing bug" is freeing
>> > DMA-coherent memory in irq context which is hitting BUG ON
>> > in ARM platforms. Fix this by moving dma_free out of spin
>> > lock.
>
>> [...]
>>
>> > @@ -2404,8 +2389,15 @@ void ath10k_halt(struct ath10k *ar)
>> >
>> >     spin_lock_bh(&ar->data_lock);
>> >     list_for_each_entry(arvif, &ar->arvifs, list)
>> > -           ath10k_mac_vif_beacon_cleanup(arvif);
>> > +           ath10k_mac_vif_beacon_free(arvif);
>> >     spin_unlock_bh(&ar->data_lock);
>> > +   list_for_each_entry(arvif, &ar->arvifs, list) {
>> > +           if (!arvif->beacon_buf)
>> > +                   continue;
>> > +           dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
>> > +                             arvif->beacon_buf, arvif->beacon_paddr);
>> > +           arvif->beacon_buf = NULL;
>> > +   }
>> >  }
>>
>> Until now we have protected arvif->beacon_buf with data_lock. How do we
>> know that this is safe to do without taking data_lock?
>>
> As said, spin_lock can not be used for dma_free_coherent.
> arvif->beacon_buf is already protected by conf_mutex. At this state
> in ath10k_halt path, no one can access beacon_buf. So mutex lock itself
> is sufficient.

beacon_buf is protected by conf_mutex implicitly. It wasn't the main
intent. It is protected with data_lock spinlock.

Do not trust the device - if there's a spurious SWBA event while
ath10k_remove_interface() is running you could end up with invalid
memory access.

It might be acceptable to drop the spinlock for ath10k_halt() since
the device is guaranteed to be stopped at that point (effectively
reset) though.

Anyway I'm hoping this bug can be fixed with the gfp flag.


Michał
