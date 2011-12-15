Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59150 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1LOGGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 01:06:11 -0500
Received: by wgbds13 with SMTP id ds13so466806wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 22:06:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
References: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 15 Dec 2011 07:06:08 +0100
Message-ID: <CACna6rzkvv=LOtnUBi7xt04yEPwPxkBmVXo6gmm3XEK1g0nbFQ@mail.gmail.com> (sfid-20111215_070614_595739_BC0745C7)
Subject: Re: [PATCH] b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/14 John W. Linville <linville@tuxdriver.com>:
> Avoids this:
>
> ERROR: "bcma_chipco_pll_write" [drivers/net/wireless/b43/b43.ko] undefined!
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> It looks like phy_lcn.c could use some bits like this as well...
>
>  drivers/net/wireless/b43/phy_n.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 6b95fd2..154f97d 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -4048,6 +4048,7 @@ int b43_phy_initn(struct b43_wldev *dev)
>  /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
>  static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
>  {
> +#ifdef CONFIG_B43_BCMA
>        struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;

Oops, after a moment it doesn't look good. Nack.

We can't unconditionally touch bdev in phy_n, this code can also be
executed for SSB based card. We need "ifdef" plus
switch (dev->dev->bus_type) {

-- 
Rafał
