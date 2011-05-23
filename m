Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39558 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1EWTpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 15:45:35 -0400
Received: by vws1 with SMTP id 1so4384188vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 12:45:34 -0700 (PDT)
Message-ID: <4DDAB957.2030904@lwfinger.net> (sfid-20110523_214539_186318_D42FFEF8)
Date: Mon, 23 May 2011 14:45:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] rtlwifi: Synchronize IRQ after disabling it
References: <4DDA66E3.8030207@ring3k.org>
In-Reply-To: <4DDA66E3.8030207@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 08:53 AM, Mike McCormack wrote:
> This make sure any IRQ handlers running on other CPUs complete.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> index 4a56138..87b8a79 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> @@ -1196,6 +1196,7 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
>   	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
>   	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
>   	rtlpci->irq_enabled = false;
> +	synchronize_irq(rtlpci->pdev->irq);
>   }
>
>   static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

There is a similar construct in rtl8192se, but I will submit that patch.

Larry
