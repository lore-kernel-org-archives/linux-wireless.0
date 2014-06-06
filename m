Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45590 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaFFIzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 04:55:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87egz3nxdn.fsf@kamboji.qca.qualcomm.com>
	<5390B632.7030305@candelatech.com>
	<87wqcumuuw.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkzVLQJcsNfSr=r8d0F_opsHEim0fgxMGhPHGyhz0KBzw@mail.gmail.com>
Date: Fri, 6 Jun 2014 11:55:36 +0300
In-Reply-To: <CA+BoTQkzVLQJcsNfSr=r8d0F_opsHEim0fgxMGhPHGyhz0KBzw@mail.gmail.com>
	(Michal Kazior's message of "Fri, 6 Jun 2014 08:30:09 +0200")
Message-ID: <877g4umn7b.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_105558_192908_10D1FFED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 6 June 2014 08:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Ben Greear <greearb@candelatech.com> writes:
> [...]
>>> I'm a bit leery of adding spin-locks in the dump routine just for
>>> this, but I can add and use a new spin-lock if you prefer.
>>
>> Why a new spinlock? I didn't review the locking requirements, but I
>> would first check ar->data_lock can be used.
>>
>>> If so, any idea if we can do the reads of the target's memory while
>>> holding a spin-lock, or would I need some temporary buffers and only
>>> lock while copying that in to the storage in the 'ar'?
>>
>> I don't see why you would need special locks for reading target's
>> memory. If there is something needed, pci.c should handle that. Michal?
>
> By definition the diagnostic window access must be serialized. We
> don't do this with locks now but rely ON driver states/sequences. We
> might have some problems lurking there already but I'd need to analyze
> it to tell for sure.

Should that serialisation happen within pci.c?

> Calling pci_diag_* functions while holding a spinlock should otherwise
> be fine because these functions use mdelay() and poll the diagnostic
> window copy engine pipe.
>
> Using ar->data_lock for a pci transport specific requirement (the
> diagnostic window) seems wrong though.

I agree. I did not mean using data_lock to serialise the pci code.

-- 
Kalle Valo
