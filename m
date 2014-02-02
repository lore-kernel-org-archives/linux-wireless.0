Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57446 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBBC45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Feb 2014 21:56:57 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so2398253wgh.5
        for <linux-wireless@vger.kernel.org>; Sat, 01 Feb 2014 18:56:56 -0800 (PST)
MIME-Version: 1.0
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Sat, 1 Feb 2014 20:56:36 -0600
Message-ID: <CAAUTuq83oJJ02tMpT6sK4krkwNFEVZYuzfvsTtRoUX=fVYT9-w@mail.gmail.com> (sfid-20140202_035701_814823_95568802)
Subject: mwifiex and SD8787: How to create AP interface?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless,

I'm trying to get AP mode to work on a Marvell Kirkwood-based
Dreamplug with an SD8787 SDIO wireless chipset.

Originally, the mwifiex driver would create three interfaces when it
loaded - mlan0, uap0, and ptp0, for station mode, AP mode, and PTP
mode, respectively. That behavior was removed in commit 1211c (
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mwifiex?id=1211c961170cedb21c30d5bb7e2033c8720b38db
) because NetworkManager was trying to use all of the interfaces
rather than just mlan0.

As I understand it, the normal workflow for this is that hostapd
changes an interface from station mode to AP mode when it starts up,
but when it tries to do this on the mlan0 interface, nl80211 returns
Operation Not Supported. Depending on the version of hostapd, it
either bails out there or tries to continue and bails out later in
setup.

If I revert the patch I linked above, the driver creates the uap0
interface and I can run an AP with hostapd (although it has some other
issues - more on that in a later post).

What is the "correct" way to access AP mode with this driver? As far
as I'm aware, there are no userspace utilities to directly create an
AP-mode interface, and mwifiex doesn't seem to support the normal
workflow that hostapd is trying to do.

Thanks,
Andrew
