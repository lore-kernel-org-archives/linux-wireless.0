Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35490 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbcJBVsC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 17:48:02 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v7 0/3] add devicetree support to ath9k
Date: Sun,  2 Oct 2016 23:47:40 +0200
Message-Id: <20161002214743.2263-1-martin.blumenstingl@googlemail.com> (sfid-20161002_234807_110069_4443EEB9)
In-Reply-To: <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
References: <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well (adding more AHB specific properties may
still be needed) as soon as the ath79 platform is ready to populate the
ath9k wmac via devicetree.

Changes since v6:
- updated documentation to reflect that "reg" is a mandatory attribute
- dropped "qca,clk-25mhz" as it is only useful for AHB devices. OF
  support for AHB devices needs more work, so we can still introduce it
  later
- removed qca,disable-2ghz and qca,disable-5ghz as these will be
  introduced as generic bindings in a separate series


Changes since v5:
- updated the example in the documentation (keeping it at a bare
  minimum: removed the PCI bridge, use a better real-world example with
  less-confusing device/fn numbers, added the actual size of the config
  space to the reg property)


Martin Blumenstingl (3):
  Documentation: dt: net: add ath9k wireless device binding
  ath9k: add a helper to get the string representation of ath_bus_type
  ath9k: parse the device configuration from an OF node

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 30 ++++++++++++++++
 drivers/net/wireless/ath/ath.h                     |  6 ++++
 drivers/net/wireless/ath/ath9k/init.c              | 42 ++++++++++++++++++++++
 drivers/net/wireless/ath/main.c                    |  7 ++++
 4 files changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

-- 
2.10.0
