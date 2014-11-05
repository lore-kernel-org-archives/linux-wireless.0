Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35626 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKEW6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 17:58:07 -0500
Received: by mail-ig0-f180.google.com with SMTP id h3so2339467igd.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 14:58:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415226667-28207-1-git-send-email-hauke@hauke-m.de>
References: <1415226667-28207-1-git-send-email-hauke@hauke-m.de>
Date: Wed, 5 Nov 2014 23:58:05 +0100
Message-ID: <CACna6rzxFoNCx7W5-20WijWQkQRQgsmis6-Yb4iXud7EYJEZqw@mail.gmail.com> (sfid-20141105_235811_298383_0700EB62)
Subject: Re: [PATCH 3.18+] b43: fix NULL pointer dereference in b43_phy_copy()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	andrey.krieger.utkin@gmail.com, v.kempter@pe.tu-clausthal.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 November 2014 23:31, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> phy_read and phy_write are not set for every phy any more sine this:
> commit d342b95dd735014a590f9051b1ba227eb54ca8f6
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Thu Jul 31 21:59:43 2014 +0200
>
>     b43: don't duplicate common PHY read/write ops
>
> b43_phy_copy() accesses phy_read and phy_write directly and will fail
> with some phys. This patch fixes the regression by using the
> b43_phy_read() and b43_phy_write() functions which should be used for
> read and write access.
>
> This should fix this bug report:
> https://bugzilla.kernel.org/show_bug.cgi?id=87731
>
> Reported-by: Volker Kempter <v.kempter@pe.tu-clausthal.de>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/b43/phy_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> This should go into wireless-testing and into 3.18 as it fixes a
> regression in 3.18.
>
> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> index 1dfc682..3f37401 100644
> --- a/drivers/net/wireless/b43/phy_common.c
> +++ b/drivers/net/wireless/b43/phy_common.c
> @@ -301,8 +301,7 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
>  void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
>  {
>         assert_mac_suspended(dev);
> -       dev->phy.ops->phy_write(dev, destreg,
> -               dev->phy.ops->phy_read(dev, srcreg));
> +       b43_phy_write(dev, destreg, b43_phy_read(dev, srcreg));
>  }

Could you drop the assert_mac_suspended? We do it already in both:
phy_read and phy_write.
