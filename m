Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F70C072A2
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Nov 2023 22:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346259AbjKQWqk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Nov 2023 17:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjKQWqi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2023 17:46:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12FD4D;
        Fri, 17 Nov 2023 14:46:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC026C433C7;
        Fri, 17 Nov 2023 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700261195;
        bh=jvZx9m9nglfWaaFRVqvc9mf2Pw2zgfeJHkkEUGSzM5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OP7ggZV3e1eHOdammGbbyapb/pyiqw1oSKpUXJcDS/T/N1FM5VaV6Srk+YHe0p4X+
         UcIsatoflSS8cuF0pmXsD2wDLKQD28f++/e+HVANjQMnAYjVIpa1IfYVwt/0Pr/tTJ
         lHTJa3+E3tthayAbWMMQBCi9ufQloX1xh3fx8W7L0sH2DTxDpviVtfrc+oxjCxsOHT
         bz35BlfLuK6/Du67ptS2PS/jWkNJpU60ZDeGan6CPWMqeKEPA36SklfKGs9QUiTt9E
         Sut+JerBl8Kt8IsMPtUA/SNTIF2Y4A3AIoHkyniN+cqDh9mcQdaRVz6EkkaYv69aDx
         iw+n4kDTum/tw==
Date:   Fri, 17 Nov 2023 16:46:33 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] rtlwifi: rtl8821ae: Use pci_find_capability()
Message-ID: <20231117224633.GA96129@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231117094425.80477-6-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 17, 2023 at 11:44:23AM +0200, Ilpo Järvinen wrote:
> Instead of open coding the capability structure search, find the PM
> Capability using pci_find_capability().
>
> While at it, rename the generic 'cap_pointer' to 'pm_cap' which makes
> the intent of the code more obvious.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 49 +++----------------
>  1 file changed, 8 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 53cfeed0b030..7877509c34c7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -2270,42 +2270,11 @@ static void _rtl8821ae_clear_pci_pme_status(struct ieee80211_hw *hw)
>  {
>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>  	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> -	u16 cap_hdr;
> -	u8 cap_pointer;
> -	u8 cap_id = 0xff;
>  	u8 pmcs_reg;
> -	u8 cnt = 0;
> +	u8 pm_cap;
>  
> -	/* Get the Capability pointer first,
> -	 * the Capability Pointer is located at
> -	 * offset 0x34 from the Function Header */
> -
> -	pci_read_config_byte(rtlpci->pdev, 0x34, &cap_pointer);
> -	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
> -		"PCI configuration 0x34 = 0x%2x\n", cap_pointer);
> -
> -	do {
> -		pci_read_config_word(rtlpci->pdev, cap_pointer, &cap_hdr);
> -		cap_id = cap_hdr & 0xFF;
> -
> -		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
> -			"in pci configuration, cap_pointer%x = %x\n",
> -			cap_pointer, cap_id);
> -
> -		if (cap_id == 0x01) {
> -			break;
> -		} else {
> -			/* point to next Capability */
> -			cap_pointer = (cap_hdr >> 8) & 0xFF;
> -			/* 0: end of pci capability, 0xff: invalid value */
> -			if (cap_pointer == 0x00 || cap_pointer == 0xff) {
> -				cap_id = 0xff;
> -				break;
> -			}
> -		}
> -	} while (cnt++ < 200);
> -
> -	if (cap_id != 0x01) {
> +	pm_cap = pci_find_capability(rtlpci->pdev, PCI_CAP_ID_PM);

Hahaha, good work.

> +	if (!pm_cap) {
>  		rtl_dbg(rtlpriv, COMP_INIT, DBG_WARNING,
>  			"Cannot find PME Capability\n");
>  		return;
> @@ -2314,22 +2283,20 @@ static void _rtl8821ae_clear_pci_pme_status(struct ieee80211_hw *hw)
>  	/* Get the PM CSR (Control/Status Register),
>  	 * The PME_Status is located at PM Capatibility offset 5, bit 7

Same comment typo and PCI_PM_CTRL, PCI_PM_CTRL_PME_STATUS comments as
before.

> -	pci_read_config_byte(rtlpci->pdev, cap_pointer + 5, &pmcs_reg);
> +	pci_read_config_byte(rtlpci->pdev, pm_cap + 5, &pmcs_reg);
>  
>  	if (pmcs_reg & BIT(7)) {
>  		/* Clear PME_Status with write */
> -		pci_write_config_byte(rtlpci->pdev, cap_pointer + 5,
> -				      pmcs_reg);
> +		pci_write_config_byte(rtlpci->pdev, pm_cap + 5, pmcs_reg);
>  		/* Read it back to check */
> -		pci_read_config_byte(rtlpci->pdev, cap_pointer + 5,
> -				     &pmcs_reg);
> +		pci_read_config_byte(rtlpci->pdev, pm_cap + 5, &pmcs_reg);
>  		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
>  			"Clear PME status 0x%2x to 0x%2x\n",
> -			cap_pointer + 5, pmcs_reg);
> +			pm_cap + 5, pmcs_reg);
>  	} else {
>  		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
>  			"PME status(0x%2x) = 0x%2x\n",
> -			cap_pointer + 5, pmcs_reg);
> +			pm_cap + 5, pmcs_reg);
>  	}
>  }
>  
> -- 
> 2.30.2
> 
