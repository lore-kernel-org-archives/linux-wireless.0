Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64647 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2BATj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 14:39:59 -0500
Received: by pbdu11 with SMTP id u11so1355038pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 11:39:58 -0800 (PST)
MIME-Version: 1.0
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Wed, 1 Feb 2012 20:32:38 +0100
Message-ID: <CAO=xpBFTW5b1iLnYbX7KQrjEdO0MKX86+8wooEF=DJz=+UJXZw@mail.gmail.com> (sfid-20120201_204003_217657_D2F3AA35)
Subject: can't compile latest compat-wireless under kernel 3.2 even using git
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tried to download and compile compat-wireless from git:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git clone git://github.com/mcgrof/compat.git
git clone git://github.com/mcgrof/compat-wireless.git

export GIT_TREE=/storage/wireless/linux-next/
export GIT_COMPAT_TREE=/storage/wireless/compat/

cd compat-wireless-2.6

./scripts/admin-clean.sh
./scripts/admin-update.sh (this command is successful)
./scripts/driver-select
./scripts/driver-select rt2x00

make

I get the "same" error:

$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/3.2.0-interlaced2+/build
M=/storage/wireless/compat-wireless modules
make[1]: Entering directory `/home/alfonso/tests/kernel/linux_keithp'
  LD      /storage/wireless/compat-wireless/compat/built-in.o
  CC [M]  /storage/wireless/compat-wireless/compat/main.o
In file included from
/storage/wireless/compat-wireless/include/linux/compat-2.6.h:40:0,
                 from <command-line>:0:
/storage/wireless/compat-wireless/include/linux/compat-3.3.h:11:20:
error: static declaration of âskb_complete_wifi_ackâ follows
non-static declaration
include/linux/skbuff.h:2260:6: note: previous declaration of
âskb_complete_wifi_ackâ was here
/storage/wireless/compat-wireless/include/linux/compat-3.3.h:17:13:
error: conflicting types for ânetdev_features_tâ
include/linux/netdev_features.h:15:13: note: previous declaration of
ânetdev_features_tâ was here
make[3]: *** [/storage/wireless/compat-wireless/compat/main.o] Error 1
make[2]: *** [/storage/wireless/compat-wireless/compat] Error 2
make[1]: *** [_module_/storage/wireless/compat-wireless] Error 2
make[1]: Leaving directory `/home/alfonso/tests/kernel/linux_keithp'
make: *** [modules] Error 2

Any help is greatly appreciated.

regards,
alfonso
