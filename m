Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33194 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbcDOPe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 11:34:56 -0400
Received: by mail-oi0-f67.google.com with SMTP id v67so14211245oie.0
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2016 08:34:56 -0700 (PDT)
Subject: Re: [PATCH v2] rtlwifi: rtl8821ae: Make sure loop counter is signed
 on all architectures
To: =?UTF-8?Q?David_M=c3=bcller?= <d.mueller@elsoft.ch>,
	linux-wireless@vger.kernel.org
References: <570FBA62.6080606@lwfinger.net>
 <1460703025-2177-1-git-send-email-d.mueller@elsoft.ch>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <57110A1E.3020801@lwfinger.net> (sfid-20160415_173500_009005_004F8829)
Date: Fri, 15 Apr 2016 10:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <1460703025-2177-1-git-send-email-d.mueller@elsoft.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/15/2016 01:50 AM, David Müller wrote:
> The for-loop condition does not work correctly on architectures where
> "char" is unsigned. Fix it by using an "int", which may also result in
> more efficient code.
>
> v2: Remove unneeded initialization.
>
> Signed-off-by: David Müller <d.mueller@elsoft.ch>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> index 74165b3..1abd243 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> @@ -959,7 +959,7 @@ static void _rtl8821ae_phy_store_txpower_by_rate_base(struct ieee80211_hw *hw)
>   static void _phy_convert_txpower_dbm_to_relative_value(u32 *data, u8 start,
>   						u8 end, u8 base_val)
>   {
> -	char i = 0;
> +	int i;
>   	u8 temp_value = 0;
>   	u32 temp_data = 0;

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry


