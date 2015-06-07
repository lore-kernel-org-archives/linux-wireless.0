Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36741 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbFGPFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 11:05:07 -0400
Received: by oihb142 with SMTP id b142so79376988oih.3
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 08:05:06 -0700 (PDT)
Message-ID: <55745D9E.60504@lwfinger.net> (sfid-20150607_170517_018999_065B7F7E)
Date: Sun, 07 Jun 2015 10:05:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtlwifi: rtl8192c: Add init codes for "fw_version"
 and "fw_subversion".
References: <1433684016-24340-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433684016-24340-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2015 08:33 AM, Taehee Yoo wrote:
> The variable "fw_version" is used in the _ResetDigitalProcedure1().
> but It is not initialized. so I add init codes for "fw_version" and
> "fw_subversion".
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---

V2 - Moved new statements into location where header is known to exist.

You should have something like this after the separator (---) in the commit 
message for any resubmission.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> index 29983bc..14b819e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> @@ -233,13 +233,14 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
>   	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
>   	pfwdata = (u8 *)rtlhal->pfirmware;
>   	fwsize = rtlhal->fwsize;
> -
>   	if (IS_FW_HEADER_EXIST(pfwheader)) {
>   		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
>   			 "Firmware Version(%d), Signature(%#x),Size(%d)\n",
>   			  pfwheader->version, pfwheader->signature,
>   			  (int)sizeof(struct rtl92c_firmware_header));
>
> +		rtlhal->fw_version = pfwheader->version;
> +		rtlhal->fw_subversion = pfwheader->subversion;
>   		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
>   		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
>   	}
>

