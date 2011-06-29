Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1F2Nq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 09:46:58 -0400
Message-ID: <4E0B2CCE.1080805@lwfinger.net> (sfid-20110629_154703_891900_1A43C016)
Date: Wed, 29 Jun 2011 08:46:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:RTL8192CE WIRELES..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] rtlwifi: potential forever loop in rtl92de_hw_init()
References: <20110629063149.GE14591@shale.localdomain>
In-Reply-To: <20110629063149.GE14591@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 01:31 AM, Dan Carpenter wrote:
> "i" should be an int here because we are trying to use it to count
> to 10000.  The original code looks like it could hang in a forever
> loop.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
> ---
> If we exit the loop via a timeout, that error isn't handled.  Should
> we limp along, or return an error?

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Dan,

Thanks for this part. After another look at this routine, there are a couple of 
places that need to be fixed. I will take care of that.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> index eedfb38..cbc0f40 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> @@ -908,7 +908,8 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
>   	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
>   	bool rtstatus = true;
> -	u8 tmp_u1b, i;
> +	u8 tmp_u1b;
> +	int i;
>   	int err;
>   	unsigned long flags;
>
>

