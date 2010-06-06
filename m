Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47601 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0FFRrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 13:47:25 -0400
Received: by vws5 with SMTP id 5so2286876vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jun 2010 10:47:24 -0700 (PDT)
Message-ID: <4C0BDF2F.2020001@gmail.com>
Date: Sun, 06 Jun 2010 13:47:27 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	gwingerde@gmail.com, "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: compat-wireless 2.6.35_rc2 build errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I realize we are still pretty early in the rc process but there are some 
seemingly significant problems building compat-wireless 2.6.35_rc2 
(which should be very close if not identical to the linus tree). I have 
copied the rt2x00 team because of the first error and Luiz for the second.

First and foremost this won't build at all:

/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/rt2x00/rt2800pci.c: 
In function 'rt2800pci_read_eeprom_soc':
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/rt2x00/rt2800pci.c:91: 
error: implicit declaration of function 'KSEG1ADDR'
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/rt2x00/rt2800pci.c:91: 
warning: cast to pointer from integer of different size
make[4]: *** 
[/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/rt2x00/rt2800pci.o] 
Error 1


Additionally but likely less important this driver seems to be defining 
variables overriding kernel headers, I can't imagine that is good.  Not 
sure if this is something that the driver needs to fix or needs to be 
fixed in compat-wireless but here it is:

/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/libertas_tf/main.c:10:1: 
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.29.h:5,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/kernel.h:376:1: warning: this is the location of the 
previous definition
  CC [M]  
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/orinoco/main.o
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/libertas_tf/main.c:10:1: 
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.29.h:5,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/kernel.h:376:1: warning: this is the location of the 
previous definition
  CC [M]  
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/libertas_tf/cmd.o
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/libertas_tf/cmd.c:10:1: 
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.29.h:5,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/kernel.h:376:1: warning: this is the location of the 
previous definition
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/drivers/net/wireless/libertas_tf/cmd.c:10:1: 
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.29.h:5,
                 from 
/var/tmp/portage/net-wireless/compat-wireless-2.6.35_rc2/work/compat-wireless-2.6.35-rc2/include/linux/compat-2.6.h:24,
                 from <command-line>:0:

I'll try to build the rc2 kernel and see if these errors are the same.

Thanks,
Rick Farina
