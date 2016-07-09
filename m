Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34573 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbcGIX2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 19:28:53 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 2/3] ath9k: add a helper to get the string representation of ath_bus_type
Date: Sun, 10 Jul 2016 01:28:33 +0200
Message-Id: <20160709232834.31654-3-martin.blumenstingl@googlemail.com> (sfid-20160710_012859_141057_51FD2DF7)
In-Reply-To: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used when the ath_bus_type has to be presented in a log
message or firmware filename.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath.h  | 6 ++++++
 drivers/net/wireless/ath/main.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index da7a7c8..f3f2784 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -327,4 +327,10 @@ static inline const char *ath_opmode_to_string(enum nl80211_iftype opmode)
 }
 #endif
 
+extern const char *ath_bus_type_strings[];
+static inline const char *ath_bus_type_to_string(enum ath_bus_type bustype)
+{
+	return ath_bus_type_strings[bustype];
+}
+
 #endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 338d723..89f4b05 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -90,3 +90,10 @@ void ath_printk(const char *level, const struct ath_common* common,
 	va_end(args);
 }
 EXPORT_SYMBOL(ath_printk);
+
+const char *ath_bus_type_strings[] = {
+	[ATH_PCI] = "pci",
+	[ATH_AHB] = "ahb",
+	[ATH_USB] = "usb",
+};
+EXPORT_SYMBOL(ath_bus_type_strings);
-- 
2.9.0

