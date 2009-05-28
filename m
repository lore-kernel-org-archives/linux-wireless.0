Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:55656 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZE1Oke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 10:40:34 -0400
Received: by yx-out-2324.google.com with SMTP id 3so3044108yxj.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 07:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090528085555.GA20314@jm.kir.nu>
References: <45e8e6c40905271630x39bcfca6w72560150222e7960@mail.gmail.com>
	 <20090528085555.GA20314@jm.kir.nu>
Date: Thu, 28 May 2009 07:40:36 -0700
Message-ID: <45e8e6c40905280740i3ed1c25dkd0b1a86fe791f3b9@mail.gmail.com>
Subject: Re: ath9k locks up when bringing up a mesh point interface
From: Andrey Yurovsky <andrey@cozybit.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 1:55 AM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, May 27, 2009 at 04:30:17PM -0700, Andrey Yurovsky wrote:
>> With today's wireless-testing, bring up an ath9k mesh point locks up
>> my test laptop (single CPU) but I don't get any messages (/proc/sysrq
>> set to 9, unfortunately I can't use a serial console right now).
>
> I don't see a full lockup with two cores, but "ifconfig mesh0 up"
> process ends up in some kind of unkillable state eating all CPU.. I
> would assume this could be the same issue that just happens to show up
> more severe with a single CPU.
>
> dmesg is not showing anything else apart from "mesh: running mesh
> housekeeping" popping up every 60 seconds. Pretty much all networking
> commands hang (rtnl lock held?) after that, though. After some while,
> hung task debugging does indeed start popping up messages that show
> rtnl_mutex held, so that's why the system is getting quite unusable.
>
> Anyway, I don't know what exactly is killing the mp setup (or well, not
> exactly killing, but more like causing a busy loop somewhere) or whether
> it has anything to do with the driver, but at least this one seems to be
> trivial to reproduce:
>
> modprobe ath9k
> iw phy phy0 interface add mesh0 type mp mesh_id foo
> ifconfig mesh0 up
>
> --
> Jouni Malinen                                            PGP id EFC895FA
>

Thanks.  For what it's worth, substituting rt2x00 for ath9k works (ie:
one can bring up a mesh) on the same kernel, so it likely has
something to do with the driver.

  -Andrey
