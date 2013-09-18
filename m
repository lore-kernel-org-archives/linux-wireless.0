Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54578 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3IRMgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:36:24 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so5661455wgh.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 05:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=fRoVXNaeiiWUwc_tLiW4GJZnCKJKYO55+JHqOSasAkA@mail.gmail.com>
References: <1379497651-29933-1-git-send-email-bartosz.markowski@tieto.com>
	<CA+BoTQ=fRoVXNaeiiWUwc_tLiW4GJZnCKJKYO55+JHqOSasAkA@mail.gmail.com>
Date: Wed, 18 Sep 2013 14:36:22 +0200
Message-ID: <CACKGw+HgRbZU4DV5ZFHZA-X-78nEUd87hDeabMr1r1fRc-yOvw@mail.gmail.com> (sfid-20130918_143638_444396_40971080)
Subject: Re: [PATCH] ath10k: implement host memory chunks feature
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 September 2013 12:51, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 18 September 2013 11:47, Bartosz Markowski

[...]

>> +#define MAX_MEM_CHUNKS 32
>
> I think this should be prefixed with ATH10K_.

I'll fix this in v2, thanks

>> +
>> +       /* Allocate/Free the host memory for firmware use */
>> +       int (*chunk_alloc)(struct ath10k *ar, u32 req_id, u32 index,
>> +                          u32 num_units, u32 unit_len);
>> +
>> +       void (*chunk_free)(struct ath10k *ar, int idx);
>
> Can't we simply use dma_alloc_coherent(ar->dev) and avoid this HIF
> abstraction? pci_alloc_consistent is just an alias for
> dma_alloc_coherent anyway.

I guess so, but that's only an option If there's no NACK for current
version, I will keep it as is.

>> @@ -173,4 +179,21 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
>>         return ar->hif.ops->resume(ar);
>>  }
>>
>> +static inline int ath10k_hif_chunk_alloc(struct ath10k *ar,
>> +                                        u32 req_id,
>> +                                        u32 idx,
>> +                                        u32 num_units,
>> +                                        u32 unit_len)
>> +{
>> +       if (!ar->hif.ops->chunk_alloc)
>> +               return -EOPNOTSUPP;
>> +
>> +       return ar->hif.ops->chunk_alloc(ar, req_id, idx, num_units, unit_len);
>> +}
>> +
>> +static inline void ath10k_hif_chunk_free(struct ath10k *ar, int idx)
>> +{
>
> Missing check for hif.ops->chunk_free pointer here?

As in all void callbacks there. Maybe I will send a separte patch to add this.

>> +       ar->hif.ops->chunk_free(ar, idx);
>> +}
>> +
>>  #endif /* _HIF_H_ */
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index f1faf46..547d67d 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -1966,6 +1966,49 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
>>  }
>>  #endif
>>
>> +static int ath10k_pci_hif_chunk_alloc(struct ath10k *ar,
>> +                                     u32 req_id,
>> +                                     u32 idx,
>> +                                     u32 num_units,
>> +                                     u32 unit_len)
>> +{
>> +       dma_addr_t paddr;
>> +       struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>> +
>> +       if (!num_units  || !unit_len)
>> +               return 0;
>> +
>
> I'm not seeing any checks against buffer overflow of mem_chunks[req_id].

if (idx == ATH10K_MAX_MEM_CHUNKS) in ath10k_wmi_alloc_host_mem ?

>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 6803ead..89de893 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -22,6 +22,7 @@
>>  #include "debug.h"
>>  #include "wmi.h"
>>  #include "mac.h"
>> +#include "hif.h"
>>
>>  int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
>>  {
>> @@ -964,6 +965,46 @@ static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
>>         ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
>>  }
>>
>> +#define HOST_MEM_SIZE_UNIT 4
>> +
>> +static void ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
>> +                                     u32 num_units, u32 unit_len)
>> +{
>> +       u32 remaining_units, allocated_units, idx;
>> +
>> +       /* adjust the length to nearest multiple of unit size */
>> +       unit_len = (unit_len + (HOST_MEM_SIZE_UNIT - 1)) &
>> +                  (~(HOST_MEM_SIZE_UNIT - 1));
>
> round_up() ?

Good point :) Thanks

>> @@ -1013,12 +1054,44 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
>>                          ar->fw_version_build);
>>         }
>>
>> -       /* FIXME: it probably should be better to support this */
>> -       if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
>> -               ath10k_warn("target requested %d memory chunks; ignoring\n",
>> +       WARN_ON(__le32_to_cpu(ev->num_mem_reqs) > WMI_MAX_MEM_REQS);
>
> This seems wrong.
>
> ath10k_warn() should be used here. Is it really safe to continue and
> use the num_mem_reqs while it exceeds the limit?

I will change to ath10k_warn(). As far as I know there's no case FW
requests more than 1 mem_req, but
hmm maybe it's better to fallback here..

>> +
>> +       if (__le32_to_cpu(ev->num_mem_reqs)) {
>
> if (!__le32_to_cpu(ev->num_mem_reqs))
>   return;

Right, thanks

-- 
Bartosz
