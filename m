Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42042 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab2BAUQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 15:16:17 -0500
Message-ID: <4F299D85.3080906@hauke-m.de> (sfid-20120201_211620_752594_86A0187A)
Date: Wed, 01 Feb 2012 21:16:05 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Alfonso Fiore <alfonso.fiore@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: can't compile latest compat-wireless under kernel 3.2 even using
 git
References: <CAO=xpBFTW5b1iLnYbX7KQrjEdO0MKX86+8wooEF=DJz=+UJXZw@mail.gmail.com>
In-Reply-To: <CAO=xpBFTW5b1iLnYbX7KQrjEdO0MKX86+8wooEF=DJz=+UJXZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 08:32 PM, Alfonso Fiore wrote:
> Hi,
> 
> I tried to download and compile compat-wireless from git:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> git clone git://github.com/mcgrof/compat.git
> git clone git://github.com/mcgrof/compat-wireless.git
> 
> export GIT_TREE=/storage/wireless/linux-next/
> export GIT_COMPAT_TREE=/storage/wireless/compat/
> 
> cd compat-wireless-2.6
> 
> ./scripts/admin-clean.sh
> ./scripts/admin-update.sh (this command is successful)
> ./scripts/driver-select
> ./scripts/driver-select rt2x00
This is all correct.
> 
> make
> 
> I get the "same" error:
> 
> $ make
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/3.2.0-interlaced2+/build
> M=/storage/wireless/compat-wireless modules
> make[1]: Entering directory `/home/alfonso/tests/kernel/linux_keithp'
>   LD      /storage/wireless/compat-wireless/compat/built-in.o
>   CC [M]  /storage/wireless/compat-wireless/compat/main.o
> In file included from
> /storage/wireless/compat-wireless/include/linux/compat-2.6.h:40:0,
>                  from <command-line>:0:
> /storage/wireless/compat-wireless/include/linux/compat-3.3.h:11:20:
> error: static declaration of âskb_complete_wifi_ackâ follows
> non-static declaration
> include/linux/skbuff.h:2260:6: note: previous declaration of
> âskb_complete_wifi_ackâ was here
> /storage/wireless/compat-wireless/include/linux/compat-3.3.h:17:13:
> error: conflicting types for ânetdev_features_tâ
> include/linux/netdev_features.h:15:13: note: previous declaration of
> ânetdev_features_tâ was here
> make[3]: *** [/storage/wireless/compat-wireless/compat/main.o] Error 1
> make[2]: *** [/storage/wireless/compat-wireless/compat] Error 2
> make[1]: *** [_module_/storage/wireless/compat-wireless] Error 2
> make[1]: Leaving directory `/home/alfonso/tests/kernel/linux_keithp'
> make: *** [modules] Error 2
> 
> Any help is greatly appreciated.
> 
> regards,
> alfonso
What kernel are you compiling against? skb_complete_wifi_ack() is not
declared in linux kernel 3.2.2, just in 3.3-rc2. It looks like the
kernel you are compiling against has some modifications conflicting with
compat-wireless.

Hauke
