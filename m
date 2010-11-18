Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59746 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab0KRPxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 10:53:15 -0500
Received: by ywg8 with SMTP id 8so1895945ywg.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 07:53:14 -0800 (PST)
Message-ID: <4CE54BE2.2070302@lwfinger.net>
Date: Thu, 18 Nov 2010 09:53:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/4] b43: N-PHY: fix values for PHY regs in channel tables
 of 2055 radio
References: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 06:27 AM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---

This change deserves a bit more explanation. You might include something like
"These tables came from reverse engineering the 5.10.56.46 version of the
Broadcom driver. Trace comparisons between b43 and the current Broadcom driver
(5.10.120.0) show byte reversals for the PHY register writes."

Larry

>  drivers/net/wireless/b43/radio_2055.c |  248 ++++++++++++++++----------------
>  1 files changed, 124 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/radio_2055.c b/drivers/net/wireless/b43/radio_2055.c
> index 0d67715..10910dc 100644
> --- a/drivers/net/wireless/b43/radio_2055.c
> +++ b/drivers/net/wireless/b43/radio_2055.c
> @@ -307,7 +307,7 @@ static const struct b43_nphy_channeltab_entry_rev2 b43_nphy_channeltab_rev2[] =
>  	RADIOREGS(0x71, 0x01, 0xEC, 0x0F, 0xFF, 0x01, 0x04, 0x0A,
>  		  0x00, 0x8F, 0xFF, 0xFF, 0xFF, 0x00, 0x0F, 0x0F,
>  		  0x8F, 0xFF, 0x00, 0x0F, 0x0F, 0x8F),
> -	PHYREGS(0xB407, 0xB007, 0xAC07, 0x1402, 0x1502, 0x1602),
> +	PHYREGS(0x07B4, 0x07B0, 0x07AC, 0x0214, 0x0215, 0x0216),
>    },
