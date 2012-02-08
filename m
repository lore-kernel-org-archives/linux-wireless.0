Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2BHVIh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 16:08:37 -0500
Message-ID: <1328735392.2226.0.camel@dcbw.foobar.com> (sfid-20120208_220855_212114_8C3C24E1)
Subject: Re: [PATCH] iwlwifi: Return correct failure code on error
From: Dan Williams <dcbw@redhat.com>
To: Simon Graham <simon.graham@virtualcomputer.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Date: Wed, 08 Feb 2012 15:09:52 -0600
In-Reply-To: <20120208210509.GA1250@simgr-precise.oldroadcomputing.net>
References: <20120208210509.GA1250@simgr-precise.oldroadcomputing.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-08 at 16:05 -0500, Simon Graham wrote:
> Callers of rtl_pci_init expect zero to be returned on error. Returning
> the error code leads to, amongst other things, divide by zero panics
> attempting to use the ring size that was never set.

You probably want to resent with the subject:

[PATCH] rtlwifi: return correct failure code on error

instead of 'iwlwifi' which is the Intel wifi driver.

Dan

> ---
>  drivers/net/wireless/rtlwifi/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index fb84707..f0ce366 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1492,7 +1492,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
>  	if (err) {
>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>  			 "tx ring initialization failed\n");
> -		return err;
> +		return 0;
>  	}
>  
>  	return 1;


