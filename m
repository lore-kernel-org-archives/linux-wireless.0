Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:45128 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3ASC07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 21:26:59 -0500
Received: by mail-qc0-f176.google.com with SMTP id n41so2779729qco.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 18:26:58 -0800 (PST)
Message-ID: <50FA04B6.8080703@gmail.com> (sfid-20130119_032736_343239_F74BDAE4)
Date: Fri, 18 Jan 2013 21:28:06 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: wireless@sipsolutions.net
Subject: Re: [ANN] crda: v1.1.3
References: <E1TwInB-0003VY-Jh@sipsolutions.net>
In-Reply-To: <E1TwInB-0003VY-Jh@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2013 03:44 PM, wireless@sipsolutions.net wrote:
> A new release of crda (v1.1.3) is available at:
> 
> http://wireless.kernel.org/download/crda/crda-1.1.3.tar.bz2
> 
> SHA1 sum: 6e0adbfc0f5418a03d7d708bd39d52cd1325b511
> 
> Here is the short log of the changes (since v1.1.2)
> included in this release:
> 
> Luis R. Rodriguez (15):
>       crda: synch up nl80211.h
>       crda: fix null string assumption for alpha2
>       crda: add support to send DFS master region
>       crda: use stdint.h instead of linux/types.h
>       crda: move country2rd() and its helper to reglib.c
>       crda: add a reglib iterator reglib_for_each_country()
>       crda: make intersect.c use reglib_for_each_country()
>       crda: close fd upon leaving
>       crda: add new reglib_get_country_alpha2()
>       crda: add dfs_region to the ieee80211_regdomain data structure
>       crda: make crda use reglib_get_country_alpha2()
>       crda: clean header files
>       crda: make country2rd() static
>       crda: make usage of regdb.h exclusive to reglib.c
>       crda: rename reglib_get_*() routines
> 
> Stefan Lippers-Hollmann (1):
>       crda: add nested support for libnl-3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I get three warnings when building that look like that may matter:

make -j5 -l4 UDEV_RULE_DIR=/lib/udev/rules.d
REG_BIN=/usr/lib64/crda/regulatory.bin USE_OPENSSL=1
CC=x86_64-pc-linux-gnu-gcc all_noverify V=1
x86_64-pc-linux-gnu-gcc -c  -Os -pipe -march=native
-frecord-gcc-switches -ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -o crda.o crda.c
x86_64-pc-linux-gnu-gcc -c  -Os -pipe -march=native
-frecord-gcc-switches -ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -o intersect.o
intersect.c
./utils/key2pub.py --ssl pubkeys/linville.key.pub.pem keys-ssl.c
x86_64-pc-linux-gnu-gcc -c  -Os -pipe -march=native
-frecord-gcc-switches -ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -o
print-regdom.o print-regdom.c
x86_64-pc-linux-gnu-gcc -c  -Os -pipe -march=native
-frecord-gcc-switches -ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -o regdbdump.o
regdbdump.c
x86_64-pc-linux-gnu-gcc -c  -Os -pipe -march=native
-frecord-gcc-switches -ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -o reglib.o
reglib.c
reglib.c: In function ‘country2rd’:
reglib.c:213:2: warning: implicit declaration of function ‘memset’
[-Wimplicit-function-declaration]
reglib.c:213:2: warning: incompatible implicit declaration of built-in
function ‘memset’ [enabled by default]
reglib.c: In function ‘reglib_get_rd_alpha2’:
reglib.c:344:3: warning: implicit declaration of function ‘memcmp’
[-Wimplicit-function-declaration]
x86_64-pc-linux-gnu-gcc -Os -pipe -march=native -frecord-gcc-switches
-ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -Wl,-O1
-Wl,--as-needed -Wl,--hash-style=gnu -o crda reglib.o crda.o `pkg-config
--libs openssl` -lnl-genl-3 -lnl-3   `pkg-config --libs libnl-3.0`
x86_64-pc-linux-gnu-gcc -Os -pipe -march=native -frecord-gcc-switches
-ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -Wl,-O1
-Wl,--as-needed -Wl,--hash-style=gnu -o intersect reglib.o intersect.o
print-regdom.o `pkg-config --libs openssl`
x86_64-pc-linux-gnu-gcc -Os -pipe -march=native -frecord-gcc-switches
-ggdb -Wall -g -DUSE_OPENSSL
-DPUBKEY_DIR=\"/etc/wireless-regdb/pubkeys\" `pkg-config --cflags
openssl` -DCONFIG_LIBNL30 `pkg-config --cflags libnl-3.0` -Wl,-O1
-Wl,--as-needed -Wl,--hash-style=gnu -o regdbdump reglib.o regdbdump.o
print-regdom.o `pkg-config --libs openssl`

Thanks,
Zero
