Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65209 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DXIoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 04:44:11 -0400
Received: by bkuw12 with SMTP id w12so210559bku.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 01:44:09 -0700 (PDT)
Message-ID: <4F96677C.40901@openwrt.org> (sfid-20120424_104418_748090_30907B83)
Date: Tue, 24 Apr 2012 10:42:36 +0200
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Jonathan Bither <jonbither@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath5k: add missing iounmap to AHB probe removal
References: <4F96647F.9060803@gmail.com>
In-Reply-To: <4F96647F.9060803@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonathan,

Le 04/24/12 10:29, Jonathan Bither a écrit :
> When our driver device is removed on the AHB bus, our IO memory is never unmapped.
>
> Signed-off-by: Jonathan Bither<jonbither@gmail.com>
>
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index 8c50d9d..eebf439 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -197,12 +197,14 @@ static int ath_ahb_remove(struct platform_device *pdev)
>   	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
>   	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
>   	struct ath5k_hw *ah;
> +	void __iomem *mem;
>   	u32 reg;
>
>   	if (!hw)
>   		return 0;
>
>   	ah = hw->priv;
> +	mem = ah->iobase;
>
>   	if (bcfg->devid>= AR5K_SREV_AR2315_R6) {
>   		/* Disable WMAC AHB arbitration */
> @@ -222,6 +224,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
>   	ath5k_deinit_ah(ah);
>   	platform_set_drvdata(pdev, NULL);
>   	ieee80211_free_hw(hw);
> +	iounmap(mem);

You don't need this temporary variable, just use iounmap(ah->iobase) 
after ath5k_deinit_ah(ah) just like how it is done in the PCI case.
--
Florian
