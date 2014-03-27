Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56481 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaC0SaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 14:30:14 -0400
Date: Thu, 27 Mar 2014 14:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	stable@vger.kernel.org, Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH v2] rtlwifi: add MSI interrupts support
Message-ID: <20140327181513.GF31168@tuxdriver.com> (sfid-20140327_193024_960279_F35A6A40)
References: <1395660884-15042-1-git-send-email-adam.lee@canonical.com>
 <1395715732-9545-1-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395715732-9545-1-git-send-email-adam.lee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm confused -- is "rtlwifi: rtl8188ee: enable MSI interrupts support"
still wanted/needed?

John

On Tue, Mar 25, 2014 at 10:48:52AM +0800, Adam Lee wrote:
> Add MSI interrupts support, enable it when msi_support flag is true,
> also could fallback to pin-based interrupts mode if MSI mode fails.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>
> Cc: <stable@vger.kernel.org> [3.10+]
> ---
>  drivers/net/wireless/rtlwifi/pci.c | 65 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 63 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index f26f4ff..155d010 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1853,6 +1853,65 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
>  	return true;
>  }
>  
> +static int rtl_pci_intr_mode_msi(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
> +	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
> +	int ret;
> +
> +	ret = pci_enable_msi(rtlpci->pdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = request_irq(rtlpci->pdev->irq, &_rtl_pci_interrupt,
> +			  IRQF_SHARED, KBUILD_MODNAME, hw);
> +	if (ret < 0) {
> +		pci_disable_msi(rtlpci->pdev);
> +		return ret;
> +	}
> +
> +	rtlpci->using_msi = true;
> +
> +	RT_TRACE(rtlpriv, COMP_INIT|COMP_INTR, DBG_DMESG,
> +		 "MSI Interrupt Mode!\n");
> +	return 0;
> +}
> +
> +static int rtl_pci_intr_mode_legacy(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
> +	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
> +	int ret;
> +
> +	ret = request_irq(rtlpci->pdev->irq, &_rtl_pci_interrupt,
> +			  IRQF_SHARED, KBUILD_MODNAME, hw);
> +	if (ret < 0)
> +		return ret;
> +
> +	rtlpci->using_msi = false;
> +	RT_TRACE(rtlpriv, COMP_INIT|COMP_INTR, DBG_DMESG,
> +		 "Pin-based Interrupt Mode!\n");
> +	return 0;
> +}
> +
> +static int rtl_pci_intr_mode_decide(struct ieee80211_hw *hw)
> +{
> +	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
> +	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
> +	int ret;
> +
> +	if (rtlpci->msi_support) {
> +		ret = rtl_pci_intr_mode_msi(hw);
> +		if (ret < 0)
> +			ret = rtl_pci_intr_mode_legacy(hw);
> +	} else {
> +		ret = rtl_pci_intr_mode_legacy(hw);
> +	}
> +	return ret;
> +}
> +
>  int rtl_pci_probe(struct pci_dev *pdev,
>  			    const struct pci_device_id *id)
>  {
> @@ -1995,8 +2054,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
>  	}
>  
>  	rtlpci = rtl_pcidev(pcipriv);
> -	err = request_irq(rtlpci->pdev->irq, &_rtl_pci_interrupt,
> -			  IRQF_SHARED, KBUILD_MODNAME, hw);
> +	err = rtl_pci_intr_mode_decide(hw);
>  	if (err) {
>  		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
>  			 "%s: failed to register IRQ handler\n",
> @@ -2064,6 +2122,9 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
>  		rtlpci->irq_alloc = 0;
>  	}
>  
> +	if (rtlpci->using_msi)
> +		pci_disable_msi(rtlpci->pdev);
> +
>  	list_del(&rtlpriv->list);
>  	if (rtlpriv->io.pci_mem_start != 0) {
>  		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
> -- 
> 1.9.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
