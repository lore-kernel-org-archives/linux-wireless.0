Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38611 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaGTLjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:39:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 95671280787
	for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 13:36:50 +0200 (CEST)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com [209.85.192.41])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 5E5E92807A5
	for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 13:36:48 +0200 (CEST)
Received: by mail-qg0-f41.google.com with SMTP id q107so4619728qgd.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 20 Jul 2014 13:38:41 +0200
Message-ID: <CAOiHx=k=ttdKXM=BudxXtjaw+sZ7Oby7vhrp29XopeGm5Pwz0A@mail.gmail.com> (sfid-20140720_133913_978335_28703BB9)
Subject: Re: [PATCH 1/2] b43: implement PPR (Power Per Rate) management/API
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2014 at 1:00 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> Broadcom hardware supports auto-adjustment of TX power depending on the
> currently used rate. So far all calculations were handled without any
> helpers (API) using big arrays and magic offsets.
> It seems Broadcom recently decided to clean this up by developing PPR.
> Their wlc_ppr.h can be found in open parts of the SDK.
> As we plan to implement support for rate-based TX power it makes sense
> to also implement our version of PPR as well.

Nice one.

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/Makefile |   1 +
>  drivers/net/wireless/b43/b43.h    |   7 ++
>  drivers/net/wireless/b43/ppr.c    | 210 ++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/b43/ppr.h    |  21 ++++
>  4 files changed, 239 insertions(+)
>  create mode 100644 drivers/net/wireless/b43/ppr.c
>  create mode 100644 drivers/net/wireless/b43/ppr.h
>
> diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
> index 6e00b88..9f7965a 100644
> --- a/drivers/net/wireless/b43/Makefile
> +++ b/drivers/net/wireless/b43/Makefile
> @@ -18,6 +18,7 @@ b43-y                         += xmit.o
>  b43-y                          += dma.o
>  b43-y                          += pio.o
>  b43-y                          += rfkill.o
> +b43-y                          += ppr.o

Is this only used for N-PHY, or also for others? If not, it might make
sense to only include it if N-PHY support is selected. Not sure if
it's large enough to matter much.

>  b43-$(CONFIG_B43_LEDS)         += leds.o
>  b43-$(CONFIG_B43_PCMCIA)       += pcmcia.o
>  b43-$(CONFIG_B43_SDIO)         += sdio.o
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index 4113b69..6cfd86d 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -791,6 +791,13 @@ struct b43_firmware {
>         bool pcm_request_failed;
>  };
>
> +enum b43_band {
> +       B43_BAND_2G = 0,
> +       B43_BAND_5G_LO = 1,
> +       B43_BAND_5G_MI = 2,
> +       B43_BAND_5G_HI = 3,
> +};
> +
>  /* Device (802.11 core) initialization status. */
>  enum {
>         B43_STAT_UNINIT = 0,    /* Uninitialized. */
> diff --git a/drivers/net/wireless/b43/ppr.c b/drivers/net/wireless/b43/ppr.c
> new file mode 100644
> index 0000000..36c4b419
> --- /dev/null
> +++ b/drivers/net/wireless/b43/ppr.c
> @@ -0,0 +1,210 @@
> +#include "ppr.h"
> +#include "b43.h"

This file could use a license/copyright header. It looks a bit odd without one.

> +
> +#define B43_PPR_CCK_RATES_NUM          4
> +#define B43_PPR_OFDM_RATES_NUM         8
> +#define B43_PPR_MCS_RATES_NUM          8
> +
> +#define B43_PPR_RATES_NUM      (B43_PPR_CCK_RATES_NUM +        \
> +                                B43_PPR_OFDM_RATES_NUM * 2 +   \
> +                                B43_PPR_MCS_RATES_NUM * 4)
> +
> +struct b43_ppr_rates {
> +       u8 cck[B43_PPR_CCK_RATES_NUM];
> +       u8 ofdm[B43_PPR_OFDM_RATES_NUM];
> +       u8 ofdm_20_cdd[B43_PPR_OFDM_RATES_NUM];
> +       u8 mcs_20[B43_PPR_MCS_RATES_NUM]; /* SISO */
> +       u8 mcs_20_cdd[B43_PPR_MCS_RATES_NUM];
> +       u8 mcs_20_stbc[B43_PPR_MCS_RATES_NUM];
> +       u8 mcs_20_sdm[B43_PPR_MCS_RATES_NUM];
> +} __packed;

not sure if __packed makes a difference if *all* members are u8.

