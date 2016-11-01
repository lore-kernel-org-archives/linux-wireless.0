Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outils.crapouillou.net ([89.234.176.41]:33856 "EHLO
        outils.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1168874AbcKALEX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 07:04:23 -0400
From: Paul Cercueil <paul@crapouillou.net>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: Maarten ter Huurne <maarten@treewalker.org>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 1/2] Documentation: devicetree: Add bindings info for rfkill-regulator
Date: Tue,  1 Nov 2016 11:58:39 +0100
Message-Id: <20161101105840.24313-1-paul@crapouillou.net> (sfid-20161101_120436_083723_23EDDA01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This document gives information about how to write a devicetree
node that corresponds to the rfkill-regulator driver.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 .../devicetree/bindings/net/rfkill-regulator.txt       | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/rfkill-regulator.txt

diff --git a/Documentation/devicetree/bindings/net/rfkill-regulator.txt b/Documentation/devicetree/bindings/net/rfkill-regulator.txt
new file mode 100644
index 0000000..aac2fe1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/rfkill-regulator.txt
@@ -0,0 +1,18 @@
+Device tree bindings for the rfkill-regulator driver
+
+Required properties:
+  - compatible:	should be "rfkill-regulator"
+  - rfkill-name:	the name of this rfkill device
+  - rfkill-type:	the type of this rfkill device;
+			must correspond to a valid rfkill_type from <uapi/linux/rfkill.h>
+  - vrfkill-supply:	phandle to a regulator
+
+Example:
+
+	wlan-rfkill {
+		compatible = "rfkill-regulator";
+		rfkill-name = "WLAN power switch";
+		rfkill-type = <1>;
+
+		vrfkill-supply = <&wlan_power>;
+	};
-- 
2.9.3
