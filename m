Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030226Ab2LFJJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:09:22 -0500
Date: Thu, 6 Dec 2012 10:09:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: rt2500usb/ kernel 3.7+: WARNING: at net/wireless/core.c:389
 wiphy_register+0x3fd/0x431 [cfg80211]()
Message-ID: <20121206090911.GF2502@redhat.com> (sfid-20121206_100927_929480_1DB65A1B)
References: <201212031611.57351.s.L-H@gmx.de>
 <CAGXE3d-xwQArEMM030ht04JDJueHTX3YJp+O6Mmt+LVaPpp1Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-xwQArEMM030ht04JDJueHTX3YJp+O6Mmt+LVaPpp1Cg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 03, 2012 at 07:53:06PM +0100, Helmut Schaa wrote:
> On Mon, Dec 3, 2012 at 4:11 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> > Using kernel v3.7-rc7-176-g7e5530a (current mainline HEAD), I notice
> > the following WARN_ON() triggering with rt2500usb and no wireless
> > interface appears.
> 
> Mind to try the patch below?
> 
> Thanks,
> Helmut
> 
> 
> 
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
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch should be probably reposted to get applied by John ...

Stanislaw
