Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27863 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbeITSOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 14:14:22 -0400
From: Davide Caratti <dcaratti@redhat.com>
To: Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: report firmware version using ethtool
Date: Thu, 20 Sep 2018 14:30:56 +0200
Message-Id: <cda71b037871304f80558ff3391cef709c317433.1537445946.git.dcaratti@redhat.com> (sfid-20180920_143111_564119_5218FE0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

print fw_ver and build_ver members of struct mt76x02_fw_header, similarly
to what appears in the output of 'dmesg' when the MCU firmware is loaded.

Reported-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---

Notes:
    This patch is based on top of Felix's pull request:
    https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-09-19

 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c  |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c  |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c |  1 +
 5 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 94a2968147a3..76d607f73758 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -178,6 +178,7 @@ static int mt76x0u_load_firmware(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 
 	ret = mt76x0u_upload_firmware(dev, hdr);
+	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
 	release_firmware(fw);
 
 	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 5a2fba3462fd..6d565133b7af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -211,3 +211,16 @@ int mt76x02_mcu_cleanup(struct mt76_dev *dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_cleanup);
+
+void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
+			       const struct mt76x02_fw_header *h)
+{
+	u16 bld = le16_to_cpu(h->build_ver);
+	u16 ver = le16_to_cpu(h->fw_ver);
+
+	snprintf(dev->hw->wiphy->fw_version,
+		 sizeof(dev->hw->wiphy->fw_version),
+		 "%d.%d.%02d-b%x",
+		 (ver >> 12) & 0xf, (ver >> 8) & 0xf, ver & 0xf, bld);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_ethtool_fwver);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 7bfd403f56f6..d30a58b5df29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -105,5 +105,7 @@ int mt76x02_mcu_function_select(struct mt76_dev *dev,
 				u32 val, bool wait_resp);
 int mt76x02_mcu_set_radio_state(struct mt76_dev *dev, bool on,
 				bool wait_resp);
+void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
+			       const struct mt76x02_fw_header *h);
 
 #endif /* __MT76x02_MCU_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index 2b25414ed16b..55716fd7e01d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -154,6 +154,7 @@ mt76pci_load_firmware(struct mt76x2_dev *dev)
 	}
 
 	dev_info(dev->mt76.dev, "Firmware running!\n");
+	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
 
 	release_firmware(fw);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
index fe86b9c696d9..fdd94cad7b66 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -261,6 +261,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
 	/* enable FCE to send in-band cmd */
 	mt76_wr(dev, MT_FCE_PSE_CTRL, 0x1);
 	dev_dbg(dev->mt76.dev, "firmware running\n");
+	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
 
 out:
 	release_firmware(fw);
-- 
2.17.1
