Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33505 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdCaWu2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 18:50:28 -0400
Received: by mail-pg0-f42.google.com with SMTP id x125so83293260pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 15:50:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com> <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
From: Dmitry Torokhov <dtor@google.com>
Date: Fri, 31 Mar 2017 15:50:27 -0700
Message-ID: <CAE_wzQ-6irwa5_HeQuRk3kOcLBrYR9N9XNFPg_xx7tmWcHdgGA@mail.gmail.com> (sfid-20170401_005031_853840_5698375E)
Subject: Re: [PATCH 3/3] mwifiex: pcie: avoid hardcode wifi-only firmware name
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Rajat Jain <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 30, 2017 at 2:19 AM, Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> Wifi-only firmware name should be chipset specific.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 8 +++++++-
>  drivers/net/wireless/marvell/mwifiex/pcie.h | 6 ++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 59cb01a..282aa9a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -351,6 +351,12 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
>         struct pcie_service_card *card = pci_get_drvdata(pdev);
>         struct mwifiex_adapter *adapter = card->adapter;
>
> +       if (!card->pcie.flr_support) {
> +               pr_err("%s: FLR disabled in current chipset\n", __func__);
> +               return;
> +       }
> +
> +       adapter = card->adapter;
>         if (!adapter) {
>                 dev_err(&pdev->dev, "%s: adapter structure is not valid\n",
>                         __func__);
> @@ -3047,7 +3053,7 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
>          * during pcie FLR, so that bluetooth part of firmware which is
>          * already running doesn't get affected.
>          */
> -       strcpy(adapter->fw_name, PCIE8997_DEFAULT_WIFIFW_NAME);
> +       strcpy(adapter->fw_name, card->pcie.wifi_fw_name);
>
>         /* tx_buf_size might be changed to 3584 by firmware during
>          * data transfer, we should reset it to default size.
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
> index 00e8ee5..d6c8526 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.h
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
> @@ -285,6 +285,8 @@ struct mwifiex_pcie_device {
>         struct memory_type_mapping *mem_type_mapping_tbl;
>         u8 num_mem_types;
>         bool can_ext_scan;
> +       u8 flr_support;

This sounds like a boolean, but given that you can key off
wifi_fw_name being NULL I am not sure it is needed.

> +       char *wifi_fw_name;

const char *.

That said, I consider the whole wifi-only firmware business is quite
fragile. Can we have unified firmware and have driver figure out what
part shoudl be [re]loaded?

>  };
>
>  static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
> @@ -293,6 +295,7 @@ struct mwifiex_pcie_device {
>         .tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
>         .can_dump_fw = false,
>         .can_ext_scan = true,
> +       .flr_support = 0,
>  };
>
>  static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
> @@ -303,6 +306,7 @@ struct mwifiex_pcie_device {
>         .mem_type_mapping_tbl = mem_type_mapping_tbl_w8897,
>         .num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8897),
>         .can_ext_scan = true,
> +       .flr_support = 0,
>  };
>
>  static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
> @@ -313,6 +317,8 @@ struct mwifiex_pcie_device {
>         .mem_type_mapping_tbl = mem_type_mapping_tbl_w8997,
>         .num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8997),
>         .can_ext_scan = true,
> +       .flr_support = 1,
> +       .wifi_fw_name = "mrvl/pcie8997_wlan_v4.bin",
>  };
>
>  struct mwifiex_evt_buf_desc {
> --
> 1.8.1.4
>

Thanks.

-- 
Dmitry
