Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35911 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbcL1QAT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 11:00:19 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
Date: Wed, 28 Dec 2016 16:59:54 +0100
Message-Id: <20161228155955.25518-1-zajec5@gmail.com> (sfid-20161228_170035_307634_F074CA2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This new file should be used for properties handled at higher level and
so usable with all drivers.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
new file mode 100644
index 0000000..c762769
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
@@ -0,0 +1,16 @@
+Common IEEE 802.11 properties
+
+This provides documentation of common properties that are handled by a proper
+net layer and don't require extra driver code.
+
+Optional properties:
+ - ieee80211-min-center-freq : minimal supported frequency in KHz
+ - ieee80211-max-center-freq : maximal supported frequency in KHz
+
+Example:
+
+pcie@0,0 {
+	reg = <0x0000 0 0 0 0>;
+	ieee80211-min-center-freq = <2437000>;
+	ieee80211-max-center-freq = <2457000>;
+};
-- 
2.10.1
