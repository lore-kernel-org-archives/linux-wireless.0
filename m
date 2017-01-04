Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34630 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdADR7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 12:59:36 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V6 1/3] dt-bindings: document common IEEE 802.11 frequency limit property
Date: Wed,  4 Jan 2017 18:58:29 +0100
Message-Id: <20170104175832.25996-1-zajec5@gmail.com> (sfid-20170104_190243_372568_88791726)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This new file should be used for properties that apply to all wireless
devices.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Switch to a single ieee80211-freq-limit property that allows specifying
    *multiple* ranges. This resolves problem with more complex rules as pointed
    by Felx.
    Make description implementation agnostic as pointed by Arend.
    Rename node to wifi as suggested by Martin.
V3: Use more real-life frequencies in the example.
V5: Describe hardware design as possible use for this property
V6: Even better property description, thanks Rob for your help!
---
 .../devicetree/bindings/net/wireless/ieee80211.txt | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
new file mode 100644
index 0000000..f6442b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
@@ -0,0 +1,24 @@
+Common IEEE 802.11 properties
+
+This provides documentation of common properties that are valid for all wireless
+devices.
+
+Optional properties:
+ - ieee80211-freq-limit : list of supported frequency ranges in KHz. This can be
+	used for devices that in a given config support less channels than
+	normally. It may happen chipset supports a wide wireless band but it is
+	limited to some part of it due to used antennas or power amplifier.
+	An example case for this can be tri-band wireless router with two
+	identical chipsets used for two different 5 GHz subbands. Using them
+	incorrectly could not work or decrease performance noticeably.
+
+Example:
+
+pcie@0,0 {
+	reg = <0x0000 0 0 0 0>;
+	wifi@0,0 {
+		reg = <0x0000 0 0 0 0>;
+		ieee80211-freq-limit = <2402000 2482000>,
+				       <5170000 5250000>;
+	};
+};
-- 
2.10.1
