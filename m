Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:39884 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeIIVxm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 17:53:42 -0400
Received: by mail-oi0-f67.google.com with SMTP id c190-v6so35850538oig.6
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 10:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <385bc6f25c5d82d2c36c518dbea8f76b@varna.net>
In-Reply-To: <385bc6f25c5d82d2c36c518dbea8f76b@varna.net>
From: Rami Rosen <roszenrami@gmail.com>
Date: Sun, 9 Sep 2018 20:03:13 +0300
Message-ID: <CAKoUArkrfS=KiL=Rc5wbOrcdZ11zZB60hGOmgb7WST8d6V5FOw@mail.gmail.com> (sfid-20180909_190328_834401_FC105E10)
Subject: Re: Troubleshooting compilation of hostapd
To: pavlin@varna.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Pavlin,
Please try from scratch cloning the tree from scratch, then
cp defconfig .config, then
uncomment the following entry in .config:
CONFIG_LIBNL32=y
and then run "make", and post here the results.

Regards,
Rami Rosen
http://ramirose.wixsite.com/ramirosen


On Sun, 9 Sep 2018 at 16:57, <pavlin@varna.net> wrote:
>
> Hi,
>
> I work as a software tester who has general understanding of C++
> language.
> I experiment with simulated Wi-Fi access point and a station.
>
> My Linux distribution is Fedora 27.
>
> I try to compile hostap by following the steps from:
> https://wireless.wiki.kernel.org/en/users/documentation/hostapd#download_and_compile_hostapd
>
> I get the source code from:
> git://w1.fi/srv/git/hostap.git
>
> I create a configuration:
> cp defconfig .config
> vi .config
>
> Parameter "CONFIG_DRIVER_NL80211=y" is already uncomented.
>
> make
>
> ../src/drivers/driver_nl80211.c:17:10: fatal error: netlink/genl/genl.h:
> No such file or directory
>   #include <netlink/genl/genl.h>
>            ^~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make: *** [Makefile:1251: ../src/drivers/driver_nl80211.o] Error 1
>
> When I search for file "genl.h"
> then I don't find it on my system.
>
> I search for package "libnl", but only "libnl3" is available.
> I install it:
> yum install libnl3 libnl3-devel
>
>
> I repeat the previous compilation.
> I receive the same error.
>
> When I search for "genl.h"
> then I find it in "/usr/include/libnl3/netlink/genl/genl.h".
>
> The source file "../src/drivers/driver_nl80211.c"
> includes "netlink/genl/genl.h".
>
> To satisfy that requirement I create a soft link:
> ln -s /usr/include/libnl3/netlink /usr/include/netlink
>
> When I rebegin the compilation:
> make clean
> make
> then I receive error:
> /usr/bin/ld: cannot find -lnl
> collect2: error: ld returned 1 exit status
> make: *** [Makefile:1278: hostapd] Error 1
>
>
> When I browse StackOverflow
>   and I search for "/usr/bin/ld: cannot find -lnl"
> then I find article
> "https://stackoverflow.com/questions/16710047/usr-bin-ld-cannot-find-lnameofthelibrary".
>
> When I follow the steps from that article
> then I receive result:
> ==================================================
> attempt to open //usr/x86_64-redhat-linux/lib64/libnl.so failed
> attempt to open //usr/x86_64-redhat-linux/lib64/libnl.a failed
> attempt to open //usr/lib64/libnl.so failed
> attempt to open //usr/lib64/libnl.a failed
> attempt to open //usr/local/lib64/libnl.so failed
> attempt to open //usr/local/lib64/libnl.a failed
> attempt to open //lib64/libnl.so failed
> attempt to open //lib64/libnl.a failed
> attempt to open //usr/x86_64-redhat-linux/lib/libnl.so failed
> attempt to open //usr/x86_64-redhat-linux/lib/libnl.a failed
> attempt to open //usr/local/lib/libnl.so failed
> attempt to open //usr/local/lib/libnl.a failed
> attempt to open //lib/libnl.so failed
> attempt to open //lib/libnl.a failed
> attempt to open //usr/lib/libnl.so failed
> attempt to open //usr/lib/libnl.a failed
> ld: cannot find -lnl
>
>
> QUESTIONS
> 1. What steps to follow in order to compile hostap?
> 2. Can you please update the documentation at
> "https://wireless.wiki.kernel.org/en/users/documentation/hostapd#download_and_compile_hostapd"
> to the latest release of Fedora?
>
>
> DETAILS
> kernel-4.13.16-302.fc27.x86_64
> gcc-7.3.1-6.fc27.x86_64
> rpm -qf $(which /usr/bin/ld)
>      binutils-2.29-6.fc27.x86_64
>      binutils-2.29-13.fc27.x86_64
>
> yum search libnl
>      ================== Name & Summary Matched: libnl ==================
>      libnl3-doc.x86_64 : API documentation for libnl3
>      python-libnl3.x86_64 : libnl3 binding for Python 2
>      python2-libnl3.x86_64 : libnl3 binding for Python 2
>      python3-libnl3.x86_64 : libnl3 binding for Python 3
>      libnl3-cli.x86_64 : Command line interface utils for libnl3
>      libnl3-cli.i686 : Command line interface utils for libnl3
>      libnl3-devel.x86_64 : Libraries and headers for using libnl3
>      libnl3-devel.i686 : Libraries and headers for using libnl3
>      ======================= Name Matched: libnl =======================
>      libnl3.x86_64 : Convenience library for kernel netlink sockets
>      libnl3.i686 : Convenience library for kernel netlink sockets
