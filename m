Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:55417 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab2APOXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 09:23:39 -0500
Received: by mail-lpp01m010-f45.google.com with SMTP id s15so2441898lag.18
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 06:23:37 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/2] wl12xx: read MAC from fuse rom
Date: Mon, 16 Jan 2012 16:23:24 +0200
Message-Id: <1326723806-15960-1-git-send-email-coelho@ti.com> (sfid-20120116_152342_396408_D6402235)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset implements a new testmode command to read the MAC
address from the fuse when available (it's only correctly burnt for
newer PG versions).

In theory, we can read the MAC in either PLT or normal mode, but I
wanted to restrict it to PLT so people don't start doing funny things
without knowing what they're doing.

Patches to use this new feature with ti-utils calibrator tool will
soon be released.

Cheers,
Luca.

Luciano Coelho (2):
  wl12xx: move partition table definition to io.c
  wl12xx: add operation to retrieve the MAC address from Fuse ROM

 drivers/net/wireless/wl12xx/boot.c     |   62 +----------------------
 drivers/net/wireless/wl12xx/boot.h     |   10 ----
 drivers/net/wireless/wl12xx/io.c       |   59 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h       |    2 +
 drivers/net/wireless/wl12xx/reg.h      |   15 ++++++
 drivers/net/wireless/wl12xx/testmode.c |   87 ++++++++++++++++++++++++++++++++
 6 files changed, 165 insertions(+), 70 deletions(-)

-- 
1.7.4.1

