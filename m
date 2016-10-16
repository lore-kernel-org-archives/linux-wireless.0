Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34618 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbcJPU7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Oct 2016 16:59:47 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        robh+dt@kernel.org
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v8 2/3] ath9k: add a helper to get the string representation of ath_bus_type
Date: Sun, 16 Oct 2016 22:59:06 +0200
Message-Id: <20161016205907.19927-3-martin.blumenstingl@googlemail.com> (sfid-20161016_225958_019293_4566E685)
In-Reply-To: <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
References: <20161002214743.2263-1-martin.blumenstingl@googlemail.com>
 <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
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
2.10.0