> +
> +struct b43_ppr {
> +       /* All powers are in qdbm (Q5.2) */
> +       union {
> +               u8 __all_rates[B43_PPR_RATES_NUM];
> +               struct b43_ppr_rates rates;
> +       } __packed;

Same here.

> +};
> +
> +#define ppr_for_each_entry(ppr, i, entry)                              \
> +       for (i = 0, entry = &(ppr)->__all_rates[i];                     \
> +            i < B43_PPR_RATES_NUM;                                     \
> +            i++, entry++)
> +
> +struct b43_ppr *b43_ppr_alloc(struct b43_wldev *dev)
> +{
> +       return kzalloc(sizeof(struct b43_ppr), GFP_KERNEL);
> +}
> +
> +void b43_ppr_clear(struct b43_wldev *dev, struct b43_ppr *ppr)
> +{
> +       memset(ppr, 0, sizeof(*ppr));
> +}
> +
> +void b43_ppr_add(struct b43_wldev *dev, struct b43_ppr *ppr, int diff)
> +{
> +       int i;
> +       u8 *rate;
> +
> +       ppr_for_each_entry(ppr, i, rate) {
> +               *rate = clamp_val(*rate + diff, 0, 127);
> +       }
> +}
> +
> +void b43_ppr_apply_max(struct b43_wldev *dev, struct b43_ppr *ppr, u8 max)
> +{
> +       int i;
> +       u8 *rate;
> +
> +       ppr_for_each_entry(ppr, i, rate) {
> +               *rate = min(*rate, max);
> +       }
> +}
> +
> +void b43_ppr_apply_min(struct b43_wldev *dev, struct b43_ppr *ppr, u8 min)
> +{
> +       int i;
> +       u8 *rate;
> +
> +       ppr_for_each_entry(ppr, i, rate) {
> +               *rate = max(*rate, min);
> +       }
> +}
> +
> +u8 b43_ppr_get_max(struct b43_wldev *dev, struct b43_ppr *ppr)
> +{
> +       u8 res = 0;
> +       int i;
> +       u8 *rate;
> +
> +       ppr_for_each_entry(ppr, i, rate) {
> +               res = max(*rate, res);
> +       }
> +
> +       return res;
> +}
> +
> +bool b43_ppr_load_max_from_sprom(struct b43_wldev *dev, struct b43_ppr *ppr,
> +                                enum b43_band band)
> +{
> +       struct b43_ppr_rates *rates = &ppr->rates;
> +       struct ssb_sprom *sprom = dev->dev->bus_sprom;
> +       struct b43_phy *phy = &dev->phy;
> +       u8 maxpwr, off;
> +       u32 *sprom_ofdm_po;

sprom->ofdm2gpo is a single u32, you gain nothing by using a pointer
and dereferencing it (actually you will double your stack usage on 64
bit system).

> +       u16 *sprom_mcs_po;
> +       u8 extra_cdd_po, extra_stbc_po;
> +       int i;
> +
> +       switch (band) {
> +       case B43_BAND_2G:
> +               maxpwr = min(sprom->core_pwr_info[0].maxpwr_2g,
> +                            sprom->core_pwr_info[1].maxpwr_2g);
> +               sprom_ofdm_po = &sprom->ofdm2gpo;
> +               sprom_mcs_po = sprom->mcs2gpo;
> +               extra_cdd_po = (sprom->cddpo >> 0) & 0xf;
> +               extra_stbc_po = (sprom->stbcpo >> 0) & 0xf;
> +               break;
> +       case B43_BAND_5G_LO:
> +               maxpwr = min(sprom->core_pwr_info[0].maxpwr_5gl,
> +                            sprom->core_pwr_info[1].maxpwr_5gl);
> +               sprom_ofdm_po = &sprom->ofdm5glpo;
> +               sprom_mcs_po = sprom->mcs5glpo;
> +               extra_cdd_po = (sprom->cddpo >> 8) & 0xf;
> +               extra_stbc_po = (sprom->stbcpo >> 8) & 0xf;
> +               break;
> +       case B43_BAND_5G_MI:
> +               maxpwr = min(sprom->core_pwr_info[0].maxpwr_5g,
> +                            sprom->core_pwr_info[1].maxpwr_5g);
> +               sprom_ofdm_po = &sprom->ofdm5gpo;
> +               sprom_mcs_po = sprom->mcs5gpo;
> +               extra_cdd_po = (sprom->cddpo >> 4) & 0xf;
> +               extra_stbc_po = (sprom->stbcpo >> 4) & 0xf;
> +               break;
> +       case B43_BAND_5G_HI:
> +               maxpwr = min(sprom->core_pwr_info[0].maxpwr_5gh,
> +                            sprom->core_pwr_info[1].maxpwr_5gh);
> +               sprom_ofdm_po = &sprom->ofdm5ghpo;
> +               sprom_mcs_po = sprom->mcs5ghpo;
> +               extra_cdd_po = (sprom->cddpo >> 12) & 0xf;
> +               extra_stbc_po = (sprom->stbcpo >> 12) & 0xf;
> +               break;
> +       default:
> +               BUG_ON(1);

Is it really that critical that it should halt the system? Maybe a
WARN_ON[_ONCE](1); is enough.

> +               return false;
> +       }
> +
> +       if (band == B43_BAND_2G) {
> +               for (i = 0; i < 4; i++) {
> +                       off = ((sprom->cck2gpo >> (i * 4)) & 0xF) * 2;
> +                       rates->cck[i] = maxpwr - off;
> +               }
> +       }
> +
> +       /* OFDM */
> +       for (i = 0; i < 8; i++) {
> +               off = ((*sprom_ofdm_po >> (i * 4)) & 0xF) * 2;
> +               rates->ofdm[i] = maxpwr - off;
> +       }
> +
> +       /* MCS 20 SISO */
> +       rates->mcs_20[0] = rates->ofdm[0];
> +       rates->mcs_20[1] = rates->ofdm[2];
> +       rates->mcs_20[2] = rates->ofdm[3];
> +       rates->mcs_20[3] = rates->ofdm[4];
> +       rates->mcs_20[4] = rates->ofdm[5];
> +       rates->mcs_20[5] = rates->ofdm[6];
> +       rates->mcs_20[6] = rates->ofdm[7];
> +       rates->mcs_20[7] = rates->ofdm[7];
> +
> +       /* MCS 20 CDD */
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[0] >> (i * 4)) & 0xF) * 2;

