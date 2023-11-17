Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C744EC072A2
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Nov 2023 22:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345242AbjKQWoO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Nov 2023 17:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjKQWoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2023 17:44:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D564D4D;
        Fri, 17 Nov 2023 14:44:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7173FC433C7;
        Fri, 17 Nov 2023 22:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700261049;
        bh=8Og6bgpm0It7LiI9h/gWoTQq7vfHVz072Lej1JcW6rQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ephRg3pfyUT9CuaxOkzUcFZ/G4V8OTEodoUW16UEe77voRgLD9ggHTBm2rCVk0Fsi
         oZN3uTM78B22quVcG43vNISJjULYO20xUDgRXWE3bRKCXjrka7Ppckjbq5uGVJMWhK
         qTJpvaHmt4ao8mvknVqELTZT2Qo+M0U3qCrSzLu04VGhvATPyDN921183xIUsmIz+u
         UNvxerfWjAi0T9lIxTXES+mhcxnGhKC6tPz+I1c5YwMSxSuqqJfv9VTo8MQ0BWyYIR
         94CxLNbHrb4lqo0DCC132grkJkUvYwmjaGxd8jOCheRgaWL53vMmQvFkEJeS97HzK9
         H5I3wBaFjuHOA==
Date:   Fri, 17 Nov 2023 16:44:07 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] rtlwifi: rtl8821ae: Reverse PM capability exists
 check
Message-ID: <20231117224407.GA95935@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231117094425.80477-5-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 17, 2023 at 11:44:22AM +0200, Ilpo Järvinen wrote:
> Check if PM capability does not exists and return early which follows
> the usual error handling pattern.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 45 ++++++++++---------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 6ae37d61a2a2..53cfeed0b030 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -2305,30 +2305,31 @@ static void _rtl8821ae_clear_pci_pme_status(struct ieee80211_hw *hw)
>  		}
>  	} while (cnt++ < 200);
>  
> -	if (cap_id == 0x01) {
> -		/* Get the PM CSR (Control/Status Register),
> -		 * The PME_Status is located at PM Capatibility offset 5, bit 7
> -		 */
> -		pci_read_config_byte(rtlpci->pdev, cap_pointer + 5, &pmcs_reg);
> -
> -		if (pmcs_reg & BIT(7)) {
> -			/* Clear PME_Status with write */
> -			pci_write_config_byte(rtlpci->pdev, cap_pointer + 5,
> -					      pmcs_reg);
> -			/* Read it back to check */
> -			pci_read_config_byte(rtlpci->pdev, cap_pointer + 5,
> -					     &pmcs_reg);
> -			rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
> -				"Clear PME status 0x%2x to 0x%2x\n",
> -				cap_pointer + 5, pmcs_reg);
> -		} else {
> -			rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
> -				"PME status(0x%2x) = 0x%2x\n",
> -				cap_pointer + 5, pmcs_reg);
> -		}
> -	} else {
> +	if (cap_id != 0x01) {
>  		rtl_dbg(rtlpriv, COMP_INIT, DBG_WARNING,
>  			"Cannot find PME Capability\n");
> +		return;
> +	}
> +
> +	/* Get the PM CSR (Control/Status Register),
> +	 * The PME_Status is located at PM Capatibility offset 5, bit 7

s/Capatibility/Capability/

But this is PCI_PM_CTRL and PCI_PM_CTRL_PME_STATUS (with a word read),
right?  No need for a comment then.

I don't know why the driver needs to do this, but I'm skeptical.  The
only other drivers that look at PCI_PM_CTRL_PME_STATUS themselves are
bnx2x and ksz884xp (ksz884x.c), so this is highly suspicious.

> +	 */
> +	pci_read_config_byte(rtlpci->pdev, cap_pointer + 5, &pmcs_reg);
> +
> +	if (pmcs_reg & BIT(7)) {
> +		/* Clear PME_Status with write */
> +		pci_write_config_byte(rtlpci->pdev, cap_pointer + 5,
> +				      pmcs_reg);
> +		/* Read it back to check */
> +		pci_read_config_byte(rtlpci->pdev, cap_pointer + 5,
> +				     &pmcs_reg);
> +		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
> +			"Clear PME status 0x%2x to 0x%2x\n",
> +			cap_pointer + 5, pmcs_reg);
> +	} else {
> +		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
> +			"PME status(0x%2x) = 0x%2x\n",
> +			cap_pointer + 5, pmcs_reg);
>  	}
>  }
>  
> -- 
> 2.30.2
> 
