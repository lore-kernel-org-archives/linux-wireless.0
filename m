Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33772 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932970AbdABN2e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 08:28:34 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 2/3] dt-bindings: document common IEEE 802.11 frequency limit property
Date: Mon,  2 Jan 2017 14:27:46 +0100
Message-Id: <20170102132747.3491-2-zajec5@gmail.com> (sfid-20170102_142837_037283_B0E9AFBD)
In-Reply-To: <20170102132747.3491-1-zajec5@gmail.com>
References: <20170102132747.3491-1-zajec5@gmail.com>
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
---
 .../devicetree/bindings/net/wireless/ieee80211.txt     | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
new file mode 100644
index 0000000..658c721
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
@@ -0,0 +1,18 @@
+Common IEEE 802.11 properties
+
+This provides documentation of common properties that are valid for all wireless
+devices.
+
+Optional properties:
+ - ieee80211-freq-limit : list of supported frequency ranges in KHz
+
+Example:
+
+pcie@0,0 {
+	reg = <0x0000 0 0 0 0>;
+	wifi@0,0 {
+		reg = <0x0000 0 0 0 0>;
+		ieee80211-freq-limit = <2402000 2432000>,
+				       <2432000 2462000>;
+	};
+};
-- 
2.10.1
