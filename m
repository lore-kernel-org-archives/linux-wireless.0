Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37817 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbZHCUiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:38:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
Date: Mon, 3 Aug 2009 22:38:17 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <4A7610AE.5000908@gmail.com> <200908031115.12929.mb@bu3sch.de> <69e28c910908030655g4ea70567y30ca2e68a77b872b@mail.gmail.com>
In-Reply-To: <69e28c910908030655g4ea70567y30ca2e68a77b872b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908032238.18030.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 August 2009 15:55:29 Gábor Stefanik wrote:
> On Mon, Aug 3, 2009 at 11:15 AM, Michael Buesch<mb@bu3sch.de> wrote:
> > On Monday 03 August 2009 11:13:37 Michael Buesch wrote:
> >> On Monday 03 August 2009 00:18:22 Gábor Stefanik wrote:
> >> > Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
> >> > boardflags_hi values to defines.
> >> > Implement b43_phy_copy for easier copying between registers, as needed
> >> > by LP-PHY init.
> >>
> >> > +   if (bus->sprom.boardflags_hi&  B43_BFH_FEM_BT)&&
> >> > +      (bus->chip_id == 0x5354)&&
> >> > +      (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
> >> > +           b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
> >> > +           b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
> >> > +           b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
> >> > +           b43_hf_write(dev, b43_hf_read | 0x0800ULL<<  32);
> >> > +   }
> >>
> >> The HF write is wrong. Read the specification:
> >> http://bcm-v4.sipsolutions.net/802.11/Mhf
> >>
> >> Patch otherwise looks ok.
> >
> > Sorry, I replied to the wrong mail. But this does also apply to V2 patch.
> >
> > --
> > Greetings, Michael.
> >
> 
> In V2, this line is as follows (b43_hf_read corrected):
> 
> b43_hf_write(dev, b43_hf_read(dev) | 0x0800ULL << 32)
> 
> The command in the specs is this:
> 
> mhf(2, 0x800, 0x800, 1)
> 
> 2 means B43_SHM_SH_HOSTFHI, 0x800 is the bit to set, and 1 is
> allbands, which, per Larry, can be ignored in our current
> implementation (it is specific to the caching behavior of the mips
> driver).
> 
> From what I read in b43_hf_write, writing to HOSTFHI can be achieved
> by left-shifting by 32 (16 for HOSTFMI).
> 
> Is the problem that we write all 3 hostflags registers here?
> 
> (BTW are there any other known host flags? If there are, maybe we
> should #define them.)
> 

My point is that update_mhf does not write to actual hardware, as far
as I understand the code. Larry, can you please explain that part of the
specs?

-- 
Greetings, Michael.
