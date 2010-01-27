Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55569 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0A0SGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 13:06:36 -0500
Received: by pwi21 with SMTP id 21so3899623pwi.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 10:06:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
	<43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
	<47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jan 2010 10:06:15 -0800
Message-ID: <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com>
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC
	architecture
To: PAN Sunny S K <sunnypan@ust.hk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 2:48 AM, PAN Sunny S K <sunnypan@ust.hk> wrote:
> Hi,
>
> Thanks Pavel, Xiao and especially Luis for their quick reply.
> So as suggested, I'll firstly try to build the latest compat-wireless
> driver with the 2.6.25 kernel. And update the kernel to 2.6.34 as the last
> attempt which requires support from Freescale.
>
> Let me briefly mention a little background and the problem I've
> encountered when building the driver.
>
> Our project is base on a Freescale MPC8377EWLAN reference design which
> runs by a MPC8377 PowerQUICC II PowerPC processor. It uses LTIB to develop
> and deploy BSP for this architecture and the Linux kernel version provided
> is 2.6.25 (a slightly patched kernel to adapt the processor) The wireless
> interface we're using is Wistron DNMA-83 (equivalent to Unex DNMA-83)
> which uses Atheros AR9160 chipset.
>
> To fully utilize the 802.11 a/b/g/n mode provided by the chipset (and the
> proprietary driver came with the package has too many problems), we look
> for the ath9k driver and would like to build it with the 2.6.25 kernel.
>
> So what I did to build the driver is to provide the KLIB and KLIB_BUILD
> with the path of 2.6.25 source and modified the CROSS_COMPILE variable in
> the .config of the kernel to make sure it uses the MPC8377 toolchain to
> compile the source. However, the following error occurred (With my latest
> trial of the bleeding edge compat-wireless-2.6):
>
> make -C /MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25
> M=/root/Desktop/compat-wireless-2009-12-11 modules
> make[1]: Entering directory


compat-wireless-2009-12-11 is from a bleeding edge snapshot. Bleedign
edge snapshots
do not yet have MQ support backported, but MQ support was not merged
by then, so hmm...

OK try this:

./scripts/driver-select ath9k

That will only enable to compile ath9k.

If you hit a debugfs compile error then you've hit the other blocker
from backporting down to 2.6.23 on bleedigng edge.

If you want to try something that actually does compile for sure
against 2.6.25 try the stable compat-wireless for 2.6.32.5 and use
./scripts/driver-select:

http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.32.5-rc3.tar.bz2

  Luis
