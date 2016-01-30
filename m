Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34328 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbcA3QTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 11:19:32 -0500
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1452949379-16052-1-git-send-email-baijiaju1990@163.com>
References: <1452949379-16052-1-git-send-email-baijiaju1990@163.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sat, 30 Jan 2016 17:19:12 +0100
Message-ID: <CAN8YU5O+DAzUZWtw5Rp8PTcA-O=H-JxwYrKghE_OFr+L4MA3RQ@mail.gmail.com> (sfid-20160130_171940_134244_729EABD1)
Subject: Re: [PATCH] rtl818x_pci: Disable pci device in error handling code
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Wu <flamingice@sourmilk.net>, kvalo@codeaurora.org,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Andrea Merello <andrea.merello@gmail.com>

On Sat, Jan 16, 2016 at 2:02 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
> When pci_request_regions in rtl8180_probe fails, pci_disable_device is not
> called to disable the device which is enabled by pci_enbale_device.
>
> This patch fixes the problem by adding a new lable in error handling code.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> index a43a16f..c76af5d 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> @@ -1736,7 +1736,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
>         if (err) {
>                 printk(KERN_ERR "%s (rtl8180): Cannot obtain PCI resources\n",
>                        pci_name(pdev));
> -               return err;
> +               goto err_disable_dev;
>         }
>
>         io_addr = pci_resource_start(pdev, 0);
> @@ -1938,6 +1938,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
>
>   err_free_reg:
>         pci_release_regions(pdev);
> +
> + err_disable_dev:
>         pci_disable_device(pdev);
>         return err;
>  }
> --
> 1.7.9.5
>
>
