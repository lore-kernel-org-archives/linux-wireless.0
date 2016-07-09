Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35866 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbcGIX2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 19:28:51 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 0/3] add devicetree support to ath9k
Date: Sun, 10 Jul 2016 01:28:31 +0200
Message-Id: <20160709232834.31654-1-martin.blumenstingl@googlemail.com> (sfid-20160710_012856_401070_32B8C1DE)
In-Reply-To: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

Changes since v3:
- dropped RFC status
- dropped all GPIO and LED related devicetree properties (namely:
  qca,gpio-mask, qca,gpio-val, qca,led-pin, qca,led-active-high).
  These are only needed as long as ath9k doesn't register itself as a
  GPIO controller. However, patches for this are already available in
  LEDE and OpenWrt. Instead of adding new "legacy" properties we should
  try to get the GPIO controller patches upstream.
- rewording of large parts of the documentation which now makes clear
  when specific properties should be set (or not set) any the reason
  behind it. Thanks to everyone who suggested improvements or pointed
  out typos.
- use an array for accessing the string representation of the bus types
  (as suggested by Felix)


Martin Blumenstingl (3):
  Documentation: dt: net: add ath9k wireless device binding
  ath9k: add a helper to get the string representation of ath_bus_type
  ath9k: parse the device configuration from an OF node

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 59 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath.h                     |  6 +++
 drivers/net/wireless/ath/ath9k/init.c              | 55 ++++++++++++++++++++
 drivers/net/wireless/ath/main.c                    |  7 +++
 4 files changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

-- 
2.9.0

