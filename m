Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37826 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3CUWsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 18:48:09 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi8so2052929wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 15:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363885909-12263-1-git-send-email-hauke@hauke-m.de>
References: <1363885909-12263-1-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Mar 2013 09:41:37 +1100
Message-ID: <CAGRGNgXaZ69o9xNfUih3m4fJQQDT0=C0tLpmYuCVuc4=TAarGw@mail.gmail.com> (sfid-20130321_234813_486314_276337D1)
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Fri, Mar 22, 2013 at 4:11 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/b43/phy_n.c |   92 ++++++++------------------------------
>  1 file changed, 18 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 3c35382..4130c04 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -5220,19 +5150,33 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
>
>         if (dev->phy.rev >= 3 &&
>             dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
> -               bool avoid = false;
> +               struct bcma_drv_cc __maybe_unused *cc;

Could this go inside the #ifdef in the switch statement - that way the
__maybe_unused should be unnecessary?

> +               int avoid = 0;

I though that bools were converted to ints exactly as you've converted
the avoid variable here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
