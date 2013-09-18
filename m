Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39046 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IRNH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:07:27 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so2766767bkb.24
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 06:07:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKGw+HgRbZU4DV5ZFHZA-X-78nEUd87hDeabMr1r1fRc-yOvw@mail.gmail.com>
References: <1379497651-29933-1-git-send-email-bartosz.markowski@tieto.com>
	<CA+BoTQ=fRoVXNaeiiWUwc_tLiW4GJZnCKJKYO55+JHqOSasAkA@mail.gmail.com>
	<CACKGw+HgRbZU4DV5ZFHZA-X-78nEUd87hDeabMr1r1fRc-yOvw@mail.gmail.com>
Date: Wed, 18 Sep 2013 15:07:24 +0200
Message-ID: <CA+BoTQ=hxXkkFhTJSikoAbCa1CLZE+P7n0dWjYStany6bs9vGA@mail.gmail.com> (sfid-20130918_150731_339145_519553E7)
Subject: Re: [PATCH] ath10k: implement host memory chunks feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 September 2013 14:36, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> On 18 September 2013 12:51, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 18 September 2013 11:47, Bartosz Markowski
>>> +       ar->hif.ops->chunk_free(ar, idx);
>>> +}
>>> +
>>>  #endif /* _HIF_H_ */
>>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>>> index f1faf46..547d67d 100644
>>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>>> @@ -1966,6 +1966,49 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
>>>  }
>>>  #endif
>>>
>>> +static int ath10k_pci_hif_chunk_alloc(struct ath10k *ar,
>>> +                                     u32 req_id,
>>> +                                     u32 idx,
>>> +                                     u32 num_units,
>>> +                                     u32 unit_len)
>>> +{
>>> +       dma_addr_t paddr;
>>> +       struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>>> +
>>> +       if (!num_units  || !unit_len)
>>> +               return 0;
>>> +
>>
>> I'm not seeing any checks against buffer overflow of mem_chunks[req_id].
>
> if (idx == ATH10K_MAX_MEM_CHUNKS) in ath10k_wmi_alloc_host_mem ?

Oh, but the check is _after_ call to chunk_alloc(). What if
ath10k_wmi_alloc_host_mem() were to be called while idx == MAX?


Micha³.
