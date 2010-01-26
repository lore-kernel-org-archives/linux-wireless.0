Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36749 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AZQxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 11:53:54 -0500
Received: by pwi21 with SMTP id 21so3081074pwi.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 08:53:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Jan 2010 08:53:34 -0800
Message-ID: <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC
	architecture
To: PAN Sunny S K <sunnypan@ust.hk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:44 PM, PAN Sunny S K <sunnypan@ust.hk> wrote:
>And how can I solve the building problem between the
> compat-wireless-old and the 2.6.25 kernel?

compat-wireless-old is deprecated. I forked off a new compat-wireless
since mac80211 added multiqueue support a while ago, but recently
compat-wireless started to get support for older kernels again because
mac80211 stopped using the multiqueue support. By default the stable
compat-wireless releases up to the ones based on 2.6.32.3 had support
for kernels >= 2.6.25. Then if you enable only ath5k or ath9k you can
go even lower, to 2.6.23.

This all changed again for 2.6.32.4 where mac80211 once again
re-enabled multiqueue support but I did make an attempt to actually
backport that this time [1] down to 2.6.23 and actually even lower
kernels. That release hasn't been tested yet though so I'm waiting to
hear about results. I may get a chance to test a 2.6.23 kernel with
that snapshot at some point today, we'll see.

So apart from compat-wireless though you actually need the full SoC
support though and that is provided by openwrt but I am not sure down
to what kernel that is backported to. In any case you are better off
just upgrading to a newer kernel as others recommend.

[1] http://marc.info/?l=linux-wireless&m=126420655321607&w=2

  Luis
