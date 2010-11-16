Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([188.94.250.252]:50157 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802Ab0KPLzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 06:55:14 -0500
Received: from mx51.mymxserver.com (mail5102.internal [172.16.51.2])
	by emita2.mittwald.de (Postfix) with ESMTP id 4897E1FA445
	for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 12:47:57 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Subject: Re: Android 2.2/2.2.1 wifi not working after restart with driver-awext
Date: Tue, 16 Nov 2010 13:04:26 +0100
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
References: <0604E650-C4CD-40FF-ACC6-262E555C8194@mac.com>
In-Reply-To: <0604E650-C4CD-40FF-ACC6-262E555C8194@mac.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161304.26637.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Android doesn't work well with upstream groups. They made their own ecosystem,
both in kernel-space and much more in user-space. They also usualy use
outdated software, e.g. ancient kernel version.

You're therefore encouraged to use android-specific mailing-lists or forums to
solve your problems.

That said, the interface isn't up, contrary to your belief:

V/WifiStateTracker(  969): Changing supplicant state: DISCONNECTED ==> 
SCANNING
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not 
supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down

So something in restarting the wifi link forgot Android's equivalent
of "ifconfig $interface up". If the interface isn't up, it won't scan. Without
current scan results and an "up"-interface, it cannot associate.

-- 
Homepage: http://www.holgerschurig.de
