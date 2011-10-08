Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1JHITt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 04:19:49 -0400
Received: by bkbzt4 with SMTP id zt4so5844093bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 01:19:48 -0700 (PDT)
MIME-Version: 1.0
From: matteo filippetto <matteo.filippetto@gmail.com>
Date: Sat, 8 Oct 2011 10:19:28 +0200
Message-ID: <CAP+0xm6nwpmbk=mh0rFGZR6gnTRSUTNK_rhkZQn24RFWP_13Pg@mail.gmail.com> (sfid-20111008_101956_031532_24927DE8)
Subject: can't make compat-wireless-3.1-rc8-1
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I try to make compat-wireless-3.1-rc8-1 but I get error on net/wireless/util.c

/home/matteo/Downloads/compat-wireless-3.1-rc8-1-org/net/wireless/util.c:
In function ‘cfg80211_change_iface’:
/home/matteo/Downloads/compat-wireless-3.1-rc8-1-org/net/wireless/util.c:804:2:
error: implicit declaration of function ‘br_port_exists’
make[3]: *** [/home/matteo/Downloads/compat-wireless-3.1-rc8-1-org/net/wireless/util.o]
Error 1
make[2]: *** [/home/matteo/Downloads/compat-wireless-3.1-rc8-1-org/net/wireless]
Error 2
make[1]: *** [_module_/home/matteo/Downloads/compat-wireless-3.1-rc8-1-org]
Error 2
make[1]: Leaving directory `/usr/src/torvalds-linux-a8062e4'
make: *** [modules] Error 2

It' s a problem with the definition of br_port_exists. I solved inserting

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
#else
#define br_port_exists(dev)	(dev->br_port)
#endif

in net/wireless/core.h but I don't think it's the right way to solve this issue.

I try to include "include/linux/compat-3.1.h" in util.c but without success.

Regards
-- 
Matteo Filippetto
http://www.op83.eu
