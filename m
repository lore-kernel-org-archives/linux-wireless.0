Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59651 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaEWHNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:13:10 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so650331wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 00:13:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppj5wyri.fsf@kamboji.qca.qualcomm.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<87ppj5wyri.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 May 2014 09:13:09 +0200
Message-ID: <CA+BoTQmxGEFSxyw84wQUrkbyq55UqMgwR2Vt+1nd29sTn=g7kQ@mail.gmail.com> (sfid-20140523_091314_617122_B8859B7B)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 18:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If ath10k was built into the kernel it could stall
>> booting for 120 seconds by default (60 seconds for
>> each firmware API variant) waiting for firmware
>> files before userspace was ready or filesystems
>> mounted.
>>
>> Fix this by making the core registering
>> asynchronous.
>>
>> This also shoves off about 1 second from boot time
>> on most systems since the driver is now mostly
>> initialized in a worker and modprobe takes very
>> little time to complete.
>>
>> As a side effect there's no way to propagate
>> registering errors to the pci subsystem but this
>> probably isn't really necessary.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -2758,8 +2758,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
>>       if (!ar_pci)
>>               return;
>>
>> -     tasklet_kill(&ar_pci->msi_fw_err);
>
> Why this? That's not obvious to me.

It might end up not being initialized: If you, say, quickly insert and
eject a device you might not even initialize the tasklet (it's done
elsewhere; I suppose we could move it too) before ath10k_pci_remove()
is called. Also the tasklet is already killed elsewhere on the
teardown code path.

I'll split it into a separate patch that simply removes this line as
it's meaningless to call it here in the first place.


Michał
