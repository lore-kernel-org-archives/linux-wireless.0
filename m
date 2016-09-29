Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35867 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755316AbcI2Qyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 12:54:49 -0400
Received: by mail-yw0-f179.google.com with SMTP id t67so52710359ywg.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 09:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475167183-18376-1-git-send-email-akarwar@marvell.com>
References: <1475167183-18376-1-git-send-email-akarwar@marvell.com>
From: Rajat Jain <rajatja@google.com>
Date: Thu, 29 Sep 2016 09:54:07 -0700
Message-ID: <CACK8Z6FpmLgdwEoN5Sg6VX691u3MAHKfg691gMpzPSsQtsAQJg@mail.gmail.com> (sfid-20160929_185453_662373_2DBD2EC8)
Subject: Re: [PATCH RESEND v3] mwifiex: parse device tree node for PCIe
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>,
        Brian Norris <briannorris@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+brian]

On Thu, Sep 29, 2016 at 9:39 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> This patch derives device tree node from pcie bus layer framework.
> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> marvell-8xxx.txt) to accomodate PCIe changes.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Included vendor and product IDs in compatible strings for PCIe
> chipsets(Rob Herring)
> v3: Patch is created using -M option so that it will only include diff of
> original and renamed files(Rob Herring)
> Resend v3: Resending the patch because I missed to include device tree mailing
> while sending v3.
> ---
>  .../{marvell-sd8xxx.txt => marvell-8xxx.txt}         |  8 +++++---
>  drivers/net/wireless/marvell/mwifiex/pcie.c          | 20 ++++++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c       |  3 ++-
>  3 files changed, 27 insertions(+), 4 deletions(-)
>  rename Documentation/devicetree/bindings/net/wireless/{marvell-sd8xxx.txt => marvell-8xxx.txt} (91%)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> similarity index 91%
> rename from Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> rename to Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> index c421aba..dfe5f8e 100644
> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> @@ -1,8 +1,8 @@
> -Marvell 8897/8997 (sd8897/sd8997) SDIO devices
> +Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
>  ------
>
> -This node provides properties for controlling the marvell sdio wireless device.
> -The node is expected to be specified as a child node to the SDIO controller that
> +This node provides properties for controlling the marvell sdio/pcie wireless device.
> +The node is expected to be specified as a child node to the SDIO/PCIE controller that
>  connects the device to the system.
>
>  Required properties:
> @@ -10,6 +10,8 @@ Required properties:
>    - compatible : should be one of the following:
>         * "marvell,sd8897"
>         * "marvell,sd8997"
> +       * "pci11ab,2b42"
> +       * "pci1b4b,2b42"
>
>  Optional properties:
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 063c707..f1eeb73 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -37,6 +37,23 @@ static struct mwifiex_if_ops pcie_ops;
>
>  static struct semaphore add_remove_card_sem;
>
> +static const struct of_device_id mwifiex_pcie_of_match_table[] = {
> +       { .compatible = "pci11ab,2b42" },
> +       { .compatible = "pci1b4b,2b42" },
> +       { }
> +};
> +
> +static int mwifiex_pcie_probe_of(struct device *dev)
> +{
> +       if (!dev->of_node ||
> +           !of_match_node(mwifiex_pcie_of_match_table, dev->of_node)) {
> +               pr_err("pcie device node not available");
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
>  static int
>  mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
>                        size_t size, int flags)
> @@ -206,6 +223,9 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
>                 card->pcie.can_ext_scan = data->can_ext_scan;
>         }
>
> +       /* device tree node parsing and platform specific configuration*/
> +       mwifiex_pcie_probe_of(&pdev->dev);
> +
>         if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
>                              MWIFIEX_PCIE)) {
>                 pr_err("%s failed\n", __func__);
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index 638d30a..f2a7a13 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -2218,7 +2218,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
>                  * The cal-data can be read from device tree and/or
>                  * a configuration file and downloaded to firmware.
>                  */
> -               if (priv->adapter->iface_type == MWIFIEX_SDIO &&
> +               if ((priv->adapter->iface_type == MWIFIEX_SDIO ||
> +                   priv->adapter->iface_type == MWIFIEX_PCIE) &&
>                     adapter->dev->of_node) {
>                         adapter->dt_node = adapter->dev->of_node;
>                         if (of_property_read_u32(adapter->dt_node,
> --
> 1.9.1
>
