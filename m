Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaEWHQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:16:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: make core registering async
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<87ppj5wyri.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmxGEFSxyw84wQUrkbyq55UqMgwR2Vt+1nd29sTn=g7kQ@mail.gmail.com>
Date: Fri, 23 May 2014 10:16:27 +0300
In-Reply-To: <CA+BoTQmxGEFSxyw84wQUrkbyq55UqMgwR2Vt+1nd29sTn=g7kQ@mail.gmail.com>
	(Michal Kazior's message of "Fri, 23 May 2014 09:13:09 +0200")
Message-ID: <874n0hvub8.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_091636_557793_D4DBECFB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>>> @@ -2758,8 +2758,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
>>>       if (!ar_pci)
>>>               return;
>>>
>>> -     tasklet_kill(&ar_pci->msi_fw_err);
>>
>> Why this? That's not obvious to me.
>
> It might end up not being initialized: If you, say, quickly insert and
> eject a device you might not even initialize the tasklet (it's done
> elsewhere; I suppose we could move it too) before ath10k_pci_remove()
> is called. Also the tasklet is already killed elsewhere on the
> teardown code path.
>
> I'll split it into a separate patch that simply removes this line as
> it's meaningless to call it here in the first place.

Yeah, it's a good idea to have a separate patch for this.

-- 
Kalle Valo
