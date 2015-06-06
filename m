Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36534 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbFFQSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 12:18:30 -0400
Received: by oihb142 with SMTP id b142so71103399oih.3
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 09:18:29 -0700 (PDT)
Message-ID: <55731D53.2020808@lwfinger.net> (sfid-20150606_181833_741904_C4B96D19)
Date: Sat, 06 Jun 2015 11:18:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192c: Add init codes for "fw_version" and
 "fw_subversion".
References: <1433588537-27853-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433588537-27853-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2015 06:02 AM, Taehee Yoo wrote:
> The variable "fw_version" is used in the _ResetDigitalProcedure1().
> but It is not initialized. so I add init codes for "fw_version" and
> "fw_subversion".
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> index 29983bc..9b5ce28 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> @@ -233,6 +233,8 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
>   	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
>   	pfwdata = (u8 *)rtlhal->pfirmware;
>   	fwsize = rtlhal->fwsize;
> +	rtlhal->fw_version = pfwheader->version;
> +	rtlhal->fw_subversion = pfwheader->subversion;
>
>   	if (IS_FW_HEADER_EXIST(pfwheader)) {
>   		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,

This patch is not correct. If the firmware does not have a header, then you will 
be changing fw_version and fw_subversion to random bytes from the body of the 
firmware. At present, they are initialized to zero as part of the rtl_priv 
struct. You need to move the two new statements inside the IS_FW_HEADER_EXIST 
test, but before pfwdata is adjusted to remove the header.

Larry


