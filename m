Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tinet.org ([195.77.216.130]:53439 "EHLO mail.tinet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYERRyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 13:54:04 -0400
Received: from webmail.tinet.org ([195.77.216.133])
          (envelope-sender <xdrudis@tinet.cat>)
          by mail.tinet.org (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2008 17:47:20 -0000
Message-ID: <52420.80.224.39.3.1211132840.squirrel@webmail.tinet.org> (sfid-20080518_195410_029953_B6A0490E)
Date: Sun, 18 May 2008 19:47:20 +0200 (CEST)
Subject: Problems building iwl for 2.6.25 (dev_name and CONFIG_IWLWIFI not
     defined)
From: "Xavi Drudis Ferran" <xdrudis@tinet.cat>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, and thanks for your work.

I'm trying to compile compat-wireless-2008-05-18
on a Debian sid, with a custom kernel 2.6.25 (it's the
debian source tree with just custom config, not
custom code). I wanted to try the latest iwl3945 driver.

It fails in b43, like this

  LD [M]  /home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/ath5k/ath5k.o
  LD      /home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43/built-in.o
  CC [M]  /home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43/main.o
/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43/main.c: In function 'handle_irq_noise':
/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43/main.c:1185: error: implicit declaration of function 'clamp_val'
make[4]: *** [/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43/main.o] Error 1
make[3]: *** [/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43] Error 2
make[2]: *** [/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/crovirab/compat-wireless-2008-05-18] Error 2
make[1]: Leaving directory `/home/crovirab/linux/linux-source-2.6.25'
make: *** [modules] Error 2

But since I don't need b43, I disable it in config.mk
CONFIG_B43=n

make clean
make

Then it complains of
  CC [M]  /home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43legacy/main.o
/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43legacy/main.c: In function 'handle_irq_noise':
/home/crovirab/compat-wireless-2008-05-18/drivers/net/wireless/b43legacy/main.c:849: error: implicit declaration of function 'clamp_val'
m

so I change in config.mk
CONFIG_B43LEGACY=n

make clean and make again

And then I get stuck

 CC [M]  /home/crovirab/compat-wireless-2008-05-18/net/mac80211/rc80211_pid_algo.o
  LD [M]  /home/crovirab/compat-wireless-2008-05-18/net/mac80211/mac80211.o
  LD      /home/crovirab/compat-wireless-2008-05-18/net/wireless/built-in.o
  CC [M]  /home/crovirab/compat-wireless-2008-05-18/net/wireless/core.o
/home/crovirab/compat-wireless-2008-05-18/net/wireless/core.c: In function 'cfg80211_dev_rename':
/home/crovirab/compat-wireless-2008-05-18/net/wireless/core.c:170: error: implicit declaration of function 'dev_name'
/home/crovirab/compat-wireless-2008-05-18/net/wireless/core.c:170: warning: passing argument 2 of 'strcmp' makes pointer from integer without a cast
/home/crovirab/compat-wireless-2008-05-18/net/wireless/core.c:176: warning: passing argument 2 of 'strcmp' makes pointer from integer without a cast
make[3]: *** [/home/crovirab/compat-wireless-2008-05-18/net/wireless/core.o] Error 1
make[2]: *** [/home/crovirab/compat-wireless-2008-05-18/net/wireless] Error 2
make[1]: *** [_module_/home/crovirab/compat-wireless-2008-05-18] Error 2
make[1]: Leaving directory `/home/crovirab/linux/linux-source-2.6.25'
make: *** [modules] Error 2


I don't know a bit about compat-wireless, but it sounds as
I do need  /net/wireless/core.c , so I don't think I can't get
around this one.

Looking at the code, I see dev_name() defined in compat.h
like this


/* This is from include/linux/device.h, which was added as of 2.6.25 */
static inline const char *dev_name(struct device *dev)
{
	/* will be changed into kobject_name(&dev->kobj) in the near future */
	return dev->bus_id;
}


This is in an #ifdef that makes it ignored for me, since I'm running
2.6.25.

But in my kernel source tree I don't see that function in
include/linux/device.h

So I try to copy that definition of dev_name in another section
of compat.h and (one included for kernels < 2.6.26)

Then it compiles.

But it doesn't build iwl3945 (I realised when I saw complaints
of symbols on loading it, because it wasn't in update and it
was loading the debian kernel iwl3945, not the compat-wireless
one).

I see CONFIG_IWLWIFI is not defined in config.mk nor in my
kernel .config (CONFIG_IWL3945=m , but CONFIG_IWLWIFI does not
exist). So I add
CONFIG_IWLWIFI=y
to config.mk

Oh, I also set CONFIG_RT2XX=n because it gave some warnings
and I don't need it.


With all that I managed to compile and install the modules, and
I see them in /lib/modules/.../updates/...

And I got rid of some error messages I used to have (about bad
firmware and RX queue).

It does not associate with WPA (the configuration worked with
ipw3945 )
Without encryption it says it associates but it doesn't get IP
from DHCP nor can I ping if I set static iface config and routes


I see two messages which might be related to it when doing
/etc/init.d/networking restart

wmaster0: unknown hardware address type 801
wmaster0: unknown hardware address type 801

Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0


Btw, iwlist scanning works fine.

I'm out of time now for looking at it further. And it's not
my laptop, so I'm not sure I'll be able to insist later.

I'm just sending this for the build issues, at first I thought I must
be doing something odd to my .config or my debian kernel tree, and I
still may, but I unpacked it again and couldn't find any CONFIG_IWLWIFI in
.config or dev_name in include/linux/device.h . So I thought I'd write
just in case it can be improved so that it works more straightforward
in cases like mine. I don't dare sending a patch beacause I don't
think the changes I made are good solutions in general. I'll attach
my kernel config because maybe that's the problem.

Btw, the web page tells to send issues to this list, but it doesn't
point to archives or some other way to avoid duplicate reports,
I'm sorry if this is one.

Thanks, and keep up the good work.


