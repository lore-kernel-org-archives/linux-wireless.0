Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:41972 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3IJOeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:34:22 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so7321337obb.9
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:34:21 -0700 (PDT)
Message-ID: <522F2DEB.1090903@lwfinger.net> (sfid-20130910_163425_463998_5DB10A3D)
Date: Tue, 10 Sep 2013 09:34:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'John W. Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	'Chaoming Li' <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 02/12] wireless: rtlwifi: remove unnecessary pci_set_drvdata()
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com> <00b301ceae17$7f417480$7dc45d80$%han@samsung.com>
In-Reply-To: <00b301ceae17$7f417480$7dc45d80$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2013 06:18 AM, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 703f839..2b6d3e0 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -2009,7 +2009,6 @@ fail2:
>   fail1:
>   	if (hw)
>   		ieee80211_free_hw(hw);
> -	pci_set_drvdata(pdev, NULL);
>   	pci_disable_device(pdev);
>
>   	return err;
> @@ -2064,8 +2063,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
>
>   	rtl_pci_disable_aspm(hw);
>
> -	pci_set_drvdata(pdev, NULL);
> -
>   	ieee80211_free_hw(hw);
>   }
>   EXPORT_SYMBOL(rtl_pci_disconnect);
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

