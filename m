Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56959 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0KLITn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 03:19:43 -0500
Received: by qwi4 with SMTP id 4so778883qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 00:19:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
References: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
Date: Fri, 12 Nov 2010 09:19:42 +0100
Message-ID: <AANLkTimuS1_2=ZBX0BXP_EeOq92iR9to0bFtxgi9HpZ1@mail.gmail.com>
Subject: Re: [PATCH 1/3] iwl3945: remove unused len_org variable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Against which GIT tree has your patchset to be applied?

- Sedat -

On Fri, Nov 12, 2010 at 8:47 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 931c546..f2ce7dd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -475,7 +475,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>        dma_addr_t phys_addr;
>        dma_addr_t txcmd_phys;
>        int txq_id = skb_get_queue_mapping(skb);
> -       u16 len, idx, len_org, hdr_len; /* TODO: len_org is not used */
> +       u16 len, idx, hdr_len;
>        u8 id;
>        u8 unicast;
>        u8 sta_id;
> @@ -612,15 +612,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>         */
>        len = sizeof(struct iwl3945_tx_cmd) +
>                        sizeof(struct iwl_cmd_header) + hdr_len;
> -
> -       len_org = len;
>        len = (len + 3) & ~3;
>
> -       if (len_org != len)
> -               len_org = 1;
> -       else
> -               len_org = 0;
> -
>        /* Physical address of this Tx command's header (not MAC header!),
>         * within command buffer array. */
>        txcmd_phys = pci_map_single(priv->pci_dev, &out_cmd->hdr,
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
