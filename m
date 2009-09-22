Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45929 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbZIVMvn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 08:51:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Implement RFKILL status for LP PHY
Date: Tue, 22 Sep 2009 14:51:40 +0200
Cc: John Linville <linville@tuxdriver.com>,
	=?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <4AB8054F.7080600@lwfinger.net>
In-Reply-To: <4AB8054F.7080600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909221451.42134.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 September 2009 00:59:27 Larry Finger wrote:
> The LP (and probably N) PHY has the same radio disabled bit as
> the higher-revision A and G PHYs.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

ack

> ---
> 
> John,
> 
> Submission of this change for 2.6.32 would be nice, but not necessary.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-testing/drivers/net/wireless/b43/rfkill.c
> @@ -28,7 +28,7 @@
>  /* Returns TRUE, if the radio is enabled in hardware. */
>  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>  {
> -	if (dev->phy.rev >= 3) {
> +	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
>  		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
>  		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>  			return 1;
> 
> 
> 
> 



-- 
Greetings, Michael.
