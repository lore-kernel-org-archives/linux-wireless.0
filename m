Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:47835 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LCVZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 16:25:14 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: rt2500usb/ kernel 3.7+: WARNING: at net/wireless/core.c:389 wiphy_register+0x3fd/0x431 [cfg80211]()
Date: Mon, 3 Dec 2012 22:25:03 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201212031611.57351.s.L-H@gmx.de> <CAGXE3d-xwQArEMM030ht04JDJueHTX3YJp+O6Mmt+LVaPpp1Cg@mail.gmail.com>
In-Reply-To: <CAGXE3d-xwQArEMM030ht04JDJueHTX3YJp+O6Mmt+LVaPpp1Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212032225.08618.s.L-H@gmx.de> (sfid-20121203_222519_017666_88D87D9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Monday 03 December 2012, Helmut Schaa wrote:
> On Mon, Dec 3, 2012 at 4:11 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> > Using kernel v3.7-rc7-176-g7e5530a (current mainline HEAD), I notice
> > the following WARN_ON() triggering with rt2500usb and no wireless
> > interface appears.
> 
> Mind to try the patch below?
[…]

Thanks a lot, this patch works perfectly.

> From 4e4223674e2e76ca7a8e449fccd1e0a2d326fc7b Mon Sep 17 00:00:00 2001
> From: Helmut Schaa <helmut.schaa@googlemail.com>
> Date: Mon, 3 Dec 2012 19:45:42 +0100
> Subject: [PATCH] rt2x00: Only specify interface combinations if more then one
>  interface is possible
> 
> Otherwise this triggers a warning in cfg80211, from net/wireless/core.c:
> 
> 	/* Combinations with just one interface aren't real */
> 	if (WARN_ON(c->max_interfaces < 2))
> 
> This was introduced in commit 55d2e9da744ba11eae900b4bfc2da72eace3c1e1:
> rt2x00: Replace open coded interface checking with interface combinations.
> 
> Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

perhaps also
Cc: stable@vger.kernel.org	# v3.7
as it might not reach Linus in time for v3.7

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 69097d1..dafb448 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1123,6 +1123,9 @@ static inline void
> rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
  ^whitespace damage

Regards
	Stefan Lippers-Hollmann
