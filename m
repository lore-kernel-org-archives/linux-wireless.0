Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35203 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbcDLOIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 10:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <1460388459-21090-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1460388459-21090-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Tue, 12 Apr 2016 17:08:05 +0300
Message-ID: <CAHp75VfO3A+HBjkjc9WC9jzB9gtYrVM6izLmpiqLntChGOzjMA@mail.gmail.com> (sfid-20160412_160825_276618_30D480E1)
Subject: Re: [PATCH] mwifiex: fix possible NULL dereference
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2016 at 6:27 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>
> We have a check for card just after dereferencing it. So if it is NULL
> we have already dereferenced it before its check. Lets dereference it
> after checking card for NULL.

IIUC the code does nothing with dereference.

I would have told NAK if I would have been maintainer.

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

Let's say it's 0.

>         const struct mwifiex_pcie_card_reg *reg;
> -       struct pci_dev *pdev = card->dev;

This would be equal to offset of dev member in pcie_service_card struct.

Nothing wrong here.

> +       struct pci_dev *pdev;
>         int i;
>
>         if (card) {
> +               pdev = card->dev;
>                 if (card->msix_enable) {
>                         for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
>                                 synchronize_irq(card->msix_entries[i].vector);
> --
> 1.9.1
>



-- 
With Best Regards,
Andy Shevchenko
