Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61378 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXOc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 10:32:26 -0400
Received: by ieak13 with SMTP id k13so10976988iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 07:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20572.46476.617076.695309@gargle.gargle.HOWL>
References: <20572.46476.617076.695309@gargle.gargle.HOWL>
Date: Mon, 24 Sep 2012 07:32:25 -0700
Message-ID: <CAMcMvsizdUL-SvArOiVZCPcZyea45FVxynTfWHzgf0zQDE17iQ@mail.gmail.com> (sfid-20120924_163230_610502_0F0F1A8F)
Subject: Re: [PATCH] ath9k: Disable ASPM only for AR9285
From: Paul Stewart <pstew@chromium.org>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis Rodriguez <rodrigue@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2012 at 11:44 AM, Sujith Manoharan
<c_manoha@qualcomm.com> wrote:
> Currently, ASPM is disabled for all WLAN+BT combo chipsets
> when BTCOEX is enabled. This is incorrect since the workaround
> is required only for WB195, which is a AR9285+AR3011 combo
> solution. Fix this by checking for the HW version when enabling
> the workaround.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Tested-by: Paul Stewart <pstew@chromium.org>
> ---
>  drivers/net/wireless/ath/ath9k/pci.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index a8f6126..c0c5996 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -128,8 +128,9 @@ static void ath_pci_aspm_init(struct ath_common *common)
>         if (!parent)
>                 return;
>
> -       if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
> -               /* Bluetooth coexistance requires disabling ASPM. */
> +       if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
> +           (AR_SREV_9285(ah))) {
> +               /* Bluetooth coexistance requires disabling ASPM for AR9285. */
>                 pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
>                 aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
>                 pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
