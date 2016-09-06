Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34548 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932651AbcIFVqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 17:46:32 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v6 0/3] add devicetree support to ath9k
Date: Tue,  6 Sep 2016 23:46:20 +0200
Message-Id: <20160906214623.20424-1-martin.blumenstingl@googlemail.com> (sfid-20160906_234635_643250_31BC0099)
In-Reply-To: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
References: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

Changes since v5:
- updated the example in the documentation (keeping it at a bare
  minimum: removed the PCI bridge, use a better real-world example with
  less-confusing device/fn numbers, added the actual size of the config
  space to the reg property)


Martin Blumenstingl (3):
  Documentation: dt: net: add ath9k wireless device binding
  ath9k: add a helper to get the string representation of ath_bus_type
  ath9k: parse the device configuration from an OF node

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 39 +++++++++++++++++
 drivers/net/wireless/ath/ath.h                     |  6 +++
 drivers/net/wireless/ath/ath9k/init.c              | 51 ++++++++++++++++++++++
 drivers/net/wireless/ath/main.c                    |  7 +++
 4 files changed, 103 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

-- 
2.9.3
