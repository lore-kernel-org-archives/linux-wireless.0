Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37020 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968441Ab0B0OuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 09:50:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 08/11] b43: implement writing to MMIO shared memory
Date: Sat, 27 Feb 2010 15:50:19 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <201002092359.24301.mb@bu3sch.de> <b170af451002270309l1cbc880et100fc4e468386934@mail.gmail.com>
In-Reply-To: <b170af451002270309l1cbc880et100fc4e468386934@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002271550.19350.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 February 2010 12:09:30 Rafał Miłecki wrote:
> 2010/2/9 Michael Buesch <mb@bu3sch.de>:
> > On Tuesday 09 February 2010 21:04:40 Rafał Miłecki wrote:
> >> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >> ---
> >>  drivers/net/wireless/b43/phy_common.c |   11 +++++++++++
> >>  drivers/net/wireless/b43/phy_common.h |    2 ++
> >>  2 files changed, 13 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> >> index 8f7d7ef..0b0f9df 100644
> >> --- a/drivers/net/wireless/b43/phy_common.c
> >> +++ b/drivers/net/wireless/b43/phy_common.c
> >> @@ -466,3 +466,14 @@ struct b43_c32 b43_cordic(int theta)
> >>
> >>       return ret;
> >>  }
> >> +
> >> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWriteShm */
> >> +void b43_bmac_write_shm(struct b43_wldev *dev, u32 offset, u16 value)
> >> +{
> >> +     b43_write32(dev, B43_MMIO_SHM_CONTROL, 0x00010000 | (offset >> 2));
> >> +     b43_read32(dev, B43_MMIO_SHM_CONTROL);
> >> +     if (offset & 2)
> >> +             b43_write16(dev, 0x165, value);
> >> +     else
> >> +             b43_write16(dev, B43_MMIO_SHM_DATA, value);
> >> +}
> >
> > I'd like to put a biiiig questionmark on this.
> > We already have SHM access. Your function does exactly the same, except that it
> > accesses the bullshit register h165.
> 
> Yeah, that 0x165 is really crappy. Let's hope it really should be
> 0x166 (B43_MMIO_SHM_DATA_UNALIGNED).
> 
> Do you think we should add dummy-read to b43_shm_control_word as
> BmacWriteShm does? Currently we do not perform that.

That doesn't hurt.
It probably won't help much either, as the whole driver depends on implicit write posting.
But I don't care whether you add it or not.

-- 
Greetings, Michael.
