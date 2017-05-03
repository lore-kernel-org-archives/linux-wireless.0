Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34382 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753817AbdECOWn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 10:22:43 -0400
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Subject: [PATCHv2 3/4] Bluetooth: hci_ll: Add compatible values for more WL chips
Date: Wed,  3 May 2017 16:22:25 +0200
Message-Id: <20170503142226.32380-4-sebastian.reichel@collabora.co.uk> (sfid-20170503_162406_826214_82C377AD)
In-Reply-To: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add compatible values for WiLink chips from 128x and 180x series.
Also the DT binding already contained compatible values for the 127x
series, but the driver did not. This brings the list on par with
the list from wlcore (the wifi driver).

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 Documentation/devicetree/bindings/net/ti,wilink-st.txt | 6 ++++++
 drivers/bluetooth/hci_ll.c                             | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,wilink-st.txt b/Documentation/devicetree/bindings/net/ti,wilink-st.txt
index cbad73a84ac4..b1a421e2fde3 100644
--- a/Documentation/devicetree/bindings/net/ti,wilink-st.txt
+++ b/Documentation/devicetree/bindings/net/ti,wilink-st.txt
@@ -14,6 +14,12 @@ Required properties:
  - compatible: should be one of the following:
     "ti,wl1271-st"
     "ti,wl1273-st"
+    "ti,wl1281-st"
+    "ti,wl1283-st"
+    "ti,wl1285-st"
+    "ti,wl1801-st"
+    "ti,wl1805-st"
+    "ti,wl1807-st"
     "ti,wl1831-st"
     "ti,wl1835-st"
     "ti,wl1837-st"
diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index adc444f309a3..d2f32a994daa 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -740,6 +740,14 @@ static void hci_ti_remove(struct serdev_device *serdev)
 }
 
 static const struct of_device_id hci_ti_of_match[] = {
+	{ .compatible = "ti,wl1271-st" },
+	{ .compatible = "ti,wl1273-st" },
+	{ .compatible = "ti,wl1281-st" },
+	{ .compatible = "ti,wl1283-st" },
+	{ .compatible = "ti,wl1285-st" },
+	{ .compatible = "ti,wl1801-st" },
+	{ .compatible = "ti,wl1805-st" },
+	{ .compatible = "ti,wl1807-st" },
 	{ .compatible = "ti,wl1831-st" },
 	{ .compatible = "ti,wl1835-st" },
 	{ .compatible = "ti,wl1837-st" },
-- 
2.11.0
