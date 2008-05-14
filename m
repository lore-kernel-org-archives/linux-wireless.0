Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2580 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYENUUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 16:20:39 -0400
Date: Wed, 14 May 2008 16:09:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Alessandro Di Marco <dmr@c0nc3pt.com>
Subject: Re: [PATCH] Rtl8180 max2820 ch14
Message-ID: <20080514200927.GC15712@tuxdriver.com> (sfid-20080514_222059_999030_08D4C410)
References: <c68f135e0805100432n5d90e9d1p26d2bd35ac99f994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68f135e0805100432n5d90e9d1p26d2bd35ac99f994@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 01:32:34PM +0200, Andrea Merello wrote:
> Rtl8180: fix wrong parameter in RF code function invokation for maxim radio
> 
> The max2820 RF code needs to invoke max2820_write_phy_antenna every time the
> channel is being switch.
> 
> This should be done passing the channel number to that function.
> Incorrectly we were passing the same value that is written on the
> channel RF register.
> This may cause problems when operating on ch 14.
> 
> This patch fixes it.
> 
> Thanks to Alessandro Di Marco who found this issue!
> 
> 
> signed-off-by: Andrea Merello <andreamrl@tiscali.it>
> ---
> 
> --- a/drivers/net/wireless/rtl8180_max2820.c    2008-02-02
> 14:48:52.000000000 +0100
> +++ b/drivers/net/wireless/rtl8180_max2820.c    2008-02-02
> 14:55:29.000000000 +0100
> @@ -86,7 +86,7 @@ static void max2820_rf_set_channel(struc
>          * sa2400, for MAXIM we do this directly from BB */
>         rtl8180_write_phy(dev, 3, txpw);
> 
> -       max2820_write_phy_antenna(dev, chan);
> +       max2820_write_phy_antenna(dev, chan_idx + 1);
>         write_max2820(dev, 3, chan);
>  }

This one didn't trigger any warnings, but it was whitespace damaged.
I'll hold-off on applying this one since I presume you will be
resubmitting the other patches.  I'll apply them all at once then.

John
-- 
John W. Linville
linville@tuxdriver.com
