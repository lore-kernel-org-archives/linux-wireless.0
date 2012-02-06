Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4084 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284Ab2BFW7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:04 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/8] rt2x00: RT3572 fixes.
Date: Mon,  6 Feb 2012 23:45:05 +0100
Message-Id: <1328568313-26267-1-git-send-email-gwingerde@gmail.com> (sfid-20120206_235912_600459_CC7CBF31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains some general clean-ups and a series of fixes
to the RT3572 channel switching code inside rt2800pci and rt2800usb.
These fixes are based on the v2.5.0.0 version of the RT3572 Ralink driver
and bring rt2x00 closer to that driver with respect to channel switching.

With these changes the performance seems to be enhanced as I can measure
over 100 Mbps as raw network speed.

Gertjan van Wingerde (9):
  rt2x00: Introduce concept of driver data in struct rt2x00_dev.
  rt2x00: Use struct rt2x00_dev driver data in rt2800{pci,usb}.
  rt2x00: Update comment on freq_offset field in struct rt2x00_dev.
  rt2x00: Use saved BBP 25 and 26 values when configuring channel on
    RT3572.
  rt2x00: Fix RFCSR 12 & 13 programming on RT3572 channel switching.
  rt2x00: Align RT3572 channel switch RFCSR 1 programming with Ralink
    driver.
  rt2x00: Fix RT3572 channel switch RFCSR 7 programming.
  rt2x00: Correctly set txmixer_gain in RT3572 channel switching.
  rt2x00: Add support for RT3593 devices.

 drivers/net/wireless/rt2x00/rt2800.h    |   33 +++++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  102 ++++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |   15 ++---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   18 ++++++
 6 files changed, 130 insertions(+), 40 deletions(-)

-- 
1.7.9

