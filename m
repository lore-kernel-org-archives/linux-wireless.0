Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59905 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3IRKv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 06:51:26 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so2758131bkb.31
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 03:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379497651-29933-1-git-send-email-bartosz.markowski@tieto.com>
References: <1379497651-29933-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 18 Sep 2013 12:51:24 +0200
Message-ID: <CA+BoTQ=fRoVXNaeiiWUwc_tLiW4GJZnCKJKYO55+JHqOSasAkA@mail.gmail.com> (sfid-20130918_125130_168358_D9B7AEBF)
Subject: Re: [PATCH] ath10k: implement host memory chunks feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 September 2013 11:47, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> Firmware can request a memory pool from host to offload
> it's own resources. This is a feature designed especially
> for AP mode where the target has to deal with large number
> of peers.
>
> So we allocate and map a consistent DMA memory which FW can
> use to store e.g. peer rate contol maps.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h |   12 +++
>  drivers/net/wireless/ath/ath10k/hif.h  |   23 ++++++
>  drivers/net/wireless/ath/ath10k/pci.c  |   45 +++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c  |  129 ++++++++++++++++++++++++++++++--
>  drivers/net/wireless/ath/ath10k/wmi.h  |   12 ++-
>  5 files changed, 209 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index fcf94ee..c194f61 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -278,6 +278,15 @@ enum ath10k_fw_features {
>         ATH10K_FW_FEATURE_COUNT,
>  };
>
> +#define MAX_MEM_CHUNKS 32

I think this should be prefixed with ATH10K_.


> +
> +struct ath10k_mem_chunk {
> +       void *vaddr;
> +       dma_addr_t paddr;
> +       u32 len;
> +       u32 req_id;
> +};
> +
>  struct ath10k {
>         struct ath_common ath_common;
>         struct ieee80211_hw *hw;
> @@ -297,6 +306,9 @@ struct ath10k {
>         u32 vht_cap_info;
>         u32 num_rf_chains;
>
> +       u32 num_mem_chunks;
> +       struct ath10k_mem_chunk mem_chunks[MAX_MEM_CHUNKS];
> +
>         DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
>
>         struct targetdef *targetdef;
> diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
> index dcdea68..4af6a66 100644
> --- a/drivers/net/wireless/ath/ath10k/hif.h
> +++ b/drivers/net/wireless/ath/ath10k/hif.h
> @@ -83,6 +83,12 @@ struct ath10k_hif_ops {
>
>         int (*suspend)(struct ath10k *ar);
>         int (*resume)(struct ath10k *ar);
> +
> +       /* Allocate/Free the host memory for firmware use */
> +       int (*chunk_alloc)(struct ath10k *ar, u32 req_id, u32 index,
> +                          u32 num_units, u32 unit_len);
> +
> +       void (*chunk_free)(struct ath10k *ar, int idx);

Can't we simply use dma_alloc_coherent(ar->dev) and avoid this HIF
abstraction? pci_alloc_consistent is just an alias for
dma_alloc_coherent anyway.


>  };
>
>
> @@ -173,4 +179,21 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
>         return ar->hif.ops->resume(ar);
>  }
>
> +static inline int ath10k_hif_chunk_alloc(struct ath10k *ar,
> +                                        u32 req_id,
> +                                        u32 idx,
> +                                        u32 num_units,
> +                                        u32 unit_len)
> +{
> +       if (!ar->hif.ops->chunk_alloc)
> +               return -EOPNOTSUPP;
> +
> +       return ar->hif.ops->chunk_alloc(ar, req_id, idx, num_units, unit_len);
> +}
> +
> +static inline void ath10k_hif_chunk_free(struct ath10k *ar, int idx)
> +{

Missing check for hif.ops->chunk_free pointer here?


> +       ar->hif.ops->chunk_free(ar, idx);
> +}
> +
>  #endif /* _HIF_H_ */
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index f1faf46..547d67d 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1966,6 +1966,49 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
>  }
>  #endif
>
> +static int ath10k_pci_hif_chunk_alloc(struct ath10k *ar,
> +                                     u32 req_id,
> +                                     u32 idx,
> +                                     u32 num_units,
> +                                     u32 unit_len)
> +{
> +       dma_addr_t paddr;
> +       struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
> +
> +       if (!num_units  || !unit_len)
> +               return 0;
> +

I'm not seeing any checks against buffer overflow of mem_chunks[req_id].


> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 6803ead..89de893 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -22,6 +22,7 @@
>  #include "debug.h"
>  #include "wmi.h"
>  #include "mac.h"
> +#include "hif.h"
>
>  int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
>  {
> @@ -964,6 +965,46 @@ static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
>         ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
>  }
>
> +#define HOST_MEM_SIZE_UNIT 4
> +
> +static void ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
> +                                     u32 num_units, u32 unit_len)
> +{
> +       u32 remaining_units, allocated_units, idx;
> +
> +       /* adjust the length to nearest multiple of unit size */
> +       unit_len = (unit_len + (HOST_MEM_SIZE_UNIT - 1)) &
> +                  (~(HOST_MEM_SIZE_UNIT - 1));

round_up() ?


> @@ -1013,12 +1054,44 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
>                          ar->fw_version_build);
>         }
>
> -       /* FIXME: it probably should be better to support this */
> -       if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
> -               ath10k_warn("target requested %d memory chunks; ignoring\n",
> +       WARN_ON(__le32_to_cpu(ev->num_mem_reqs) > WMI_MAX_MEM_REQS);

This seems wrong.

ath10k_warn() should be used here. Is it really safe to continue and
use the num_mem_reqs while it exceeds the limit?


> +
> +       if (__le32_to_cpu(ev->num_mem_reqs)) {

if (!__le32_to_cpu(ev->num_mem_reqs))
  return;



Micha³.
