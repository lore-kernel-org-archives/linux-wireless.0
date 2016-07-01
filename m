Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43643 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbcGAJqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 05:46:36 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <tamizhchelvam@codeaurora.org>
Subject: [PATCHv3] dts: Add btcoex_support flag in device tree
Date: Fri, 1 Jul 2016 15:22:04 +0530
Message-ID: <1467366724-32484-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160701_114640_420717_D87B54D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhchelvam@codeaurora.org>

BTCOEX feature is not available in all qca40xx chipsets.
To expose the btcoex support, this patch add btcoex_support
flag in device tree. If this value is 1 then the hardware
supports btcoex and 0 for not support.

Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
---
v3:
  * separated from ath10k patch.

v2:
  * Used CAF address.

 arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1.dtsi b/arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1.dtsi
index b9457dd..f2a2345 100644
--- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1.dtsi
@@ -91,6 +91,14 @@
 			};
 		};
 
+		wifi0: wifi@a000000 {
+			btcoex_support = <0x1>;
+		}
+
+		wifi1: wifi@a800000 {
+			btcoex_support = <0x0>;
+		}
+
 		serial@78af000 {
 			pinctrl-0 = <&serial_pins>;
 			pinctrl-names = "default";
-- 
1.7.9.5

