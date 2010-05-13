Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4067 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758683Ab0EMTQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:16:09 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/4] Final set of fixes and cleanups for 2.6.35.
Date: Thu, 13 May 2010 21:16:02 +0200
Message-Id: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the final set of fixes and cleanups for 2.6.35 from my side.
The first one is a powersave fixlet that was off my radar for a while but
got dusted off. One is a fix of a bug introduced in a previous patch series
and the final two are clean-ups that make it easier to use rt2x00usb
functionality.

This is on top of the last patch series I sent out.

These patches (and the ones of the previous series) can also be pulled from:

	git://git.gwingerde.nl/rt2x00-next-2.6.git

Gertjan van Wingerde (4):
  rt2x00: Fix failed SLEEP->AWAKE and AWAKE->SLEEP transitions.
  rt2x00: Fix rt2800usb TX descriptor writing.
  rt2x00: Clean up USB vendor request buffer functions.
  rt2x00: Centralize rt2800 beacon writing.

 drivers/net/wireless/rt2x00/rt2400pci.c |    9 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c |   14 +-----
 drivers/net/wireless/rt2x00/rt2800lib.c |   61 +++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   63 +--------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   74 ++-----------------------------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   22 +---------
 drivers/net/wireless/rt2x00/rt2x00usb.h |   19 --------
 drivers/net/wireless/rt2x00/rt61pci.c   |    7 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   39 +++++------------
 11 files changed, 96 insertions(+), 223 deletions(-)

