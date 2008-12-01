Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:59163 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLAT0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:26:46 -0500
Received: by gxk11 with SMTP id 11so90929gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 11:26:44 -0800 (PST)
Message-ID: <43e72e890812011126sd65799fvf478e08e2b82dfe9@mail.gmail.com> (sfid-20081201_202650_188043_9A64FED6)
Date: Mon, 1 Dec 2008 11:26:43 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Vince Barwinski" <vince.barwinski@gmail.com>
Subject: Re: Build problem with "compat-wireless-2.6-old"
Cc: linux-wireless@vger.kernel.org,
	"Tim Gardner" <tim.gardner@canonical.com>
In-Reply-To: <d5b9d7c80811300048l22b99fe3v27b65e5e4962a54b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <d5b9d7c80811300048l22b99fe3v27b65e5e4962a54b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 30, 2008 at 12:48 AM, Vince Barwinski
<vince.barwinski@gmail.com> wrote:
> Hi there
>
> I just downloaded compat-wireless-old.tar.bz2 and then after
> extracting it I tried to build it by executing the 'make' command. I
> made sure that I had the kernel headers and kernel source installed
> before running 'make'. I downloaded and installed them with 'apt-get'.
> My machine is an ACER Travelmate 230 Laptop with the Operating System
> being 'Simply Mepis Linux version 7.0' with kernel version
> '2.6.22-1-mepis-smp'. My USB wireless adapter is a 'Lemel LM-WLG600U
> 802.11g'. The old story: I am able to get it to work in Microsloth
> Windows XP with the driver CD, but the real problem of course is
> getting it to run in Linux.
>
> At first the build seemed to be running OK, but after a minute or so
> it failed with the following output:
>
> root@laptop:/home/vince/downloads/compat-wireless-2.6-old# make
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.22-1-mepis-smp/build
> M=/home/vince/downloads/compat-wireless-2.6-old modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.22-1-mepis-smp'
>  CC [M]  /home/vince/downloads/compat-wireless-2.6-old/drivers/misc/eeprom_93cx6.o
>  CC [M]  /home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.o
> In file included from
> /home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:34:
> /home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.h:361:
> error: field 'napi' has incomplete type
> /home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: In
> function 'b44_poll':

seems b44 needs backporting of napi stuff. I have it b44 disabled if
you are not on > 2.6.22 but your kernel config is still respected so
it fails. You can simply remove it from being compile be removing the
line indicated below:

diff --git a/Makefile b/Makefile
index e1cd54e..a1d1e59 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,6 @@ ifeq ($(ONLY_CORE),)
 obj-y += net/ieee80211/ \
        drivers/ssb/ \
        drivers/misc/ \
-       drivers/net/ \
        drivers/net/usb/ \
        drivers/net/wireless/
 endif


A patch to backport napi stuff to get this to compile correctly on
2.6.22 is welcomed though.

  Luis
