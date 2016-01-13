Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63491 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbcAMPAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:00:22 -0500
From: Eli Cooper <elicooper@gmx.com>
To: linux-wireless@vger.kernel.org
Cc: eli.cooper@gmx.com
Subject: [PATCH 0/1] rt2x00: fix monitor mode regression
Date: Wed, 13 Jan 2016 23:00:00 +0800
Message-Id: <1452697201-11206-1-git-send-email-elicooper@gmx.com> (sfid-20160113_160026_136167_365B85DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit df1404650ccbfeb76a84f301f22316be0d00a864 monitor mode for rt2x00
has been made effectively useless because the hardware filter is configured to
drop packets whose intended recipient is not the device, regardless of the
presence of monitor mode interfaces.

This patch fixes this regression by adding explicit monitor mode support, and
configuring the hardware filter accordingly.

Eli Cooper (1):
  rt2x00: fix monitor mode regression

 drivers/net/wireless/ralink/rt2x00/rt2400pci.c    |  4 +++-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c    |  4 +++-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c    |  4 +++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c    |  3 ++-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h       |  2 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c | 10 ++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c    |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c    |  5 -----
 drivers/net/wireless/ralink/rt2x00/rt61pci.c      |  4 +++-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c      |  4 +++-
 10 files changed, 30 insertions(+), 11 deletions(-)

-- 
2.7.0

