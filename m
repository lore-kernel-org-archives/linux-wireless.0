Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65221 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1BIVuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:50:01 -0500
Received: by qyj19 with SMTP id 19so1788669qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 13:50:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297286787.11978.12.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	<1297262161.18053.26.camel@dev.znau.edu.ua>
	<AANLkTi=DV6gnbYfBsXeL6rb3Rz0a+NhgmN04hPY12wLY@mail.gmail.com>
	<1297286787.11978.12.camel@dev.znau.edu.ua>
Date: Wed, 9 Feb 2011 22:50:00 +0100
Message-ID: <AANLkTikPzPNo5p7O8xN3ka=0TGcECJB+CVOs8Mo3bXVc@mail.gmail.com>
Subject: Re: SSB AI support code ([RFC5/11] SSB propagate core control and
 state ops usage)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/9 George Kashperko <george@znau.edu.ua>:
>> 2011/2/9 George Kashperko <george@znau.edu.ua>:
>> > From: George Kashperko <george@znau.edu.ua>
>> >
>> > Major differences between AI/SB from drivers' perespective is control
>> > and state flags handling. These long term used to be TMSLOW/TMSHIGH ones
>> > and in order to be handled transparently should be masked under some
>> > indirect access handlers. This patch forces use of ssb_core_ctl_flags
>> > and ssb_core_state_flags introduced early. TMSLOW/TMSHIGH defines outside
>> > ssb code (b43, ssb gige and ohci drivers) were renamed to reflect actual
>> > meaning, flags' definitions moved to low two bytes. Common TMSLOW/TMSHIGH
>> > defines moved to ssb_private.h in order to limit their use by internal
>> > SB-specic code only.
>> > Signed-off-by: George Kashperko <george@znau.edu.ua>
>> > ---
>> >  drivers/net/b44.c                          |    2
>> >  drivers/net/wireless/b43/b43.h             |   32 ++++-----
>> >  drivers/net/wireless/b43/dma.c             |    4 -
>> >  drivers/net/wireless/b43/main.c            |   61 +++++++------------
>> >  drivers/net/wireless/b43/phy_g.c           |    2
>> >  drivers/net/wireless/b43/phy_n.c           |   18 +----
>> >  drivers/net/wireless/b43legacy/b43legacy.h |   20 +++---
>> >  drivers/net/wireless/b43legacy/dma.c       |    4 -
>> >  drivers/net/wireless/b43legacy/main.c      |   52 +++++-----------
>> >  drivers/net/wireless/b43legacy/phy.c       |    2
>> >  drivers/ssb/driver_gige.c                  |   19 ++---
>> >  drivers/ssb/main.c                         |   20 ++++--
>> >  drivers/ssb/ssb_private.h                  |   24 +++++++
>> >  drivers/usb/host/ohci-ssb.c                |    4 -
>> >  include/linux/ssb/ssb.h                    |    4 -
>> >  include/linux/ssb/ssb_driver_gige.h        |   12 +--
>> >  include/linux/ssb/ssb_regs.h               |   42 ++++++-------
>> >  17 files changed, 160 insertions(+), 162 deletions(-)
>> > --- linux-next-20110203.orig/drivers/net/b44.c  2011-02-01 05:05:49.000000000 +0200
>> > +++ linux-next-20110203/drivers/net/b44.c       2011-02-08 12:17:03.000000000 +0200
>> > @@ -1568,7 +1568,7 @@ static void b44_setup_wol_pci(struct b44
>> >        u16 val;
>> >
>> >        if (bp->sdev->bus->bustype != SSB_BUSTYPE_SSB) {
>> > -               bw32(bp, SSB_TMSLOW, br32(bp, SSB_TMSLOW) | SSB_TMSLOW_PE);
>> > +               ssb_core_ctl_flags(bp->sdev, 0, SSB_CORECTL_PE, NULL);
>> >                pci_read_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, &val);
>> >                pci_write_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, val | SSB_PE);
>> >        }
>> > --- linux-next-20110203.orig/drivers/net/wireless/b43/b43.h     2011-02-01 05:05:49.000000000 +0200
>> > +++ linux-next-20110203/drivers/net/wireless/b43/b43.h  2011-02-08 12:17:03.000000000 +0200
>> > @@ -414,22 +414,22 @@ enum {
>> >  #define B43_MACCMD_CCA                 0x00000008      /* Clear channel assessment */
>> >  #define B43_MACCMD_BGNOISE             0x00000010      /* Background noise */
>> >
>> > -/* 802.11 core specific TM State Low (SSB_TMSLOW) flags */
>> > -#define B43_TMSLOW_GMODE               0x20000000      /* G Mode Enable */
>> > -#define B43_TMSLOW_PHY_BANDWIDTH       0x00C00000      /* PHY band width and clock speed mask (N-PHY only) */
>> > -#define  B43_TMSLOW_PHY_BANDWIDTH_10MHZ        0x00000000      /* 10 MHz bandwidth, 40 MHz PHY */
>> > -#define  B43_TMSLOW_PHY_BANDWIDTH_20MHZ        0x00400000      /* 20 MHz bandwidth, 80 MHz PHY */
>> > -#define  B43_TMSLOW_PHY_BANDWIDTH_40MHZ        0x00800000      /* 40 MHz bandwidth, 160 MHz PHY */
>> > -#define B43_TMSLOW_PLLREFSEL           0x00200000      /* PLL Frequency Reference Select (rev >= 5) */
>> > -#define B43_TMSLOW_MACPHYCLKEN         0x00100000      /* MAC PHY Clock Control Enable (rev >= 5) */
>> > -#define B43_TMSLOW_PHYRESET            0x00080000      /* PHY Reset */
>> > -#define B43_TMSLOW_PHYCLKEN            0x00040000      /* PHY Clock Enable */
>> > -
>> > -/* 802.11 core specific TM State High (SSB_TMSHIGH) flags */
>> > -#define B43_TMSHIGH_DUALBAND_PHY       0x00080000      /* Dualband PHY available */
>> > -#define B43_TMSHIGH_FCLOCK             0x00040000      /* Fast Clock Available (rev >= 5) */
>> > -#define B43_TMSHIGH_HAVE_5GHZ_PHY      0x00020000      /* 5 GHz PHY available (rev >= 5) */
>> > -#define B43_TMSHIGH_HAVE_2GHZ_PHY      0x00010000      /* 2.4 GHz PHY available (rev >= 5) */
>> > +/* 802.11 core specific control flags */
>> > +#define B43_CORECTL_GMODE                      0x2000  /* G Mode Enable */
>> > +#define B43_CORECTL_PHY_BANDWIDTH              0x00C0  /* PHY band width and clock speed mask (N-PHY only) */
>> > +#define  B43_CORECTL_PHY_BANDWIDTH_10MHZ       0x0000  /* 10 MHz bandwidth, 40 MHz PHY */
>> > +#define  B43_CORECTL_PHY_BANDWIDTH_20MHZ       0x0040  /* 20 MHz bandwidth, 80 MHz PHY */
>> > +#define  B43_CORECTL_PHY_BANDWIDTH_40MHZ       0x0080  /* 40 MHz bandwidth, 160 MHz PHY */
>> > +#define B43_CORECTL_PLLREFSEL                  0x0020  /* PLL Frequency Reference Select (rev >= 5) */
>> > +#define B43_CORECTL_MACPHYCLKEN                        0x0010  /* MAC PHY Clock Control Enable (rev >= 5) */
>> > +#define B43_CORECTL_PHYRESET                   0x0008  /* PHY Reset */
>> > +#define B43_CORECTL_PHYCLKEN                   0x0004  /* PHY Clock Enable */
>> > +
>> > +/* 802.11 core specific state flags */
>> > +#define B43_CORESTAT_DUALBAND_PHY              0x0008  /* Dualband PHY available */
>> > +#define B43_CORESTAT_FCLOCK                    0x0004  /* Fast Clock Available (rev >= 5) */
>> > +#define B43_CORESTAT_HAVE_5GHZ_PHY             0x0002  /* 5 GHz PHY available (rev >= 5) */
>> > +#define B43_CORESTAT_HAVE_2GHZ_PHY             0x0001  /* 2.4 GHz PHY available (rev >= 5) */
>>
>> I don't know, I've doubts about it :/ That flags are quite messy, mask
>> for them is 0x3FFC0000. Ideally we should shift it by 14 bits, but
>> that would make writing code harder. Maaaaybe... Michael what do you
>> think about this?
>>
>>
>> > @@ -1213,6 +1214,9 @@ static void ssb_device_disable_sb(struct
>> >        if (ssb_read32(dev, SSB_TMSLOW) & SSB_TMSLOW_RESET)
>> >                return;
>> >
>> > +       SSB_WARN_ON(core_specific_flags & 0xFFFF0000);
>>
>> Make it ~0x00003FFC, value 0x1 is not valid flag.
> Actual mask for _core_ flags is 0xFFFF0000 for SB and 0x0000FFFF for AI.

OK.


> 0x3FFC is mask for core dependent flags.
> SSB_CORECTL_CLOCK | SSB_CORECTL_FGC | SSB_CORECTL_PE | SSB_CORECTL_BE |
> 0x3FFC = 0xFFFF
> Therefore sanity check for SB is &0xFFFF0000, for AI is &0x0000FFFF
> Layout of core flags in these 2 bytes is the same for AI and SB cores.

You created WARN_ON against core_specific_flags, not sth like
core_flags. That's why I think test should be against 0x3FFC, not
0xFFFF. Am I wrong? Or if we ever pass not-core-specific flags to
ssb_device_disable/ssb_device_enable, we should rename variable from
core_specific_flags to core_flags.


>> Why don't you go ahead and make core flags u16?
>>
> Dont see any problems with this as other 2 bytes aint used currently in
> any way.

You do not see problems with making it u16, or problems with it being u32?

-- 
Rafał
