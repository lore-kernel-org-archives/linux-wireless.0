Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44303 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbbBGRQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 12:16:48 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so18726926obb.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2015 09:16:47 -0800 (PST)
Message-ID: <54D6487D.1020607@lwfinger.net> (sfid-20150207_181651_111249_649EAB6E)
Date: Sat, 07 Feb 2015 11:16:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Leon Nardella <leon.nardella@gmail.com>,
	linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	kvalo@codeaurora.org
Subject: Re: [PATCH] * Add support for Philips (or NXP) PTA01 Wireless Adapter
References: <1423305971-8360-1-git-send-email-leon.nardella@gmail.com>
In-Reply-To: <1423305971-8360-1-git-send-email-leon.nardella@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2015 04:46 AM, Leon Nardella wrote:
> Signed-off-by: Leon Nardella <leon.nardella@gmail.com>
> ---
>   drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 8e7153b..10c02f5 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -40,6 +40,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
>   	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
>   	{ USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
>   	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
> +	{ USB_DEVICE(0x0471, 0x209e) }, /* Philips (or NXP) PTA01 */
>
>   	{ USB_DEVICE(0x0cf3, 0x7015),
>   	  .driver_info = AR9287_USB },  /* Atheros */

Leon,

Your patch is correct, but your subject and commit message needs a little work.

When I add a new USB ID for a driver, my subject usually includes the driver 
name followed by a colon, and the "Add new USB ID". In your case, that would be 
"[PATCH] ath9k_htc: Add new USB ID". Then in the commit message I include the 
make and model of the device, and some indication of why that device ID should 
be added. For example, was that ID found in a Windows driver? Finally, indicate 
that the patch has been tested. Such a statement should not be necessary, but 
recently there have been a number of patches submitted that have not been tested 
on real hardware.

Larry


