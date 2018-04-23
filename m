Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46380 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754749AbeDWLuF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 07:50:05 -0400
Received: by mail-oi0-f67.google.com with SMTP id y15-v6so5980453oia.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2018 04:50:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521899099-23634-1-git-send-email-festevam@gmail.com>
References: <1521899099-23634-1-git-send-email-festevam@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 23 Apr 2018 08:50:04 -0300
Message-ID: <CAOMZO5BYGmGtw+npoejVoWHDYsqtZSrX7qMxD0YM33xTv0xStA@mail.gmail.com> (sfid-20180423_135009_791031_4E263683)
Subject: Re: [PATCH 1/2] nfc: st21nfca: Check for devm_kzalloc() failure
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        linux-nfc@lists.01.org, Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

Maybe this patch series got forgotten?



On Sat, Mar 24, 2018 at 10:44 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> devm_kzalloc() may fail, so we should better check for error and
> propagate the error in the case of allocation failure.
>
> This avoids a potential NULL pointer dereference later on.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
>  drivers/nfc/st21nfca/se.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index 4bed9e84..fd967a3 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -328,6 +328,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>
>                 transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
>                                                    skb->len - 2, GFP_KERNEL);
> +               if (!transaction)
> +                       return -ENOMEM;
>
>                 transaction->aid_len = skb->data[1];
>                 memcpy(transaction->aid, &skb->data[2],
> --
> 2.7.4
>
