Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48196 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3GHOIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:42 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 00/20] rt2x00: add experimental support for RT3593
Date: Mon,  8 Jul 2013 16:08:15 +0200
Message-Id: <1373292515-21332-1-git-send-email-juhosg@openwrt.org> (sfid-20130708_160845_529319_19CD6283)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch-set implements experiemental support for the
RT3593 chipset. The patches are tested on the Linksys
AE3000 USB device only, however other USB devices which
are using the RT3573 chips might work as well.

The patch-set depends on the following series:
'rt2x00: rt2800lib: add support for extended EEPROM of three-chain devices'

Changes since v2:
 - keep case values in aplhabetical order

Changes since v1:
 - add missing patch
 - make Linksys AE3000 support optional

Gabor Juhos (20):
  rt2x00: rt2800lib: add MAC register initialization for RT3593
  rt2x00: rt2800lib: add BBP register initialization for RT3593
  rt2x00: rt2800lib: add RFCSR register initialization for RT3593
  rt2x00: rt2800lib: add BBP post initialization for RT3593
  rt2x00: rt2800lib: add TX power configuration for RT3593
  rt2x00: rt2800lib: fix BBP1_TX_ANTENNA field configuration for 3T devices
  rt2x00: rt2800lib: fix antenna configuration for RT3593
  rt2x00: rt2800lib: add rt2800_txpower_to_dev helper
  rt2x00: rt2800lib: fix default TX power values for RT3593
  rt2x00: rt2800lib: introduce rt2800_get_txmixer_gain_{24,5}g helpers
  rt2x00: rt2800lib: hardcode TX mixer gain values for RT3593
  rt2x00: rt2800lib: fix LNA_A[12] gain values for RT3593
  rt2x00: rt2800lib: add default_power3 field for three-chain devices
  rt2x00: rt2800lib: add rf_vals for RF3053
  rt2x00: rt2800lib: add channel configuration for RF3053
  rt2x00: rt2800lib: enable VCO recalibration for RF3053
  rt2x00: rt2800lib: enable RF3053 support
  rt2x00: rt2800lib: enable RT3593 support
  rt2x00: rt2800usb: use correct [RT]XWI size for RT3593
  rt2x00: rt2800usb: add USB device ID for Linksys AE3000

 drivers/net/wireless/rt2x00/Kconfig     |    6 +
 drivers/net/wireless/rt2x00/rt2800.h    |  187 ++++-
 drivers/net/wireless/rt2x00/rt2800lib.c | 1227 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 5 files changed, 1385 insertions(+), 45 deletions(-)

--
1.7.10

