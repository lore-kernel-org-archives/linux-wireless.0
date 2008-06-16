Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:57871 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYFPHKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 03:10:15 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3428435rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 00:10:13 -0700 (PDT)
Message-ID: <eaf2efa20806160010u4bc87ea9tb42c663dcf8444c1@mail.gmail.com> (sfid-20080616_094913_656308_6DA1EBDA)
Date: Mon, 16 Jun 2008 16:10:12 +0900
From: "Mark Roberts" <mroberts1839@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Problem with master mode on BCM4318
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080616023427.gm71g7actwc8scsg-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
	 <1213587639.2469.10.camel@dv>
	 <eaf2efa20806152309o342d0a0cs31e73dff3ba3d947@mail.gmail.com>
	 <20080616023427.gm71g7actwc8scsg-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> compat-wireless is a backport of the current drivers, so you should be using
> the firmware for Linux 2.6.25 and newer.

OK, that's helpful, thanks.

I removed the existing firmware and reinstalled the version for
2.6.25, as follows:

  export FIRMWARE_INSTALL_DIR="/lib/firmware"
  wget http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
  tar xjf broadcom-wl-4.150.10.5.tar.bz2
  cd broadcom-wl-4.150.10.5/driver
  sudo ../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"
wl_apsta_mimo.o

(This is described on http://www.linuxwireless.org/en/users/Drivers/b43)

Then:

  cd compat-wireless-2008-06-15
  make
  make install
  sudo make install
  sudo make load
  dmesg

Now, some progress: I no longer see the warning about having old firmware.

> As fast as I know, the master mode support in mac80211 has not been merged
> yet into the wireless-testing branch, so I don't think it's present in
> compat-wireless.  There are some unofficial patches for that, but you never
> mentioned them.  Did any document promised you master mode support if you
> use compat-wireless?

Yes, this page indicates that AP is supported for the Broadcom chips:

  http://linuxwireless.org/en/users/Drivers

The linuxwireless.org site isn't responding for me now either, but you
can always get the pages from Google's cache.

I didn't read anything about the patches before, and indeed the
drivers page doesn't mention them, but now I've been digging through
the Linux wireless list archive and I find a message from Dan Williams
(see: "Does mac80211 support ap mode" thread) which mentions that
mac80211 does support it, and that "While it's still under pretty
heavy development, it all should be fairly usable." The thread
mentions patches but it's not clear how to use them.

What steps should I take to apply the patches?

Thanks,

M
