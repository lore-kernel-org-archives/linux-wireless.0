Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:46207 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbdKFOWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 09:22:12 -0500
Subject: Re: [PATCH 1/3] rtlwifi: fix uninitialized rtlhal->last_suspend_sec
 time
To: Arnd Bergmann <arnd@arndb.de>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20171106135619.1248453-1-arnd@arndb.de>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4d1c53f8-924f-74c6-3524-d6c4887998a7@lwfinger.net> (sfid-20171106_152246_620613_A322DC93)
Date: Mon, 6 Nov 2017 08:22:10 -0600
MIME-Version: 1.0
In-Reply-To: <20171106135619.1248453-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2017 07:55 AM, Arnd Bergmann wrote:
> We set rtlhal->last_suspend_sec to an uninitialized stack variable,
> but unfortunately gcc never warned about this, I only found it
> while working on another patch. I opened a gcc bug for this.
> 
> Presumably the value of rtlhal->last_suspend_sec is not all that
> important, but it does get used, so we probably want the
> patch backported to stable kernels.
> 
> Cc: stable@vger.kernel.org
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82839
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

For all three of these patches:

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 60c82a5b51cd..20ffe856180e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -1373,6 +1373,7 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
>   
>   	ppsc->wakeup_reason = 0;
>   
> +	do_gettimeofday(&ts);
>   	rtlhal->last_suspend_sec = ts.tv_sec;
>   
>   	switch (fw_reason) {
> 
