Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45694 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZHZVoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 17:44:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Revert to the original PHY register write routine
Date: Wed, 26 Aug 2009 23:44:34 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1251322728-7034-1-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1251322728-7034-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908262344.36295.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2009 23:38:48 Gábor Stefanik wrote:
> From: root <root@NR3DMain.NR3D>
> 
> After some discussion on IRC about the PHY register write change,
> I am not sure anymore if this is the right thing to do.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_lp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 80f245c..a57c40d 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1496,7 +1496,8 @@ static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
>  
>  static void b43_lpphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
>  {
> -	b43_write32(dev, B43_MMIO_PHY_CONTROL, ((u32)value << 16) | reg);
> +	b43_write32(dev, B43_MMIO_PHY_CONTROL, reg);
> +	b43_write32(dev, B43_MMIO_PHY_DATA, value);

You just introduced a bug (need 16bit write).
As I said. I'm OK with it, if it works. Just submit it as separate patch in the future.

>  }
>  
>  static void b43_lpphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,



-- 
Greetings, Michael.
