Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2215 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611Ab2EGULP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 16:11:15 -0400
Message-ID: <4FA82C53.5040005@broadcom.com> (sfid-20120507_221119_041911_7A2927B1)
Date: Mon, 7 May 2012 13:10:59 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Il Han" <corone.il.han@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: Initialize a variable before used.
References: <1336418632-16758-1-git-send-email-corone.il.han@gmail.com>
In-Reply-To: <1336418632-16758-1-git-send-email-corone.il.han@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Il. Removing the declaration and assignment line of val seems to 
be better since it's not used afterward. Do you want to send out a V2? 
Or I can do it.

Thanks,
Franky

On 05/07/2012 12:23 PM, Il Han wrote:
> The variable val is used uninitialized.
> It should be initialized before used.
> Initialize it.
>
> Signed-off-by: Il Han<corone.il.han@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> index c93ea35..d67c5c4 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> @@ -1141,7 +1141,7 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
>   void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
>   {
>   	struct bcma_device *cc;
> -	u32 val;
> +	u32 val = 0;
>
>   	cc = ai_findcore(sih, CC_CORE_ID, 0);
>


