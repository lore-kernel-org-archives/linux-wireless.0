Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34155 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbFBHVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 03:21:38 -0400
Received: by wibut5 with SMTP id ut5so59809173wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 00:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433229267-11314-1-git-send-email-rmani@qti.qualcomm.com>
References: <1433229267-11314-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 2 Jun 2015 09:21:36 +0200
Message-ID: <CA+BoTQkfNB=fR=Vak729qFU2TOSC_8_fMfgRc1RJ1UO0t9XwRQ@mail.gmail.com> (sfid-20150602_092141_670396_BAF80529)
Subject: Re: [PATCH] ath10k: remove unused variable 'id' in ath10k_pci_tx_pipe_cleanup()
From: Michal Kazior <michal.kazior@tieto.com>
To: Raja Mani <rmani@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2015 at 09:14, Raja Mani <rmani@qti.qualcomm.com> wrote:
> mete_data is extracted from ce descriptor and stored in variable 'id'.
> later, id is not used anywhere in the same function.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 969a123..bbc349a 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1275,7 +1275,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
>         struct ath10k_ce_ring *ce_ring;
>         struct ce_desc *ce_desc;
>         struct sk_buff *skb;
> -       unsigned int id;
>         int i;
>
>         ar = pci_pipe->hif_ce_state;
> @@ -1299,8 +1298,6 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
>                         continue;
>
>                 ce_ring->per_transfer_context[i] = NULL;
> -               id = MS(__le16_to_cpu(ce_desc[i].flags),
> -                       CE_DESC_FLAGS_META_DATA);
>
>                 ar_pci->msg_callbacks_current.tx_completion(ar, skb);

Good catch. I forgot to remove this. I guess one could say this qualifies as:

 Fixes: d84a512dca23 ("ath10k: remove transfer_id from
ath10k_hif_cb::tx_completion")


Michał
