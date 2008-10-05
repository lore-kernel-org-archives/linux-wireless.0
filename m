Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52978 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJEC6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 22:58:45 -0400
Received: by gxk9 with SMTP id 9so3941270gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 19:58:44 -0700 (PDT)
Message-ID: <43e72e890810041958t59985657iccde75c2c0a0b1aa@mail.gmail.com> (sfid-20081005_045919_639639_DE68D101)
Date: Sat, 4 Oct 2008 19:58:44 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tim Gardner" <tim.gardner@canonical.com>,
	"Ben Collins" <bcollins@ubuntu.com>
Subject: Let Ubuntu Installing your initrd by default when compiling a kernel
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon a 'make install' on a kernel source directory I think
distributions should automagically build your initrd for you. I use
Ubuntu mainly on x86 and for those boxen I installed debianutils,
which provides /sbin/installkernel. This is the path and filename to
the "distribution" script which the kernel Makefiles will run when you
type try to build the install target.

Fedora for example builds your all this shiny stuff for you too. I've
modified Debian's installkernel script to do this for Ubuntu. It'd be
nice to see Ubuntu ship with this script and with the below patch
applied. Mind you, Debian ships this script in debianutils. I haven't
run debian in a while so not sure if debian uses the same format as
you do for their initrd. If so then this can go upstream.

Just a small itch I had to scratch as I just apt-get dist-upgraded and
Ubuntu replaced my installkernel with the new one and it wasn't there.

--- /sbin/installkernel.old	2008-10-04 12:45:40.000000000 -0700
+++ /sbin/installkernel	2008-10-04 12:45:46.000000000 -0700
@@ -66,6 +66,9 @@
   updatever config "$config"
 fi

+mkinitramfs -o $dir/initrd.img-$ver $ver
+update-grub
+
 ## This is very far from existing practice in modern Debian installations
 ########################################################################
 # if [ "$(basename $img)" = "vmlinux" ] && [ "$(id -u)" = "0" ] ; then #
