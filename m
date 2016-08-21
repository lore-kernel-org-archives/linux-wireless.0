Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34634 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbcHUObY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:31:24 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 0/3] add devicetree support to ath9k
Date: Sun, 21 Aug 2016 16:31:02 +0200
Message-Id: <20160821143105.27487-1-martin.blumenstingl@googlemail.com> (sfid-20160821_163128_009172_16316A6F)
In-Reply-To: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
References: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

Changes since v4:
- dropped "qca,check-eeprom-endianness" for now - this will be part
  of a separate patch
- update documentation to fix the "compatible" string (as there is a
  PCI device specific format)


Martin Blumenstingl (3):
  Documentation: dt: net: add ath9k wireless device binding
  ath9k: add a helper to get the string representation of ath_bus_type
  ath9k: parse the device configuration from an OF node

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 47 ++++++++++++++++++++
 drivers/net/wireless/ath/ath.h                     |  6 +++
 drivers/net/wireless/ath/ath9k/init.c              | 51 ++++++++++++++++++++++
 drivers/net/wireless/ath/main.c                    |  7 +++
 4 files changed, 111 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

-- 
2.9.3
