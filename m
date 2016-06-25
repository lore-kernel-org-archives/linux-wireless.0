Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:41280 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751347AbcFYXcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 19:32:21 -0400
Message-ID: <1466897538.1847.72.camel@perches.com> (sfid-20160626_013224_215720_D000B9AF)
Subject: Re: [PATCH 10/10] rtlwifi: rtl8723ae: Clean up the hardware info
 routine
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Sat, 25 Jun 2016 16:32:18 -0700
In-Reply-To: <1466884421-722-11-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1466884421-722-11-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-06-25 at 14:53 -0500, Larry Finger wrote:
> This driver contains some complicated if ... else if ... else constructions.
> These are replaced by switch statements to improve readability.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
[]
> @@ -1656,113 +1656,117 @@ static void _rtl8723e_read_adapter_info(struct ieee80211_hw *hw,
>  	if (rtlhal->oem_id == RT_CID_DEFAULT) {

It'd look nicer too if this were changed to

	if (rtlhal->oem_id != RT_CID_DEFAULT)
		return;

[]
>  		switch (rtlefuse->eeprom_oemid) {
[]
> +				case 0x1028:
> +					switch (rtlefuse->eeprom_smid) {
> +					case 0x8194:
> +					case 0x8198:
> +					case 0x9197 ... 0x9198:
> +						rtlhal->oem_id =
> +							RT_CID_819X_DELL;

So these could be unindented and on a single line

