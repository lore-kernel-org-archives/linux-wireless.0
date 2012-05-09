Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50404 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809Ab2EIJQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:16:11 -0400
Message-ID: <4FAA35CE.8070701@hauke-m.de> (sfid-20120509_111614_402636_07BD8F7F)
Date: Wed, 09 May 2012 11:15:58 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Il Han <corone.il.han@gmail.com>
CC: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: Remove an unused variable.
References: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com>
In-Reply-To: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 08:35 AM, Il Han wrote:
> The variable val is not used afterward.
> Remove the declaration and the assignment line of it.
> 
> Signed-off-by: Il Han <corone.il.han@gmail.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> index c93ea35..f79b526 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
> @@ -1141,7 +1141,6 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
>  void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
>  {
>  	struct bcma_device *cc;
> -	u32 val;
>  
>  	cc = ai_findcore(sih, CC_CORE_ID, 0);
>  
> @@ -1156,7 +1155,6 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
>  			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
>  				   CCTRL4331_EXTPA_EN);
>  	} else {
> -		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
>  		bcma_mask32(cc, CHIPCREGOFFS(chipcontrol),
>  			    ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5));
>  	}

Hi,

I send a patch to remove the hole function [0] as it is not referenced
in brcmsmac and a function doing the same thing is already in bcma.
I have no problem with this patch and I hope merging this should not be
hard.

Hauke

[0]: http://www.spinics.net/lists/linux-wireless/msg89364.html
