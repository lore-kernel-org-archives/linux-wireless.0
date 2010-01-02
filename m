Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:48277 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0ABQst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:48:49 -0500
Received: by gxk3 with SMTP id 3so1659676gxk.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 08:48:48 -0800 (PST)
Message-ID: <4B3F78ED.4090101@lwfinger.net>
Date: Sat, 02 Jan 2010 10:48:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
References: <op.u5wyi5dd9lhzdc@linux-g0th.site>
In-Reply-To: <op.u5wyi5dd9lhzdc@linux-g0th.site>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2010 10:24 AM, Rafał Miłecki wrote:
> Finally I've possibility to test my Christmas-gift N-PHY :) b43 didn't
> really "notice" it, so I needed to write this little patch. Now b43 at
> least look for firmware for my card.
> 
> Does this patch look OK?
> 
> This time I post from Opera mail so I hope white-spaces will be fine.
> 
> From 9b3ea4f29b038f732aba737323e2f89b275ce1ab Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
> Date: Sat, 2 Jan 2010 16:58:16 +0100
> Subject: [PATCH] b43: Add new SSB's core id for BCM4328
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Following line shows my BCM4328 detected on SSB. We didn't include 0x0C
> rev.
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index 098dda1..3aa45b8 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
> +       SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 15),
>         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),

Your tabs have been converted to spaces.

Most of my patches are sent using the mail command; however, I can send them
with Thunderbird using the following steps:

(1) Prepare the mail message with the patch attached.

(2) Save the message and close the open copy.

(3) Go to the "Draft" folder and click on the entry.

(4) The attachment will be listed at the bottom. Highlight that test and copy
into the clipboard.

(5) Click the "Edit" button, paste the attachment text into the message, clear
the attachment entry, and send.

I'm not sure how far you have gotten with the code, but I have been working with
a new driver with version 5.10.56.46. There are a lot of changes from the
4.174... that was previously reverse-engineered.

To answer your question in a later E-mail. You do not need to conditionalize the
core revision entry. If the N PHY code is not turned on, the driver will get an
unsupported PHY message and fail later in an acceptable error.

Larry

