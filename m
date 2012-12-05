Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53441 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2LEWWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 17:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <1354729568-19993-7-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de> <1354729568-19993-7-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 6 Dec 2012 09:22:19 +1100
Message-ID: <CAGRGNgXp7PVtdVOraF3PcGpzZ=9zAfa=9MWODiTCq9cFXPCoqA@mail.gmail.com> (sfid-20121205_232245_249677_8D5432F2)
Subject: Re: [PATCH v3 06/11] ssb: get alp clock from devices with PMU
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, wim@iguana.be,
	linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

Sorry this is so late, I only just noticed.

On Thu, Dec 6, 2012 at 4:46 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> If there is a PMU in the device, get the alp clock from that part and
> do not assume 20000000.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/ssb/driver_chipcommon.c     |   15 +++++++++------
>  drivers/ssb/driver_chipcommon_pmu.c |   27 +++++++++++++++++++++++++++
>  drivers/ssb/ssb_private.h           |    1 +
>  3 files changed, 37 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
> index d7d5804..a43415a 100644
> --- a/drivers/ssb/driver_chipcommon_pmu.c
> +++ b/drivers/ssb/driver_chipcommon_pmu.c
> @@ -618,6 +618,33 @@ void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on)
>  EXPORT_SYMBOL(ssb_pmu_set_ldo_voltage);
>  EXPORT_SYMBOL(ssb_pmu_set_ldo_paref);
>
> +static u32 ssb_pmu_get_alp_clock_clk0(struct ssb_chipcommon *cc)
> +{
> +       u32 crystalfreq;
> +       const struct pmu0_plltab_entry *e = NULL;
> +
> +       crystalfreq = chipco_read32(cc, SSB_CHIPCO_PMU_CTL) &
> +                     SSB_CHIPCO_PMU_CTL_XTALFREQ >> SSB_CHIPCO_PMU_CTL_XTALFREQ_SHIFT;
> +       e = pmu0_plltab_find_entry(crystalfreq);
> +       BUG_ON(!e);
> +       return e->freq * 1000;
> +}
> +
> +u32 ssb_pmu_get_alp_clock(struct ssb_chipcommon *cc)
> +{
> +       struct ssb_bus *bus = cc->dev->bus;
> +
> +       switch (bus->chip_id) {
> +       case 0x5354:
> +               ssb_pmu_get_alp_clock_clk0(cc);
> +       default:
> +               ssb_printk(KERN_ERR PFX
> +                          "ERROR: PMU alp clock unknown for device %04X\n",
> +                          bus->chip_id);
> +               return 0;

Would it be better to return the default here (or handle this case in
ssb_chipco_alp_clock() ) so these chips have a clock rate?

> +       }
> +}
> +
>  u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc)
>  {
>         struct ssb_bus *bus = cc->dev->bus;

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
