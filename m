Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:36764 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbcDNPm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 11:42:29 -0400
Received: by mail-ob0-f193.google.com with SMTP id rf6so5281921obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 08:42:28 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Make sure loop counter is signed on
 all architectures
To: =?UTF-8?Q?David_M=c3=bcller?= <d.mueller@elsoft.ch>,
	linux-wireless@vger.kernel.org
References: <1460638123-2913-1-git-send-email-d.mueller@elsoft.ch>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <570FBA62.6080606@lwfinger.net> (sfid-20160414_174245_516942_CA976833)
Date: Thu, 14 Apr 2016 10:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <1460638123-2913-1-git-send-email-d.mueller@elsoft.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/2016 07:48 AM, David Müller wrote:
> The for-loop condition does not work correctly on architectures where "char"
> is unsigned. Fix it by using an "int", which may also result in more
> efficient code.
>
> Signed-off-by: David Müller <d.mueller@elsoft.ch>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> index 74165b3..fcd84d1 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> @@ -959,7 +959,7 @@ static void _rtl8821ae_phy_store_txpower_by_rate_base(struct ieee80211_hw *hw)
>   static void _phy_convert_txpower_dbm_to_relative_value(u32 *data, u8 start,
>   						u8 end, u8 base_val)
>   {
> -	char i = 0;
> +	int i = 0;
>   	u8 temp_value = 0;
>   	u32 temp_data = 0;

This change is OK, but as long as you are touching this line, you should remove 
the initialization to zero. The first executable statement of that routine is 
"for (i = 3; i >= 0; --i)", thus there is no possibility that the variable could 
be used without being initialized.


Thanks,

Larry

