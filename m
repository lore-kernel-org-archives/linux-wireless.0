Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35751 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316AbZE1Iz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 04:55:59 -0400
Date: Thu, 28 May 2009 11:55:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: ath9k locks up when bringing up a mesh point interface
Message-ID: <20090528085555.GA20314@jm.kir.nu>
References: <45e8e6c40905271630x39bcfca6w72560150222e7960@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45e8e6c40905271630x39bcfca6w72560150222e7960@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 04:30:17PM -0700, Andrey Yurovsky wrote:
> With today's wireless-testing, bring up an ath9k mesh point locks up
> my test laptop (single CPU) but I don't get any messages (/proc/sysrq
> set to 9, unfortunately I can't use a serial console right now).

I don't see a full lockup with two cores, but "ifconfig mesh0 up"
process ends up in some kind of unkillable state eating all CPU.. I
would assume this could be the same issue that just happens to show up
more severe with a single CPU.

dmesg is not showing anything else apart from "mesh: running mesh
housekeeping" popping up every 60 seconds. Pretty much all networking
commands hang (rtnl lock held?) after that, though. After some while,
hung task debugging does indeed start popping up messages that show
rtnl_mutex held, so that's why the system is getting quite unusable.

Anyway, I don't know what exactly is killing the mp setup (or well, not
exactly killing, but more like causing a busy loop somewhere) or whether
it has anything to do with the driver, but at least this one seems to be
trivial to reproduce:

modprobe ath9k
iw phy phy0 interface add mesh0 type mp mesh_id foo
ifconfig mesh0 up

-- 
Jouni Malinen                                            PGP id EFC895FA
