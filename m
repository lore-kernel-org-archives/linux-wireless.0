Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:1049 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbXBSLHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 06:07:32 -0500
Received: by nf-out-0910.google.com with SMTP id o25so2392481nfa
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2007 03:07:31 -0800 (PST)
Message-ID: <a32f33a40702190307x2861b654s6233a6b9858e8233@mail.gmail.com>
Date: Mon, 19 Feb 2007 12:07:30 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] rt2x00: fix memory corruption caused by eeprom buffer overflow
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <20070219024654.3480.9392.stgit@dl.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070219024654.3480.9392.stgit@dl.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi

> diff --git a/drivers/net/wireless/d80211/rt2x00/rt73usb.c b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> index be66e2f..6fa5a7e 100644
> --- a/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> @@ -2705,7 +2705,7 @@ static int rt73usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
>          * Allocate the eeprom memory, check the eeprom width
>          * and copy the entire eeprom into this allocated memory.
>          */
> -       rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
> +       rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL * sizeof(u16));
>         if (!rt2x00dev->eeprom)
>                 return -ENOMEM;

you might want to change this to EEPROM_SIZE * sizeof(u16). ;)

Ivo
