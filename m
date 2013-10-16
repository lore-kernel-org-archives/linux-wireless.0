Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48784 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760834Ab3JPPz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 11:55:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 6/8] ath10k: implement ath10k_pci_soc_read/write32()
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
	<20131016134611.25095.80204.stgit@localhost6.localdomain6>
	<CA+BoTQmP14xuXP=D4mEsJiWOXvtg0iJ4=BmUb=89QgA_AX5edA@mail.gmail.com>
Date: Wed, 16 Oct 2013 18:55:50 +0300
In-Reply-To: <CA+BoTQmP14xuXP=D4mEsJiWOXvtg0iJ4=BmUb=89QgA_AX5edA@mail.gmail.com>
	(Michal Kazior's message of "Wed, 16 Oct 2013 08:38:43 -0700")
Message-ID: <87txgh5hx5.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_175603_259879_B6F6D809)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 16 October 2013 06:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> To make it easier to access SOC registers. No functional
>> changes.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/pci.c |    3 +--
>>  drivers/net/wireless/ath/ath10k/pci.h |   10 ++++++++++
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index d09f8a2..5c78383 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -2454,8 +2454,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>>                 return ret;
>>         }
>>
>> -       chip_id = ath10k_pci_read32(ar,
>> -                                   RTC_SOC_BASE_ADDRESS + SOC_CHIP_ID_ADDRESS);
>> +       chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
>>
>>         ath10k_do_pci_sleep(ar);
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
>> index 52fb7b9..a304c33 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.h
>> +++ b/drivers/net/wireless/ath/ath10k/pci.h
>> @@ -318,6 +318,16 @@ static inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
>>         return ioread32(ar_pci->mem + offset);
>>  }
>>
>> +static inline u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr)
>> +{
>> +       return ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS + addr);
>> +}
>> +
>> +static inline void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val)
>> +{
>> +       ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + addr, val);
>> +}
>> +
>
> I'm not entirely sure about this. There are a couple of soc address
> groups (RTC_SOC, RTC_WMAC, SOC_PCIE, SOC_CORE, ..).

And then we can have different functions for each group.

> I'd rather use just raw ioread/iowrite than have all those wrappers.

Well, I again would prefer to have clean interfaces instead of doing
address arithmetic in every call :)

> I think the reason for having ath10k_pci_{read,write}32 was the HW v1
> workaround.

No, it was also to make the code simple.

> Do we really need to keep it?

In my opinion yes. What is the negative side of keeping them? Why don't
you like these wrappers?

-- 
Kalle Valo
