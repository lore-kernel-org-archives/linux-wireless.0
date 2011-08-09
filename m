Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34967 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1HIPEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:04:36 -0400
MIME-Version: 1.0
From: Pavel Ivanov <paivanof@gmail.com>
Date: Tue, 9 Aug 2011 11:04:05 -0400
Message-ID: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com> (sfid-20110809_170444_326855_06DB6AF4)
Subject: Cannot easily set CONFIG_WIRELESS_EXT in kernel 3.0 build
To: linux-kbuild@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've tried to build and install kernel 3.0. The standard Ubuntu
configuration worked very well. But after I ran 'make localmodconfig',
rebuilt and rebooted my wireless didn't work. After some investigation
I've found that option CONFIG_WIRELESS_EXT is no longer set in .config
file. But no matter how I tried to include it in .config file it was
automatically deleted by 'make oldconfig' and again kernel compiled
without it. Then I've found that if I include in the build some
(completely unnecessary to me) wireless module which has 'select
WIRELESS_EXT' in its Kconfig then it stays in .config file and
resulting kernel works very well with my WiFi network. In fact even if
I add 'select WIRELESS_EXT' to Kconfig of the driver for my wireless
card (ath9k) everything works as well.

I'd think that such behavior is a bug, although I don't know on which
side. Either on the side of wireless drivers which all have to have
'select WIRELESS_EXT' in their Kconfig files or on the side of kbuild
system which doesn't allow me to set CONFIG_WIRELESS_EXT unless some
driver requires it. Interestingly enough requiring WIRELESS_EXT works
only with drivers, because I've tried to add CONFIG_LIBIPW (it
requires WIRELESS_EXT too) but it was automatically deleted from
.config file along with CONFIG_WIRELESS_EXT. So I couldn't include
only this library.

Could you tell me if this is indeed a bug or am I missing something here?
I'm not subscribed to the lists so please add me in CC.


Pavel
