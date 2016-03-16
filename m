Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34701 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935276AbcCPXQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 19:16:55 -0400
Received: by mail-ob0-f175.google.com with SMTP id ts10so67022227obc.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 16:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AFE41@POBOX.postoffice.danego.net>
References: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AFE41@POBOX.postoffice.danego.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Mar 2016 10:16:34 +1100
Message-ID: <CAGRGNgWT3KzAfdVZm8c0B62vWwfcnLA0DgXaKVGrbigTHuCLYw@mail.gmail.com> (sfid-20160317_001659_123811_740FA276)
Subject: Re: [PATCH 1/1] ath6kl: Fix SDIO broken scatter hif-scatter
To: =?UTF-8?Q?Robert_Deli=C3=ABn?= <robert@delien.nl>,
	"kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Fri, Nov 6, 2015 at 7:42 PM, Robert Deliën <robert@delien.nl> wrote:
> This patch fixes broken hif-scatter in ath6kl SDIO. It is not my work; I have found it as a difference between two Digi distributed Kernel source trees. No commit comment was recorded. I am sure there are better/nicer/cleaner way, but copying it as I found it is yet another difference less in the future. Feel free to use it in any way you see fit.
>
> Signed-off-by: Robert Delien <robert@delien.nl>

Did you ever re-send this patch? It looks like a fairly important fix
and was never applied.

Thanks,

Julian Calaby

>
>
> Index: drivers/net/wireless/ath/ath6kl/sdio.c
> ===================================================================
> --- drivers/net/wireless/ath/ath6kl/sdio.c      (revision 715)
> +++ drivers/net/wireless/ath/ath6kl/sdio.c      (revision 716)
> @@ -222,6 +222,7 @@
>                                         struct mmc_data *data)
>  {
>         struct scatterlist *sg;
> +       struct hif_scatter_item *scat_list;
>         int i;
>
>         data->blksz = HIF_MBOX_BLOCK_SIZE;
> @@ -240,14 +241,14 @@
>         sg = scat_req->sgentries;
>         sg_init_table(sg, scat_req->scat_entries);
>
> +       scat_list = &scat_req->scat_list[0];
> +
>         /* assemble SG list */
> -       for (i = 0; i < scat_req->scat_entries; i++, sg++) {
> +       for (i = 0; i < scat_req->scat_entries; i++, sg++, scat_list++) {
>                 ath6kl_dbg(ATH6KL_DBG_SCATTER, "%d: addr:0x%p, len:%d\n",
> -                          i, scat_req->scat_list[i].buf,
> -                          scat_req->scat_list[i].len);
> +                          i, scat_list->buf, scat_list->len);
>
> -               sg_set_buf(sg, scat_req->scat_list[i].buf,
> -                          scat_req->scat_list[i].len);
> +               sg_set_buf(sg, scat_list->buf, scat_list->len);
>         }
>
>         /* set scatter-gather table for request */
> @@ -348,7 +349,7 @@
>         int i, scat_req_sz, scat_list_sz, sg_sz, buf_sz;
>         u8 *virt_buf;
>
> -       scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
> +       scat_list_sz = n_scat_entry * sizeof(struct hif_scatter_item);
>         scat_req_sz = sizeof(*s_req) + scat_list_sz;
>
>         if (!virt_scat)
> Index: drivers/net/wireless/ath/ath6kl/hif.h
> ===================================================================
> --- drivers/net/wireless/ath/ath6kl/hif.h       (revision 715)
> +++ drivers/net/wireless/ath/ath6kl/hif.h       (revision 716)
> @@ -197,9 +197,9 @@
>         /* bounce buffer for upper layers to copy to/from */
>         u8 *virt_dma_buf;
>
> -       struct hif_scatter_item scat_list[1];
> +       u32 scat_q_depth;
>
> -       u32 scat_q_depth;
> +       struct hif_scatter_item scat_list[0];
>  };
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
