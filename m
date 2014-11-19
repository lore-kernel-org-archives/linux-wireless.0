Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5988 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbaKSUgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:36:32 -0500
Message-ID: <546CFF4D.7010306@broadcom.com> (sfid-20141119_213635_728990_94BD1558)
Date: Wed, 19 Nov 2014 21:36:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
References: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/14 21:18, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> This is a specific implementation,<asm/unaligned.h>  is the
> multiplexer that has the arch-specific knowledge of which
> of the implementations needs to be used, so include that.

Thanks, Johannes

Maybe it would be good to mention this was found by kbuild test robot.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> index b0ae7993e2e8..138691a1365a 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> @@ -19,10 +19,10 @@
>   #include<linux/pci.h>
>   #include<linux/vmalloc.h>
>   #include<linux/delay.h>
> -#include<linux/unaligned/access_ok.h>
>   #include<linux/interrupt.h>
>   #include<linux/bcma/bcma.h>
>   #include<linux/sched.h>
> +#include<asm/unaligned.h>
>
>   #include<soc.h>
>   #include<chipcommon.h>

