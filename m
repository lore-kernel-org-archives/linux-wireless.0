Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62700 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EGWa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 18:30:26 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so1172767wgh.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 15:30:24 -0700 (PDT)
References: <1367957010-9496-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1367957010-9496-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <86F5D1A2-7E2C-4EE5-9D29-C66306833C35@gmail.com> (sfid-20130508_003029_753938_7F1E96EE)
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3.10-rc] wireless: rt2x00: rt2800: fix hardware antenna diversity for RT5370G
Date: Wed, 8 May 2013 00:30:22 +0200
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xose,

Sent from my iPad

On 7 mei 2013, at 22:03, Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> RT5370G has hardware RX antenna diversity like RT5390R.
> 
> based on 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

I'll check this patch tomorrow, when I get back home.

In the meantime some style related comments below.

> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Tested-by: wnewbie72@gmail.com
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> drivers/net/wireless/rt2x00/rt2800.h    | 3 ++-
> drivers/net/wireless/rt2x00/rt2800lib.c | 8 +++++---
> 2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index a7630d5..6e84eee 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -89,7 +89,8 @@
> #define REV_RT3090E            0x0211
> #define REV_RT3390E            0x0211
> #define REV_RT5390F            0x0502
> -#define REV_RT5390R            0x1502
> +#define REV_RT5370G            0x0503 /* hardware RX antenna diversity */
> +#define REV_RT5390R            0x1502 /* hardware RX antenna diversity */
> #define REV_RT5592C            0x0221

Please don't the comments to the chipset revision definitions. These macros are usually used all over the place; there is no need to specify this here.

> 
> #define DEFAULT_RSSI_OFFSET        120
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index b52d70c..e202ec7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4311,8 +4311,9 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>            rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
>        }
> 
> -        /* This chip has hardware antenna diversity*/
> -        if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
> +        /* These chips have hardware RX antenna diversity */
> +        if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
> +            rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
>            rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
>            rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
>            rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */

With respect to the comment change: are you sure this is only about RX antenna diversity?

Also, I'm wondering if the change to the if condition brings us everything that is wanted. Checking the same chipset for different minimal revisions doesn't make a whole lot of sense to me.
Sure, you are fixing later RT5370 revisions here, but may be botching up early RT5390 revisions here at the same time

> @@ -5554,7 +5555,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        rt2x00dev->default_ant.rx = ANTENNA_A;
>    }
> 
> -    if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
> +    if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
> +        rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
>        rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
>        rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
>      }

The same comment on the if conditions apply here.

---
Gertjan