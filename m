Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28608 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZASTML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 14:12:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 11:12:11 -0800
Date: Mon, 19 Jan 2009 11:11:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Paul Hickey <paul@christianpatriot.us>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Failed Build of modules for 2.6.27.9-159
Message-ID: <20090119191138.GA4018@tesla> (sfid-20090119_201217_445406_B8C112C5)
References: <1232319854.4596.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1232319854.4596.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 03:04:14PM -0800, Paul Hickey wrote:
> Ath9k is part of (my) Fedora 10 and loaded in kernel
> 2.6.27-9.159.fc10.x86_64. mac80211 is loaded when Ath9k is loaded and
> loads cfg80211. mac80211 can be loaded without loading Ath9k (you sti=
ll
> get cfg80211) but one of them gives a never ending log entry of
> ForceXPAon:0

You can ignore this ForceXPAon message, it was supposed to be a debug m=
essage
but was left with a normal print.

> I have a valid .config file
> I have the kernel headers and development files as well.
>=20
> [root@panda4 compat-wireless-2009-01-18]# make
> make -C /lib/modules/2.6.27.9-159.fc10.x86_64/build
> M=3D/home/paul/Download/compat-wireless-2009-01-18 modules
> make[1]: Entering directory `/usr/src/kernels/2.6.27.9-159.fc10.x86_6=
4'
>=20
> Message from syslogd@panda4 at Jan 18 15:50:48 ...
> kernel:Disabling IRQ #16
>   CC
> [M]  /home/paul/Download/compat-wireless-2009-01-18/net/wireless/comp=
at.o
> /home/paul/Download/compat-wireless-2009-01-18/net/wireless/compat.c:=
18:
> error: redefinition of =E2=80=98pci_ioremap_bar=E2=80=99
> include/linux/pci.h:1127: error: previous definition of
> =E2=80=98pci_ioremap_bar=E2=80=99 was here

The 2.6.27 kernel does not have pci_ioremap_bar(), and compat.c defined=
 it
for older kernels as a couple of drivers (ipw, and some ralink driver)
make use of it. Can you try downloading today's version of compat-wirel=
ess and
then try to compile?

If you still see the complaint above then please ensure your kernel
headers are installed properly. By default this is the directory used:

/lib/modules/`uname -r`/build

So check:

ls -ld /lib/modules/`uname -r`/build

And ensure that's pointing to a 2.6.27 directory. Then check the includ=
e/linux/pci.h
file there and look for pci_ioremap_bar. If its there then I am surpris=
ed. Please report
back. I just tested a compile test against 2.6.27 on Ubuntu.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
