Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15125 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcGAJtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 05:49:06 -0400
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Tamizh chelvam" <tamizhchelvam@codeaurora.org>
Subject: RE: [PATCHv3] dts: Add btcoex_support flag in device tree
Date: Fri, 1 Jul 2016 09:48:04 +0000
Message-ID: <dc118e27958944b9be621f6e8d997ecc@aphydexm01f.ap.qualcomm.com> (sfid-20160701_114930_432291_3C6FDC53)
References: <1467366724-32484-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1467366724-32484-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignore this patch. Sorry for the noise.

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of c_traja@qti.qualcomm.com
Sent: Friday, July 01, 2016 3:22 PM
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org; Tamizh chelvam <tamizhchelvam@codeaurora.org>
Subject: [PATCHv3] dts: Add btcoex_support flag in device tree

From: Tamizh chelvam <tamizhchelvam@codeaurora.org>

BTCOEX feature is not available in all qca40xx chipsets.
To expose the btcoex support, this patch add btcoex_support flag in device tree. If this value is 1 then the hardware supports btcoex and 0 for not support.

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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
