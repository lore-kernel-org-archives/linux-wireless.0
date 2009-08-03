Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44855 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZHCJPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 05:15:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
Date: Mon, 3 Aug 2009 11:15:12 +0200
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <4A7610AE.5000908@gmail.com> <200908031113.38229.mb@bu3sch.de>
In-Reply-To: <200908031113.38229.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908031115.12929.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 August 2009 11:13:37 Michael Buesch wrote:
> On Monday 03 August 2009 00:18:22 Gábor Stefanik wrote:
> > Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
> > boardflags_hi values to defines.
> > Implement b43_phy_copy for easier copying between registers, as needed
> > by LP-PHY init.
> 
> > +	if (bus->sprom.boardflags_hi&  B43_BFH_FEM_BT)&&
> > +	   (bus->chip_id == 0x5354)&&
> > +	   (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
> > +		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
> > +		b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
> > +		b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
> > +		b43_hf_write(dev, b43_hf_read | 0x0800ULL<<  32);
> > +	}
> 
> The HF write is wrong. Read the specification:
> http://bcm-v4.sipsolutions.net/802.11/Mhf
> 
> Patch otherwise looks ok.

Sorry, I replied to the wrong mail. But this does also apply to V2 patch.

-- 
Greetings, Michael.
