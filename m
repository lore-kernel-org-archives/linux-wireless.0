Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2868 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1BNT7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 14:59:25 -0500
Message-ID: <4D598993.4020900@broadcom.com>
Date: Mon, 14 Feb 2011 20:59:15 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: s@fomichev.me, gregkh@suse.de
cc: linux-wireless@vger.kernel.org,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
References: <20110212150033.GA1941@sdf-MacBook>
In-Reply-To: <20110212150033.GA1941@sdf-MacBook>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

this patch is ok with me. For future patches, can you post to 
devel@linuxdriverproject.org since that is the main list for the 
brcm80211 driver ?

I will align yet unsubmitted patches having to do with firmware handling 
with your patch.

Thanks, Roland.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>

On 02/12/2011 04:00 PM, Stanislav Fomichev wrote:
> This causes an oops when the bcm43xx_hdr-0.fw binary is not found.
>
> Signed-off-by: Stanislav Fomichev<s@fomichev.me>
> ---
>   drivers/staging/brcm80211/sys/wl_mac80211.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
> index cd8392b..5faa521 100644
> --- a/drivers/staging/brcm80211/sys/wl_mac80211.c
> +++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
> @@ -1767,7 +1767,6 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
>   		if (status) {
>   			printf("%s: fail to load firmware %s\n",
>   				KBUILD_MODNAME, fw_name);
> -			wl_release_fw(wl);
>   			return status;
>   		}
>   		WL_NONE("request fw %s\n", fw_name);
> @@ -1777,7 +1776,6 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
>   		if (status) {
>   			printf("%s: fail to load firmware %s\n",
>   				KBUILD_MODNAME, fw_name);
> -			wl_release_fw(wl);
>   			return status;
>   		}
>   		wl->fw.hdr_num_entries[i] =


