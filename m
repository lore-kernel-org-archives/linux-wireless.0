Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36366 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbHGQeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 12:34:01 -0400
Received: by obnw1 with SMTP id w1so82675563obn.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2015 09:34:00 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8723be: disable FW control power save
To: AceLan Kao <acelan.kao@canonical.com>,
	linux-wireless@vger.kernel.org
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55C4DDF5.6010901@lwfinger.net> (sfid-20150807_183406_025213_C76731ED)
Date: Fri, 7 Aug 2015 11:33:57 -0500
MIME-Version: 1.0
In-Reply-To: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2015 10:11 PM, AceLan Kao wrote:
> There are many rtl8723be wifi unstable issues that wifi lost connection
> after working for a while. The wifi signal and status it's show connected
> also ifconfig have IP but can not connect to internet and filed to ping 8.8.8.8
> The problem should result from the power saving controlled by firmware.
> I'd suggest to disable it by default and re-enable it after firmware fixes
> this issue.
>
> BTW. the firmware I tested from linux-firmware git tree is
> rtlwifi/rtl8723befw.bin
> be225d6 Update firmware for rtl8723be
>
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>

NACK for this patch. If you were to make this change, you should also change the 
text in the MODULE_PARM_DESC() for this parameter. It shows a hard-coded default.

I am not sure this is a firmware problem as some users report that they need to 
run with the "ips=0" option, not with "fwlps=0" as your patch would force. 
Conversely, the driver works fine as is with other AP/environment combinations.

The Realtek engineer has told me that he is aware of problems with the dynamic 
management for all the drivers, and that they are working on major replacements; 
however, there is no timetable for the new code.

If we make a change in the default power settings, I would prefer changing 
inactiveps and its MODULE_PARM_DESC() text; however, that would have a negative 
impact on power usage on the host.

I have BCc'd the Realtek engineer and I hope to get his comments on this change.

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8723be/sw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
> index 1017f02..02fe2cc 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
> @@ -266,7 +266,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
>   	.sw_crypto = false,
>   	.inactiveps = true,
>   	.swctrl_lps = false,
> -	.fwctrl_lps = true,
> +	.fwctrl_lps = false,
>   };
>
>   static struct rtl_hal_cfg rtl8723be_hal_cfg = {
>

