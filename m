Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55779 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2BIPQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 10:16:09 -0500
Received: by ggnh1 with SMTP id h1so884424ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 07:16:08 -0800 (PST)
Message-ID: <4F33E30D.8030407@lwfinger.net> (sfid-20120209_161613_747528_51CC291C)
Date: Thu, 09 Feb 2012 09:15:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simon Graham <simon.graham@virtualcomputer.com>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Subject: Re: [PATCH v3] rtlwifi: Modify rtl_pci_init to return 0 on success
References: <1328799314-28867-1-git-send-email-simon.graham@virtualcomputer.com>
In-Reply-To: <1328799314-28867-1-git-send-email-simon.graham@virtualcomputer.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 08:55 AM, Simon Graham wrote:
> Fixes problem where caller would think routine succeeded when it failed
> leading to divide by zero panic.
>
> Signed-off-by: Simon Graham<simon.graham@virtualcomputer.com>
> ---

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Simon: Congratulations - your mailer mangling problem seems to be fixed.

John: This is V3.3 and stable material. This bug goes back to at least 2.6.39.

Larry

>   drivers/net/wireless/rtlwifi/pci.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index fb84707..16ec0c1 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1495,7 +1495,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
>   		return err;
>   	}
>
> -	return 1;
> +	return 0;
>   }
>
>   static int rtl_pci_start(struct ieee80211_hw *hw)
> @@ -1866,7 +1866,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
>   	}
>
>   	/* Init PCI sw */
> -	err = !rtl_pci_init(hw, pdev);
> +	err = rtl_pci_init(hw, pdev);
>   	if (err) {
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Failed to init PCI\n");
>   		goto fail3;

