Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52088 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1BNS7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 13:59:14 -0500
Received: by vxb37 with SMTP id 37so2855770vxb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 10:59:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimVK9pJXW32EwHoeqF=0_o-L3wmUC8W1Hd6kBO6@mail.gmail.com>
References: <AANLkTimVK9pJXW32EwHoeqF=0_o-L3wmUC8W1Hd6kBO6@mail.gmail.com>
Date: Mon, 14 Feb 2011 19:55:45 +0100
Message-ID: <AANLkTinLNxBkS73=VL=N=0161LSnudVcyHbF-DvwcrVf@mail.gmail.com>
Subject: Installing compat-wireless modules on an external system
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have a 2.6.24 system running in a separate box (which boots from an
SD Card), and I want to install compat-wireless in it in order to use
a driver (and update the wireless subsystem). I compile the kernel for
the 2.6.24 system in my daily PC.

I cross compiled compat-wireless without problems against the 2.6.24
sources using KLIB=(2.6.24 src path) and KLIB_BUILD=(2.6.24 src path)

My problem is that I am not sure of how to install it in the 2.6.24
system. As this system can be booted from the SD Card, I can mount it
in my daily PC and set the DESTDIR and others with destination the
path. I ran something like:

make KLIB=(2.6.24 src path) KLIB_BUILD=(2.6.24 src path)
KMODPATH_ARG="INSTALL_MOD_PATH=(2.6.24 mounted in my
pc/lib/modules/2.6.24/)" DESTDIR=(2.6.24 mounted in my
pc/lib/modules/2.6.24/) modules_install

Which actually copied the modules into the 2.6.24 system in the SD
Card. However, when booting the 2.6.24 box, and then trying to do
insmod /path/driver.ko, it fails to find some symbols. Going through
the different dependencies (by trying to insert a module, and then
executing dmesg -c), and trying to insert them, it fails too. I cannot
insert mac80211.ko or compat.ko or the rfkill module, etc. I think one
of the last dependences is the function "dev_set_name" which appears
in compat-2.6.26.c I am not sure if this file is also being compiled
(as my daily PC has a 2.6.29 kernel and I don't have access to it
right now).

Well, maybe missing a dependency somewhere, or the 2.6.24 kernel
version is not correctly identified. Any hints?

Best regards,

Juan Carlos
