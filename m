Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57932 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZLWSTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 13:19:23 -0500
Received: by yxe17 with SMTP id 17so7004381yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 10:19:22 -0800 (PST)
Message-ID: <4B325F27.4020506@lwfinger.net>
Date: Wed, 23 Dec 2009 12:19:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH][resend with linux-wireless] b43: N-PHY: clean table init,
 	check PHY rev
References: <b170af450912230401l7a27b981o42cdbc96e5a16b57@mail.gmail.com>
In-Reply-To: <b170af450912230401l7a27b981o42cdbc96e5a16b57@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/2009 06:01 AM, Rafał Miłecki wrote:
> It's just compilation-tested as I don't own N-PHY device yet (should
> receive one for Christmas). Of course I enabled N-PHY in Kconfig.
> 
> I already sent this to bcm43xx-dev but didn't get any review. Michael
> told me to send it to you John and to linux-wireless. Is there anyone
> how could review/ack my patch?
> 
> 
> From 6800722c2fda0e302d7c759a5f2a993503b6581a Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com
> <mailto:zajec5@gmail.com>>
> Date: Tue, 22 Dec 2009 02:27:21 +0100
> Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Move table init to tables_nphy.c, detect newer PHY which use different init
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com <mailto:zajec5@gmail.com>>
> ---
> drivers/net/wireless/b43/phy_n.c       |   43 ++++------------------------
> drivers/net/wireless/b43/tables_nphy.c |   48
> ++++++++++++++++++++++++++++++++
> drivers/net/wireless/b43/tables_nphy.h |    4 ++-
> 3 files changed, 58 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_n.c
> b/drivers/net/wireless/b43/phy_n.c
> index 992318a..23cef71 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -197,44 +197,15 @@ void b43_nphy_radio_turn_off(struct b43_wldev *dev)
>     ~B43_NPHY_RFCTL_CMD_EN);
> }
> 
> -#define ntab_upload(dev, offset, data) do { \
> - unsigned int i; \
> - for (i = 0; i < (offset##_SIZE); i++) \
> - b43_ntab_write(dev, (offset) + i, (data)[i]); \
> - } while (0)
> -
> -/* Upload the N-PHY tables. */
> +/* Upload the N-PHY tables.
> + * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
> + */
> static void b43_nphy_tables_init(struct b43_wldev *dev)
> {
> - /* Static tables */
> - ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
> - ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
> - ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
> - ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
> - ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
> - ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
> - ntab_upload(dev, B43_NTAB_PILOTLT, b43_ntab_pilotlt);
> - ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
> - ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
> - ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
> - ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
> - ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
> - ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
> - ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
> -
> - /* Volatile tables */
> - ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
> - ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
> - ntab_upload(dev, B43_NTAB_C0_ESTPLT, b43_ntab_estimatepowerlt0);
> - ntab_upload(dev, B43_NTAB_C1_ESTPLT, b43_ntab_estimatepowerlt1);
> - ntab_upload(dev, B43_NTAB_C0_ADJPLT, b43_ntab_adjustpower0);
> - ntab_upload(dev, B43_NTAB_C1_ADJPLT, b43_ntab_adjustpower1);
> - ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
> - ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
> - ntab_upload(dev, B43_NTAB_C0_IQLT, b43_ntab_iqlt0);
> - ntab_upload(dev, B43_NTAB_C1_IQLT, b43_ntab_iqlt1);
> - ntab_upload(dev, B43_NTAB_C0_LOFEEDTH, b43_ntab_loftlt0);
> - ntab_upload(dev, B43_NTAB_C1_LOFEEDTH, b43_ntab_loftlt1);
> + if (dev->phy.rev < 3)
> + b43_nphy_rev0_1_2_table_init(dev);
> + else
> + b43_nphy_rev3plus_table_init(dev);
> }
> 
> static void b43_nphy_workarounds(struct b43_wldev *dev)
> diff --git a/drivers/net/wireless/b43/tables_nphy.c
> b/drivers/net/wireless/b43/tables_nphy.c
> index 4e23363..d709555 100644
> --- a/drivers/net/wireless/b43/tables_nphy.c
> +++ b/drivers/net/wireless/b43/tables_nphy.c
> @@ -2474,3 +2474,51 @@ void b43_ntab_write(struct b43_wldev *dev, u32
> offset, u32 value)
> /* Some compiletime assertions... */
> assert_ntab_array_sizes();
> }
> +
> +#define ntab_upload(dev, offset, data) do { \
> + unsigned int i; \
> + for (i = 0; i < (offset##_SIZE); i++) \
> + b43_ntab_write(dev, (offset) + i, (data)[i]); \
> + } while (0)
> +
> +void b43_nphy_rev0_1_2_table_init(struct b43_wldev *dev)
> +{
> + /* Static tables */
> + ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
> + ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
> + ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
> + ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
> + ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
> + ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
> + ntab_upload(dev, B43_NTAB_PILOTLT, b43_ntab_pilotlt);
> + ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
> + ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
> + ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
> + ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
> + ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
> + ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
> + ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
> +
> + /* Volatile tables */
> + ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
> + ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
> + ntab_upload(dev, B43_NTAB_C0_ESTPLT, b43_ntab_estimatepowerlt0);
> + ntab_upload(dev, B43_NTAB_C1_ESTPLT, b43_ntab_estimatepowerlt1);
> + ntab_upload(dev, B43_NTAB_C0_ADJPLT, b43_ntab_adjustpower0);
> + ntab_upload(dev, B43_NTAB_C1_ADJPLT, b43_ntab_adjustpower1);
> + ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
> + ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
> + ntab_upload(dev, B43_NTAB_C0_IQLT, b43_ntab_iqlt0);
> + ntab_upload(dev, B43_NTAB_C1_IQLT, b43_ntab_iqlt1);
> + ntab_upload(dev, B43_NTAB_C0_LOFEEDTH, b43_ntab_loftlt0);
> + ntab_upload(dev, B43_NTAB_C1_LOFEEDTH, b43_ntab_loftlt1);
> +}
> +
> +void b43_nphy_rev3plus_table_init(struct b43_wldev *dev)
> +{
> + /* Static tables */
> + //TODO
> +
> + /* Volatile tables */
> + //TODO
> +}
> diff --git a/drivers/net/wireless/b43/tables_nphy.h
> b/drivers/net/wireless/b43/tables_nphy.h
> index 4d498b0..f5c0c2d 100644
> --- a/drivers/net/wireless/b43/tables_nphy.h
> +++ b/drivers/net/wireless/b43/tables_nphy.h
> @@ -128,6 +128,9 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8
> channel);
> 
> void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);
> 
> +void b43_nphy_rev0_1_2_table_init(struct b43_wldev *dev);
> +void b43_nphy_rev3plus_table_init(struct b43_wldev *dev);
> +
> extern const u8 b43_ntab_adjustpower0[];
> extern const u8 b43_ntab_adjustpower1[];
> extern const u16 b43_ntab_bdi[];
> @@ -155,5 +158,4 @@ extern const u32 b43_ntab_tdi40a1[];
> extern const u32 b43_ntab_tdtrn[];
> extern const u32 b43_ntab_tmap[];
> 
> -
> #endif /* B43_TABLES_NPHY_H_ */

ACK for the relocation of the tables.

Larry
