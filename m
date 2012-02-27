Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38512 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2B0P6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:58:24 -0500
Received: by iazz13 with SMTP id z13so3410869iaz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:58:23 -0800 (PST)
Message-ID: <4F4BA81D.1070800@lwfinger.net> (sfid-20120227_165827_944423_CFC68FFD)
Date: Mon, 27 Feb 2012 09:58:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Martin Krause <martin.krause@tqs.de>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] Staging: rtl8712: Change double device ID back to original
 value
References: <20120227102857.21246.43090.stgit@localhost.localdomain>
In-Reply-To: <20120227102857.21246.43090.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2012 04:29 AM, Martin Krause wrote:
> In the rtl8712 staging driver the 0bda:8172 usb device id exists two times.
> It seems that this was an error when integrating the original Realtek
> driver into the kernel. This patch changes the double device id back to the
> value used in the last Realtek driver
> (rtl8712_8188_8191_8192SU_usb_linux_v2.6.6.0.20110401).
>
> Signed-off-by: Martin Krause<martin.krause@tqs.de>
> ---
> I tested this patch on a powerpc board (p2020 based) with a WIFIHU Radicom
> wireless module with a RTL8191SU chip on it (usb device id 0bda:8192).
>
>   drivers/staging/rtl8712/usb_intf.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Your patch does two things. One is the deletion of a duplicate USB ID, and the 
other is the addition of a new one. I would prefer that any patch do one or the 
other, but not both. Note, there are two sets of duplicate IDs in the table for 
the driver - the one you note in the RTL8191SU section, and another for 
0bda:8174 in the section that covers the RTL8192SU.

I think you are deleting the wrong 0bda:8172 with this patch. The 0bda code is 
for Realtek, thus the one in the Asus section is the one to remove.

Does your chip really have an RTL8191SU label? The USB database says that ID 
0bda:8192 is for the RTL8192SU. I would like to correct the database if it is wrong.

All patches to a staging driver go through the staging tree, not wireless. Send 
them to Greg Kroah-Hartman (gregkh@linuxfoundation.org) rather than John 
Linville. A Cc to linux-wireless is OK, but you should also reference the driver 
development list (devel@driverdev.osuosl.org).

Larry

>
> diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
> index 9bade18..bb247ce 100644
> --- a/drivers/staging/rtl8712/usb_intf.c
> +++ b/drivers/staging/rtl8712/usb_intf.c
> @@ -104,7 +104,7 @@ static struct usb_device_id rtl871x_usb_id_tbl[] = {
>
>   /* RTL8191SU */
>   	/* Realtek */
> -	{USB_DEVICE(0x0BDA, 0x8172)},
> +	{USB_DEVICE(0x0BDA, 0x8192)},
>   	/* Amigo */
>   	{USB_DEVICE(0x0EB0, 0x9061)},
>   	/* ASUS/EKB */
>
>

