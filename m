Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35297 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2BIB7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 20:59:44 -0500
Received: by yenm8 with SMTP id m8so630705yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 17:59:43 -0800 (PST)
Message-ID: <4F33288C.5090905@lwfinger.net> (sfid-20120209_030009_946521_4CB8E0F9)
Date: Wed, 08 Feb 2012 19:59:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simon Graham <simon.graham@virtualcomputer.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH V2] rtlwifi: Return correct failure code on error
References: <20120208211436.GA1309@simgr-precise.oldroadcomputing.net>
In-Reply-To: <20120208211436.GA1309@simgr-precise.oldroadcomputing.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 03:14 PM, Simon Graham wrote:
> Callers of rtl_pci_init expect zero to be returned on error. Returning
> the error code leads to the data being used when it shouldn't causing,
> amongst other things, divide by zero panics attempting to use the
> ring size that is set to zero.
>
> Signed-off-by: Simon Graham<simon.graham@virtualcomputer.com>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index fb84707..f0ce366 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1492,7 +1492,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
>   	if (err) {
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>   			 "tx ring initialization failed\n");
> -		return err;
> +		return 0;
>   	}
>
>   	return 1;

You must have an extreme memory limitation to find all these problems.

As long as you are reworking this section, I would prefer you leave the "return 
err" as it is now, change the "return 1" to "return 0", and remove the not 
operator in "err = !rtl_pci_init(hw, pdev);" call of this routine. I just 
discovered it a few days ago, and it bothers me, but I've been too busy to 
submit a fix. In addition, these changes will convert rtl_pci_init() into a more 
normal routine that returns 0 if OK and non-zero on errors.

Larry
