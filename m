Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3975 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1ECJKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:10:17 -0400
Message-ID: <4DBFC669.9020900@broadcom.com> (sfid-20110503_111021_656251_92DD346F)
Date: Tue, 3 May 2011 11:10:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "sukeshs@broadcom.com" <sukeshs@broadcom.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] brcm80211: Fix for suspend/resume bug
References: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
 <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
In-Reply-To: <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2011 09:00 AM, sukeshs@broadcom.com wrote:
> From: Sukesh Srikakula<sukeshs@xl-sj1-20.sj.broadcom.com>
>
> Currently, there are 2 callbacks registered with OS for getting notifications when system goes to suspend/resume.
> Racing between these 2 callbacks leads to failure in the suspend/resume path.
> With this fix, we avoid registering dhd callback for suspend/resume notification when cfg80211 is used. Relevant functionality in dhd suspend/resume callback function is moved to cfg80211 suspend/resume functions.
>
> Signed-off-by: Sukesh Srikakula<sukeshs@broadcom.com>
> Signed-off-by: Sukesh Srikakula<sukeshs@xl-sj1-20.sj.broadcom.com>
> ---
> diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
> index 99c38dd..41c55a6 100644
> --- a/drivers/staging/brcm80211/brcmfmac/dhd.h
> +++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
> @@ -123,6 +124,8 @@ typedef struct dhd_pub {
>
>   #if defined(CONFIG_PM_SLEEP)
>
> +extern volatile bool dhd_mmc_suspend;
> +

You probably should run checkpatch.pl on this patch. The volatile 
keyword triggers a warning here. I grepped the fullmac code and this 
variable is only set so what is its purpose (debugging?)? See 
Documentation/volatile-considered-harmful.txt on this topic.

Gr. AvS


