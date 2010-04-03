Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:60685 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0DCLzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 07:55:43 -0400
Received: by ewy20 with SMTP id 20so748277ewy.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 04:55:41 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH V4] rt2x00: remove MCU requests for SoC platforms
Date: Sat, 3 Apr 2010 13:55:38 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com> <t2qefe7343f1004030447i9d6f290fvd7dd317c63b5b61@mail.gmail.com> <l2mefe7343f1004030449refb18c80l3a81242338a8a4a7@mail.gmail.com>
In-Reply-To: <l2mefe7343f1004030449refb18c80l3a81242338a8a4a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004031355.38912.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 April 2010, Luis Correia wrote:
> The ralink SoC platforms do not have an MCU.
> 
> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> Removed flag usage as per Gertjan suggestion.
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index ce7e88e..1df2d44 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -60,6 +60,12 @@ static void rt2800pci_mcu_status(struct rt2x00_dev
> *rt2x00dev, const u8 token)
>        unsigned int i;
>        u32 reg;
> 
> +       /*
> +        * SOC devices don't support MCU requests.
> +        */
> +       if (rt2x00_is_soc(rt2x00dev))
> +               return;
> +
>        for (i = 0; i < 200; i++) {
>                rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
> 


