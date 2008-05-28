Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:44047 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYE1S4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 14:56:44 -0400
Received: from [192.168.1.10] ([71.191.33.184]) by vms173001.mailsrvcs.net
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 with ESMTPA id <0K1L00HMTAL8LX70@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Wed, 28 May 2008 12:43:57 -0500 (CDT)
Date: Wed, 28 May 2008 13:43:56 -0400
From: Dad <ccmcphe@verizon.net>
Subject: Compatibility Issues with compat-wireless-2008-05-22
To: linux-wireless@vger.kernel.org
Message-id: <483D99DC.4020909@verizon.net> (sfid-20080528_205655_754331_A0C85EA8)
MIME-version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am building with kernel 2.6.22-14 and I have some build problems with=
=20
any compat-wireless build past 05-21. The builds show a problem with th=
e=20
function skb_get_queue_mapping not being defined and a define=20
NETIF_F_MULTI_QUEUE not being defined. Complete list is below. I have=20
checked my linux source and includes for theses references and cannot=20
find them anywhere. Is there a way to make the builds compatable?

Complete make output:

root@ubuntu:~/compat-wireless-2008-05-25# make
=2E/scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_aut=
oconf.h
make -C /lib/modules/2.6.22-14-generic/build=20
M=3D/home/ccmcphe/compat-wireless-2008-05-25 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
LD /home/ccmcphe/compat-wireless-2008-05-25/drivers/misc/built-in.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/misc/eeprom_93c=
x6.o
LD /home/ccmcphe/compat-wireless-2008-05-25/drivers/net/usb/built-in.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/net/usb/rndis_h=
ost.o
LD /home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/built-=
in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ipw2100.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ipw2200.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/at76_usb.=
o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/at76_usb.=
c:878:=20
warning: =91at76_set_associd=92 defined but not used
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/at76_usb.=
c:896:=20
warning: =91at76_set_listen_interval=92 defined but not used
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/at76_usb.=
c:982:=20
warning: =91at76_add_mac_address=92 defined but not used
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rndis_wla=
n.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_d=
ev.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_d=
ev.c:=20
In function =91rtl8180_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_d=
ev.c:249:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_r=
tl8225.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_s=
a2400.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_m=
ax2820.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180_g=
rf5101.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8187_d=
ev.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8187_r=
tl8225.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8180.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rtl8187.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/adm8211.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/bui=
lt-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/bas=
e.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/bas=
e.c:=20
In function =91ath5k_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/bas=
e.c:2660:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/hw.=
o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/ini=
tvals.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/phy=
=2Eo
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/ath5k/ath=
5k.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/built=
-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/main.=
o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/table=
s.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/phy.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/sysfs=
=2Eo
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/xmit.=
o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/lo.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/wa.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/dma.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/dma.c=
:=20
In function =91b43_dma_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/dma.c=
:1301:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/pio.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/pio.c=
:=20
In function =91b43_pio_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/pio.c=
:512:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/leds.=
o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/pcmci=
a.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43/b43.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/built-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/main.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/ilt.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/phy.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/radio.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/sysfs.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/xmit.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/dma.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/dma.c:=20
In function =91b43legacy_dma_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/dma.c:1331:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/pio.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/b43legacy=
/b43legacy.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/b=
uilt-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl3945-base.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl3945-base.c:=20
In function =91iwl3945_tx_skb=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl3945-base.c:2555:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-3945.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-3945-rs.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl4965-base.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl4965-base.c:49:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-4965.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-4965.c:42:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-4965-rs.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-4965-rs.c:40:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-core.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-core.c:37:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-core.c:37:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-eeprom.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-eeprom.c:72:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-eeprom.c:72:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-hcmd.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-hcmd.c:34:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-hcmd.c:34:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-power.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-power.c:38:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-power.c:38:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rx.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rx.c:32:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rx.c:32:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-tx.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-tx.c:33:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-tx.c:=20
In function =91iwl_tx_skb=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-tx.c:699:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-tx.c:33:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-sta.o
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-sta.c:34:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
In file included from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-rfkill.h:34,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-dev.h:40,
from=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl-sta.c:34:
include/linux/input.h:924:1: warning: "BIT" redefined
In file included from include/linux/kernel.h:15,
from /home/ccmcphe/compat-wireless-2008-05-25/include/net/compat.h:5,
from <command line>:1:
/home/ccmcphe/compat-wireless-2008-05-25/include/linux/bitops.h:7:1:=20
warning: this is the location of the previous definition
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wlcore.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl3945.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/iwlwifi/i=
wl4965.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
built-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
main.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
wext.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
rx.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
tx.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
cmd.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
cmd.c:=20
In function =91lbs_set_channel=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
cmd.c:807:=20
warning: unused variable =91old_channel=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
cmdresp.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
scan.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
11d.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
debugfs.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
persistcfg.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
ethtool.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
assoc.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
if_cs.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
if_usb.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
libertas.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
usb8xxx.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/libertas/=
libertas_cs.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/built=
-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/p54co=
mmon.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/p54co=
mmon.c:=20
In function =91p54_rx_frame_sent=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/p54co=
mmon.c:410:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/p54us=
b.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/p54/p54pc=
i.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/bu=
ilt-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00dev.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00mac.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00mac.c:=20
In function =91rt2x00mac_tx=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00mac.c:105:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00config.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00queue.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00firmware.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00lib.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00pci.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00pci.c:=20
In function =91rt2x00pci_txdone=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00pci.c:166:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00usb.o
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00usb.c:=20
In function =91rt2x00usb_interrupt_txdone=92:
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2x00usb.c:134:=20
warning: implicit declaration of function =91skb_get_queue_mapping=92
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2400pci.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2500pci.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
61pci.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
2500usb.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/rt2x00/rt=
73usb.o
LD=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
built-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_chip.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_ieee80211.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_mac.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_rf_al2230.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_rf_rf2959.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_rf_al7230b.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_rf_uw2453.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_rf.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd_usb.o
LD [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/net/wireless/zd1211rw/=
zd1211rw.o
LD /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/built-in.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/main.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/scan.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/sprom.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/pci.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/pcihost_wrapper.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/pcmcia.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/driver_chipcommon.=
o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/driver_pcic=
ore.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/b43_pci_bri=
dge.o
LD [M] /home/ccmcphe/compat-wireless-2008-05-25/drivers/ssb/ssb.o
LD /home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/built-in.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_module=
=2Eo
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211=
_tx.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211=
_rx.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211=
_wx.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_geo.o
LD [M] /home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211=
=2Eo
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_crypt.=
o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_crypt_=
wep.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_crypt_=
ccmp.o
CC [M]=20
/home/ccmcphe/compat-wireless-2008-05-25/net/ieee80211/ieee80211_crypt_=
tkip.o
LD /home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/built-in.o
CC [M] /home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.o
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c: In=20
function =91ieee80211_register_hw=92:
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c:1666:=20
warning: implicit declaration of function =91alloc_netdev_mq=92
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c:1668:=20
warning: assignment makes pointer from integer without a cast
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c:1673:=20
error: =91NETIF_F_MULTI_QUEUE=92 undeclared (first use in this function=
)
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c:1673:=20
error: (Each undeclared identifier is reported only once
/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.c:1673:=20
error: for each function it appears in.)
make[3]: ***=20
[/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211/main.o] Error 1
make[2]: *** [/home/ccmcphe/compat-wireless-2008-05-25/net/mac80211] Er=
ror 2
make[1]: *** [_module_/home/ccmcphe/compat-wireless-2008-05-25] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
make: *** [modules] Error 2
root@ubuntu:~/compat-wireless-2008-05-25#

Thanks in advance
Tex


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
