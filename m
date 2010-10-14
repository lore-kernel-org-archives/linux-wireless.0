Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35420 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0JNWjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:39:55 -0400
Received: by qyk2 with SMTP id 2so21675qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:39:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287090064-14607-1-git-send-email-zajec5@gmail.com>
References: <1287090064-14607-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 15 Oct 2010 00:39:34 +0200
Message-ID: <AANLkTimnzeRa53g0i2ZkB4Qy_x_P3h4Z+ZwC2HdJPxFC@mail.gmail.com>
Subject: Re: [PATCH 1/3] b43: N-PHY: define channel table struct for rev3+ devices
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/14 Rafał Miłecki <zajec5@gmail.com>:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/radio_2056.c |   51 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/b43/radio_2056.h |   40 ++++++++++++++++++++++++--
>  2 files changed, 88 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
> index d856319..f710c01 100644
> --- a/drivers/net/wireless/b43/radio_2056.c
> +++ b/drivers/net/wireless/b43/radio_2056.c
> @@ -24,9 +24,60 @@
>  #include "radio_2056.h"
>  #include "phy_common.h"
>
> +#define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
> +                  r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
> +                  r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, \
> +                  r30, r31, r32, r33, r34, r35, r36) \
> +       .radio_syn_pll_vcocal1          = r00,  \
> +       .radio_syn_pll_vcocal2          = r01,  \
> +       .radio_syn_pll_refdiv           = r02,  \
> +       .radio_syn_pll_mmd2             = r03,  \
> +       .radio_syn_pll_mmd1             = r04,  \
> +       .radio_syn_pll_loopfilter1      = r05,  \
> +       .radio_syn_pll_loopfilter2      = r06,  \
> +       .radio_syn_pll_loopfilter3      = r07,  \
> +       .radio_syn_pll_loopfilter4      = r08,  \
> +       .radio_syn_pll_loopfilter5      = r09,  \
> +       .radio_syn_reserved_addr27      = r10,  \
> +       .radio_syn_reserved_addr28      = r11,  \
> +       .radio_syn_reserved_addr29      = r12,  \
> +       .radio_syn_logen_vcobuf1        = r13,  \
> +       .radio_syn_logen_mixer2         = r14,  \
> +       .radio_syn_logen_buf3           = r15,  \
> +       .radio_syn_logen_buf4           = r16,  \
> +       .radio_rx0_lnaa_tune            = r17,  \
> +       .radio_rx0_lnag_tune            = r18,  \
> +       .radio_tx0_intpaa_boost_tune    = r19,  \
> +       .radio_tx0_intpag_boost_tune    = r20,  \
> +       .radio_tx0_pada_boost_tune      = r21,  \
> +       .radio_tx0_padg_boost_tune      = r22,  \
> +       .radio_tx0_pgaa_boost_tune      = r23,  \
> +       .radio_tx0_pgag_boost_tune      = r24,  \
> +       .radio_tx0_mixa_boost_tune      = r25,  \
> +       .radio_tx0_mixg_boost_tune      = r26,  \
> +       .radio_rx1_lnaa_tune            = r27,  \
> +       .radio_rx1_lnag_tune            = r28,  \
> +       .radio_tx1_intpaa_boost_tune    = r29,  \
> +       .radio_tx1_intpag_boost_tune    = r30,  \
> +       .radio_tx1_pada_boost_tune      = r31,  \
> +       .radio_tx1_padg_boost_tune      = r32,  \
> +       .radio_tx1_pgaa_boost_tune      = r33,  \
> +       .radio_tx1_pgag_boost_tune      = r34,  \
> +       .radio_tx1_mixa_boost_tune      = r35,  \
> +       .radio_tx1_mixg_boost_tune      = r36

You might want to use parentheses around parameter names: e.g.:
.radio_tx1_mixa_boost_tune = (r35), \

> +
> +#define PHYREGS(r0, r1, r2, r3, r4, r5)        \
> +       .phy_regs.phy_bw1a      = r0,   \
> +       .phy_regs.phy_bw2       = r1,   \
> +       .phy_regs.phy_bw3       = r2,   \
> +       .phy_regs.phy_bw4       = r3,   \
> +       .phy_regs.phy_bw5       = r4,   \
> +       .phy_regs.phy_bw6       = r5
> +
>  static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] = {
>  };
>
> +/* TODO: add support for rev4+ devices by searching in rev4+ tables */
>  const struct b43_nphy_channeltab_entry_rev3 *
>  b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
>  {
> diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
> index fda6daf..60341d7 100644
> --- a/drivers/net/wireless/b43/radio_2056.h
> +++ b/drivers/net/wireless/b43/radio_2056.h
> @@ -29,12 +29,46 @@
>  #include "tables_nphy.h"
>
>  struct b43_nphy_channeltab_entry_rev3 {
> -       /* The channel number */
> -       u8 channel;
>        /* The channel frequency in MHz */
>        u16 freq;
>        /* Radio register values on channelswitch */
> -       /* TODO */
> +       u8 radio_syn_pll_vcocal1;
> +       u8 radio_syn_pll_vcocal2;
> +       u8 radio_syn_pll_refdiv;
> +       u8 radio_syn_pll_mmd2;
> +       u8 radio_syn_pll_mmd1;
> +       u8 radio_syn_pll_loopfilter1;
> +       u8 radio_syn_pll_loopfilter2;
> +       u8 radio_syn_pll_loopfilter3;
> +       u8 radio_syn_pll_loopfilter4;
> +       u8 radio_syn_pll_loopfilter5;
> +       u8 radio_syn_reserved_addr27;
> +       u8 radio_syn_reserved_addr28;
> +       u8 radio_syn_reserved_addr29;
> +       u8 radio_syn_logen_vcobuf1;
> +       u8 radio_syn_logen_mixer2;
> +       u8 radio_syn_logen_buf3;
> +       u8 radio_syn_logen_buf4;
> +       u8 radio_rx0_lnaa_tune;
> +       u8 radio_rx0_lnag_tune;
> +       u8 radio_tx0_intpaa_boost_tune;
> +       u8 radio_tx0_intpag_boost_tune;
> +       u8 radio_tx0_pada_boost_tune;
> +       u8 radio_tx0_padg_boost_tune;
> +       u8 radio_tx0_pgaa_boost_tune;
> +       u8 radio_tx0_pgag_boost_tune;
> +       u8 radio_tx0_mixa_boost_tune;
> +       u8 radio_tx0_mixg_boost_tune;
> +       u8 radio_rx1_lnaa_tune;
> +       u8 radio_rx1_lnag_tune;
> +       u8 radio_tx1_intpaa_boost_tune;
> +       u8 radio_tx1_intpag_boost_tune;
> +       u8 radio_tx1_pada_boost_tune;
> +       u8 radio_tx1_padg_boost_tune;
> +       u8 radio_tx1_pgaa_boost_tune;
> +       u8 radio_tx1_pgag_boost_tune;
> +       u8 radio_tx1_mixa_boost_tune;
> +       u8 radio_tx1_mixg_boost_tune;
>        /* PHY register values on channelswitch */
>        struct b43_phy_n_sfo_cfg phy_regs;
>  };
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
