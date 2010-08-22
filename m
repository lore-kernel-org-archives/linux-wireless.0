Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54713 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab0HVUE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 16:04:28 -0400
Received: by qwh6 with SMTP id 6so4577354qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 13:04:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimeKMR8MfoNKyr6i-JxA8bdqwMKriUbBOagw-z5@mail.gmail.com>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
 <1282506589-8220-2-git-send-email-zajec5@gmail.com> <AANLkTi=dXNY+Hf8--Yp4VjQBOMwDCFuQqNSi_OAsq=2X@mail.gmail.com>
 <AANLkTimeKMR8MfoNKyr6i-JxA8bdqwMKriUbBOagw-z5@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 22 Aug 2010 22:04:07 +0200
Message-ID: <AANLkTi=ELhn1sFmpYn5a1-GcWqVBAeRGC6Kc7OBDLmZw@mail.gmail.com>
Subject: Re: [PATCH 2/2] b43: N-PHY: add sub calls of band width setting
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/22 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 22 sierpnia 2010 21:52 u¿ytkownik Gábor Stefanik
> <netrolller.3d@gmail.com> napisa³:
>> 2010/8/22 Rafa³ Mi³ecki <zajec5@gmail.com>:
>>> Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/b43.h        |    1 +
>>>  drivers/net/wireless/b43/phy_common.c |  150 ++++++++++++++++++++++++++++++++-
>>>  drivers/net/wireless/b43/phy_common.h |    7 ++
>>>  3 files changed, 157 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>>> index 8674a99..73376ff 100644
>>> --- a/drivers/net/wireless/b43/b43.h
>>> +++ b/drivers/net/wireless/b43/b43.h
>>> @@ -57,6 +57,7 @@
>>>  #define B43_MMIO_TSF_CFP_REP           0x188
>>>  #define B43_MMIO_TSF_CFP_START         0x18C
>>>  #define B43_MMIO_TSF_CFP_MAXDUR                0x190
>>> +#define B43_MMIO_CLKCTL                        0x1E0   /* clock control status */
>>>
>>>  /* 32-bit DMA */
>>>  #define B43_MMIO_DMA32_BASE0           0x200
>>> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
>>> index b06e3f0..10b9e6f 100644
>>> --- a/drivers/net/wireless/b43/phy_common.c
>>> +++ b/drivers/net/wireless/b43/phy_common.c
>>> @@ -467,10 +467,158 @@ struct b43_c32 b43_cordic(int theta)
>>>        return ret;
>>>  }
>>>
>>> +/* http://bcm-v4.sipsolutions.net/802.11/NcClkCtlCc */
>>> +static bool b43_no_check_clock_control_chip_common(struct b43_wldev *dev,
>>> +                                                               u32 mode)
>>> +{
>>> +       /* TODO: this is temporary hack */
>>> +       return (mode == 0);
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/ClkCtlCc */
>>> +static bool b43_clock_control_chip_common(struct b43_wldev *dev, u32 mode)
>>> +{
>>> +       struct ssb_bus *bus = dev->dev->bus;
>>> +       u16 chip_id = bus->chip_id;
>>> +       u16 chip_rev = bus->chip_rev;
>>> +       /* TODO: specs distinguish PCI and PCIe */
>>> +       bool pci = (bus->bustype == SSB_BUSTYPE_PCI);
>>> +
>>> +       if (dev->dev->id.revision < 6)
>>> +               return false;
>>> +       if (pci && ((chip_id == 0x4311 && chip_rev < 2) ||
>>> +                   (pci && chip_id == 0x4321) ||
>>> +                   (pci && chip_id == 0x4716)))
>>> +               return (mode == 0);
>>> +       return b43_no_check_clock_control_chip_common(dev, mode);
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWaitForWake */
>>> +static void b43_phy_bmac_wait_for_wake(struct b43_wldev *dev)
>>> +{
>>> +       u8 core_rev = dev->dev->bus->pcicore.dev->id.revision;
>>> +       u16 tmp, i;
>>> +
>>> +       if (core_rev == 4) {
>>> +               udelay(5);
>>> +               return;
>>> +       }
>>> +
>>> +       if (dev->phy.type == B43_PHYTYPE_G && core_rev == 5)
>>> +               udelay(2000);
>>> +       else
>>> +               udelay(40);
>>> +
>>> +       for (i = 0; i < 1500; i++) {
>>> +               tmp = b43_shm_read16(dev, B43_SHM_SHARED,
>>> +                                       B43_SHM_SH_UCODESTAT);
>>> +               if (tmp == B43_SHM_SH_UCODESTAT_SLEEP) {
>>> +                       i = 0;
>>> +                       break;
>>> +               }
>>> +               udelay(10);
>>> +       }
>>> +       if (i)
>>> +               b43err(dev->wl, "ucode wake up timeout\n");
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/MctrlWrite */
>>> +static void b43_phy_mac_control_write(struct b43_wldev *dev)
>>> +{
>>> +       u32 tmp = dev->phy.maccontrol;
>>> +       if (dev->phy.wake_override)
>>> +               tmp |= B43_MACCTL_AWAKE;
>>> +       if (dev->phy.mute_override)
>>> +               tmp &= ~B43_MACCTL_AP;
>>> +       tmp |= B43_MACCTL_INFRA;
>>> +       b43_write32(dev, B43_MMIO_MACCTL, tmp);
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideSet */
>>> +static void b43_ucode_wake_override_set(struct b43_wldev *dev, u32 override)
>>> +{
>>> +       dev->phy.wake_override |= override;
>>> +       if (dev->phy.wake_override || dev->phy.maccontrol & B43_MACCTL_AWAKE)
>>> +               return;
>>> +       b43_phy_mac_control_write(dev);
>>> +       b43_phy_bmac_wait_for_wake(dev);
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideClear */
>>> +static void b43_ucode_wake_override_clear(struct b43_wldev *dev, u32 override)
>>> +{
>>> +       dev->phy.wake_override &= ~override;
>>> +       if (dev->phy.wake_override != (dev->phy.maccontrol & B43_MACCTL_AWAKE))
>>> +               return;
>>> +       b43_phy_mac_control_write(dev);
>>> +}
>>> +
>>>  /* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
>>>  static void b43_clock_control(struct b43_wldev *dev, u32 mode)
>>>  {
>>> -       ; /* TODO */
>>> +       struct b43_phy *phy = &dev->phy;
>>> +       struct ssb_bus *bus = dev->dev->bus;
>>> +       u8 core_rev = bus->pcicore.dev->id.revision;
>>> +       u16 i;
>>> +       u32 clkctl;
>>> +       bool wakeup;
>>> +
>>> +       if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU) { /* PMU Present */
>>> +               B43_WARN_ON(core_rev < 20);
>>> +               if (phy->clk) {
>>> +                       bool tmp = (bus->chipco.pmu.rev == 0 &&
>>> +                               (b43_read32(dev, B43_MMIO_CLKCTL) & 0x12));
>>> +
>>> +                       if (mode == 0) {
>>> +                               clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
>>> +                               clkctl |= 0x2;
>>> +                               b43_write32(dev, B43_MMIO_CLKCTL, clkctl);
>>> +                               udelay(33);
>>> +                       }
>>> +
>>> +                       if (mode == 0 || tmp) {
>>> +                               for (i = 0; i < 1500; i++) {
>>> +                                       clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
>>> +                                       if ((clkctl & 0x20000) == 0) {
>>> +                                               i = 0;
>>> +                                               break;
>>> +                                       }
>>> +                                       udelay(10);
>>> +                               }
>>> +                               if (i)
>>> +                                       b43err(dev->wl, "clock timeout\n");
>>> +                       }
>>> +
>>> +                       if (mode != 0 && tmp) {
>>> +                               clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
>>> +                               clkctl &= ~0x2;
>>> +                               b43_write32(dev, B43_MMIO_CLKCTL, clkctl);
>>> +                       }
>>> +               }
>>> +               phy->forcefastclk = (mode == 0);
>>> +       } else {
>>> +               B43_WARN_ON(core_rev >= 20);
>>> +
>>> +               wakeup = (core_rev < 9);
>>> +               if (phy->up && wakeup)
>>> +                       b43_ucode_wake_override_set(dev, 1);
>>> +
>>> +               phy->forcefastclk = b43_clock_control_chip_common(dev, mode);
>>> +               if (core_rev < 11) {
>>> +                       if (phy->forcefastclk)
>>> +                               ; /* TODO: b43_mhf(dev, 0, 0x400, 0x400, 3); */
>>> +                       else
>>> +                               ; /* TODO: b43_mhf(dev, 0, 0x400, 0, 3); */
>>
>> We do implement mhf already, though it is done differently than in wl.
>> See my earlier "Add missing HF write" patch.
>
> Yes, I noticed this in your patch, thanks, however I don't understand
> relation between our implementation and wl yet. I'm not 100% sure how
> to translate this, so I decided to left this as TODO. Didn't want to
> wait anymore before publishing this, to avoid situation of
> implementing the same functions and wasting your and/or mine time.
>
> Could you post a patch making real call instead of this comment, please?
>
> --
> Rafa³
>

Sorry, I'm on a Windows-only machine right now.
However, the general rule of translation is:
mhf(a, b, c, d) -> b43_hf_write(dev, (b43_hf_read(dev) & (~b <<
(a*16))) | (c << (a*16)))
(Yes, the last parameter is ignored; it seems to be just Broadcrap -
crap written by Broadcom.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
