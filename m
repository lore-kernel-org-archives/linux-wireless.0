Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38544 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcDKSig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 14:38:36 -0400
Received: by mail-wm0-f47.google.com with SMTP id u206so116384123wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 11:38:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460388459-21090-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1460388459-21090-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Mon, 11 Apr 2016 11:38:34 -0700
Message-ID: <CAHCK0=OX_bMoC=dwawmdSsMxk0cS3CxadqT5Y3QAUnSvgAHw+A@mail.gmail.com> (sfid-20160411_203840_443743_CE3C3414)
Subject: Re: [PATCH] mwifiex: fix possible NULL dereference
From: Christian Daudt <csd@broadcom.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2016 at 8:27 AM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>
> We have a check for card just after dereferencing it. So if it is NULL
> we have already dereferenced it before its check. Lets dereference it
> after checking card for NULL.
>
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index edf8b07..84562d0 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2884,10 +2884,11 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
>  {
>         struct pcie_service_card *card = adapter->card;
>         const struct mwifiex_pcie_card_reg *reg;
> -       struct pci_dev *pdev = card->dev;
> +       struct pci_dev *pdev;


you might want to move the variable declaration into the if block
below to avoid it being left undefined

>         int i;
>
>         if (card) {
> +               pdev = card->dev;


to here
  +                struct pci_dev pdev = card->dev;

>
>                 if (card->msix_enable) {
>                         for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
>                                 synchronize_irq(card->msix_entries[i].vector);
>

cheers,
  csd