You should decide whether to use upper case or lower case hex (above
is all lower).

> +               rates->mcs_20_cdd[i] = maxpwr - off;
> +               if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
> +                       rates->mcs_20_cdd[i] -= extra_cdd_po;
> +       }
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[1] >> (i * 4)) & 0xF) * 2;
> +               rates->mcs_20_cdd[4 + i] = maxpwr - off;
> +               if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
> +                       rates->mcs_20_cdd[i] -= extra_cdd_po;

Did you intend to reduce rates->mcs_20_cdd[4 + i] here?

> +       }
> +
> +       /* OFDM 20 CDD */
> +       rates->ofdm_20_cdd[0] = rates->mcs_20_cdd[0];
> +       rates->ofdm_20_cdd[1] = rates->mcs_20_cdd[0];
> +       rates->ofdm_20_cdd[2] = rates->mcs_20_cdd[1];
> +       rates->ofdm_20_cdd[3] = rates->mcs_20_cdd[2];
> +       rates->ofdm_20_cdd[4] = rates->mcs_20_cdd[3];
> +       rates->ofdm_20_cdd[5] = rates->mcs_20_cdd[4];
> +       rates->ofdm_20_cdd[6] = rates->mcs_20_cdd[5];
> +       rates->ofdm_20_cdd[7] = rates->mcs_20_cdd[6];
> +
> +       /* MCS 20 STBC */
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[0] >> (i * 4)) & 0xF) * 2;
> +               rates->mcs_20_stbc[i] = maxpwr - off;
> +               if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
> +                       rates->mcs_20_stbc[i] -= extra_stbc_po;
> +       }
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[1] >> (i * 4)) & 0xF) * 2;
> +               rates->mcs_20_stbc[4 + i] = maxpwr - off;
> +               if (phy->type == B43_PHYTYPE_N && phy->rev >= 3)
> +                       rates->mcs_20_stbc[i] -= extra_stbc_po;

Same question here, did you intend rates->mcs_20_stbc[4 + i]?

> +       }
> +
> +       /* MCS 20 SDM */
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[2] >> (i * 4)) & 0xF) * 2;
> +               rates->mcs_20_sdm[i] = maxpwr - off;
> +       }
> +       for (i = 0; i < 4; i++) {
> +               off = ((sprom_mcs_po[3] >> (i * 4)) & 0xF) * 2;
> +               rates->mcs_20_sdm[4 + i] = maxpwr - off;

I guess you did ;-)

> +       }
> +
> +       return true;
> +}

Rest looks fine.


Jonas
