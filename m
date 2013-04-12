Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42932 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3DLG07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 02:26:59 -0400
Received: by mail-ob0-f174.google.com with SMTP id wm15so2092415obc.33
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 23:26:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365683953-3430-1-git-send-email-hauke@hauke-m.de>
References: <1365683953-3430-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 12 Apr 2013 08:26:58 +0200
Message-ID: <CACna6rxteO-uMCXNO0xh8t3Pkry3NnDkPJGcYuwRSSYEZue8=Q@mail.gmail.com> (sfid-20130412_082703_728635_35520F39)
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/11 Hauke Mehrtens <hauke@hauke-m.de>:
> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/b43/phy_n.c |   86 +++++++-------------------------------
>  1 file changed, 14 insertions(+), 72 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 7b557ad..05945da 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -5097,77 +5097,6 @@ static void b43_chantab_phy_upload(struct b43_wldev *dev,
>         b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
>  }
>
> -/* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
> -static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
> -{

I think it may be better to keep b43_nphy_pmu_spur_avoid, as some
chipsets may need additional workarounds (that AFAIR can't be handled
in ssb/bcma). I mean workarounds related to the spurious avoidance
ofc, so it would be a good idea to put them in separated function.

-- 
Rafał
