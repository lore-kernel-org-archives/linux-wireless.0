Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34006 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab0J0VxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 17:53:15 -0400
Received: by iwn10 with SMTP id 10so1449536iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 14:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B495C0D-66BE-4A48-ADC0-6F8C74FF70D9@mac.com>
References: <5B495C0D-66BE-4A48-ADC0-6F8C74FF70D9@mac.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 27 Oct 2010 23:52:53 +0200
Message-ID: <AANLkTik=warK2tk=YgDDdvsU28hQUGv_tLDqV8fADUkg@mail.gmail.com>
Subject: Re: sdio ids for wl12xx
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[taking LKML out and adding linux-wireless]

Hi Elvis,

On Wed, Oct 27, 2010 at 8:42 PM, Elvis Dowson <elvis.dowson@mac.com> wrote:
...
>                  I was wondering, don't you need the sdio_ids for TI WL12xx as follows?

No, it's already defined inside wl1271_sdio.c

>  Do you think the LSR TiWi SDIO ids would be different?

No - all 1271 devices have these numbers:

#define SDIO_VENDOR_ID_TI		0x0097
#define SDIO_DEVICE_ID_TI_WL1271	0x4076

>
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> +#define SDIO_VENDOR_ID_TI                              0x104c
> +#define SDIO_DEVICE_ID_TI_WL12xx               0x9066

Hmm. These looks like the 1251 numbers (check out wl1251_sdio.c).

Using wrong numbers can lead to not getting your probe function called.

But again let me ask you to just try Luca's tree + Beagle patches
first. It should work out of the box.

Regards,
Ohad.
