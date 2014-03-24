Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54397 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCXGF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 02:05:29 -0400
Received: by mail-pa0-f52.google.com with SMTP id rd3so5014795pab.11
        for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2014 23:05:29 -0700 (PDT)
Date: Mon, 24 Mar 2014 14:05:21 +0800
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8188ee: enable MSI interrupts support
Message-ID: <20140324060512.GA3657@adam-laptop> (sfid-20140324_070533_311071_FE34628D)
References: <1395640841-14477-1-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395640841-14477-1-git-send-email-adam.lee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2014 at 02:00:41PM +0800, Adam Lee wrote:
> Some HP notebooks using this rtl8188ee hardware module can't get
> AP scan results with pin-based interrupts, enabling MSI interrupts could
> fix it.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>
> ---
>  drivers/net/wireless/rtlwifi/rtl8188ee/sw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> index 347af1e..1b4101b 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> @@ -93,6 +93,7 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
>  	u8 tid;
>  
>  	rtl8188ee_bt_reg_init(hw);
> +	rtlpci->msi_support = true;
>  
>  	rtlpriv->dm.dm_initialgain_enable = 1;
>  	rtlpriv->dm.dm_flag = 0;
> -- 
> 1.9.1

Cc: stable@vger.kernel.org

-- 
Adam Lee
