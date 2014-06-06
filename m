Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:59049 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaFFJpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 05:45:10 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so2485695wes.40
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2014 02:45:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877g4umn7b.fsf@kamboji.qca.qualcomm.com>
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87egz3nxdn.fsf@kamboji.qca.qualcomm.com>
	<5390B632.7030305@candelatech.com>
	<87wqcumuuw.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkzVLQJcsNfSr=r8d0F_opsHEim0fgxMGhPHGyhz0KBzw@mail.gmail.com>
	<877g4umn7b.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 6 Jun 2014 11:45:08 +0200
Message-ID: <CA+BoTQmyXy1dSdhugSiXq50C4DpjbRWBcopn0b3anJ4W55oCwA@mail.gmail.com> (sfid-20140606_114514_697650_D939AA32)
Subject: Re: [PATCH 1/4] ath10k: provide firmware crash info via debugfs.
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 June 2014 10:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 6 June 2014 08:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Ben Greear <greearb@candelatech.com> writes:
>> [...]
>>>> I'm a bit leery of adding spin-locks in the dump routine just for
>>>> this, but I can add and use a new spin-lock if you prefer.
>>>
>>> Why a new spinlock? I didn't review the locking requirements, but I
>>> would first check ar->data_lock can be used.
>>>
>>>> If so, any idea if we can do the reads of the target's memory while
>>>> holding a spin-lock, or would I need some temporary buffers and only
>>>> lock while copying that in to the storage in the 'ar'?
>>>
>>> I don't see why you would need special locks for reading target's
>>> memory. If there is something needed, pci.c should handle that. Michal?
>>
>> By definition the diagnostic window access must be serialized. We
>> don't do this with locks now but rely ON driver states/sequences. We
>> might have some problems lurking there already but I'd need to analyze
>> it to tell for sure.
>
> Should that serialisation happen within pci.c?

You can but that's not a requirement I guess. E.g. exchange_bmi_msg
hif callback requires the caller to serialize calls.


Michał
