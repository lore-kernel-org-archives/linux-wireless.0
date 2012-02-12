Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35116 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755820Ab2BLTOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 14:14:03 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: linux-tegra@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	Olof Johansson <olof@lixom.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/3] dt: rfkill-gpio: add bindings documentation
Date: Sun, 12 Feb 2012 20:13:07 +0100
Message-Id: <86044d44009316a48b402050f9dd742391d46eac.1329073559.git.marvin24@gmx.de> (sfid-20120212_201409_770130_2CAE9684)
In-Reply-To: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
In-Reply-To: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree bindings information for rfkill gpio switches.

Cc: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Marc Dietrich <marvin24@gmx.de>
---
 Documentation/devicetree/bindings/gpio/rfkill.txt |   38 +++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/rfkill.txt

diff --git a/Documentation/devicetree/bindings/gpio/rfkill.txt b/Documentation/devicetree/bindings/gpio/rfkill.txt
new file mode 100644
index 0000000..22bf22a
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/rfkill.txt
@@ -0,0 +1,38 @@
+RFKILL switches connected to GPIO lines
+
+Required properties:
+- compatible : should be "rfkill-gpio".
+
+Each rfkill switch is represented as a sub-node of the rfkill-gpio device.
+Each node has a label property which represents the name of the corresponding
+rfkill device.
+
+RFKILL sub-node properties:
+- label :  (optional) The label for this rfkill switch.  If omitted, the label is
+  taken from the node name (excluding the unit address).
+- reset-gpio, shutdown-gpio :  Should specify the rfkill gpios for reset and
+  shutdown (see "Specifying GPIO information for devices" in
+  Documentation/devicetree/booting-without-of.txt).
+- type : enumerated type of the gpio (see include/linux/rfkill.h).
+- clock : (optional) name of the clock name associated with the rfkill switch
+  (see include/linux/rfkill-gpio.h)
+
+Examples:
+
+rfkill-switches {
+	compatible = "rfkill-gpio";
+
+	wifi {
+		label = "wifi";
+		reset-gpio = <&gpio 25 0>; /* Active high */
+		shutdown-gpio = <&gpio 85 0>; /* Active high */
+		type = <1>;
+	};
+
+	bt {
+		label = "bluetooth";
+		reset-gpio = <&gpio 17 0>; /* Active high */
+		shutdown-gpio = <&gpio 35 0>; /* Active high */
+		type = <1>;
+	};
+};
-- 
1.7.5.4

