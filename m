Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753776AbcJ3MAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 08:00:46 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: John Heenan <john@zgus.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine macpower
References: <cover.1477769750.git.john@zgus.com> <20161030102112.GA5789@cube>
Date: Sun, 30 Oct 2016 08:00:44 -0400
In-Reply-To: <20161030102112.GA5789@cube> (John Heenan's message of "Sun, 30
        Oct 2016 20:21:12 +1000")
Message-ID: <wrfjpomidp1v.fsf@redhat.com> (sfid-20161030_130050_865129_FF895AF2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Heenan <john@zgus.com> writes:
> Code tests show data returned by rtl8xxxu_read8(priv, REG_CR), used to set
> macpower, is never 0xea. It is only ever 0x01 (first time after modprobe)
> using wpa_supplicant and 0x00 thereafter using wpa_supplicant. These results
> occurs with 'Fix for authentication failure' [PATCH 1/2] in place.
>
> Whatever was returned, code tests always showed that at least
> rtl8xxxu_init_queue_reserved_page(priv);
> is always required. Not called if macpower set to true.
>
> Please see cover letter, [PATCH 0/2], for more information from tests.
>
> For rtl8xxxu-devel branch of git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>
> Signed-off-by: John Heenan <john@zgus.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index f25b4df..aae05f3 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -3904,6 +3904,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>  		macpower = false;
>  	else
>  		macpower = true;
> +	macpower = false; // Code testing shows macpower must always be set to false to avoid failure
>  
>  	ret = fops->power_on(priv);
>  	if (ret < 0) {

Sorry but this patch is neither serious nor acceptable. First of all,
hardcoding macpower like this right after an if statement is plain
wrong, second your comments violate all kernel rules.

Second, you argue this was tested using code test - on which device? Did
you test it on all rtl8xxxu based devices or just rtl8723bu?

NACK

Jes
