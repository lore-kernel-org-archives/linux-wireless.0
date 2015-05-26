Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64407 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbbEZNfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYxsO003727
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:29 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1umqg00bqj-9
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:29 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/6] mwifiex: device dump support via devcoredump framework
Date: Tue, 26 May 2015 06:34:32 -0700
Message-ID: <1432647272-5734-7-git-send-email-akarwar@marvell.com> (sfid-20150526_153543_246351_3B6AC8ED)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently device dump generated in the driver is retrieved
using ethtool set/get dump commands. We will get rid of
ethtool approach and use devcoredump framework.

Device dump can be trigger by
cat /debugfs/mwifiex/mlanX/device_dump
and when the dump operation is completed, data can be read by
cat /sys/class/devcoredump/devcdX/data

We have prepared following script to split device dump data
into multiple files.

 [root]# cat mwifiex_split_dump_data.sh
 #!/bin/bash
 # usage: ./mwifiex_split_dump_data.sh dump_data

 fw_dump_data=$1

 mem_type="driverinfo ITCM DTCM SQRAM APU CIU ICU MAC"

 for name in ${mem_type[@]}
 do
     sed -n "/Start dump $name/,/End dump/p" $fw_dump_data  > tmp.$name.log
     if [ ! -s tmp.$name.log ]
     then
         rm -rf tmp.$name.log
     else
         #Remove the describle info "Start dump" and "End dump"
         sed '1d' tmp.$name.log | sed '$d' > /data/$name.log
         if [ -s /data/$name.log ]
         then
             echo "generate /data/$name.log"
         else
             sed '1d' tmp.$name.log | sed '$d' > /var/$name.log
             echo "generate /var/$name.log"
         fi
         rm -rf tmp.$name.log
     fi
 done

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig   |  2 +
 drivers/net/wireless/mwifiex/ethtool.c | 99 ----------------------------------
 drivers/net/wireless/mwifiex/main.c    | 90 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h    |  3 +-
 drivers/net/wireless/mwifiex/pcie.c    | 21 +++-----
 drivers/net/wireless/mwifiex/sdio.c    |  5 +-
 6 files changed, 103 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index aa01c9b..48edf38 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -12,6 +12,7 @@ config MWIFIEX_SDIO
 	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
+	select WANT_DEV_COREDUMP
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  8786/8787/8797/8887/8897 chipsets with SDIO interface.
@@ -23,6 +24,7 @@ config MWIFIEX_PCIE
 	tristate "Marvell WiFi-Ex Driver for PCIE 8766/8897"
 	depends on MWIFIEX && PCI
 	select FW_LOADER
+	select WANT_DEV_COREDUMP
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  8766/8897 chipsets with PCIe interface.
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index c78bf0a..58400c6 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -64,106 +64,7 @@ static int mwifiex_ethtool_set_wol(struct net_device *dev,
 	return 0;
 }
 
-static int
-mwifiex_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
-{
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct memory_type_mapping *entry;
-
-	if (!adapter->if_ops.device_dump)
-		return -ENOTSUPP;
-
-	dump->flag = adapter->curr_mem_idx;
-	dump->version = 1;
-	if (adapter->curr_mem_idx == MWIFIEX_DRV_INFO_IDX) {
-		dump->len = adapter->drv_info_size;
-	} else if (adapter->curr_mem_idx != MWIFIEX_FW_DUMP_IDX) {
-		entry = &adapter->mem_type_mapping_tbl[adapter->curr_mem_idx];
-		dump->len = entry->mem_size;
-	} else {
-		dump->len = 0;
-	}
-
-	return 0;
-}
-
-static int
-mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
-		      void *buffer)
-{
-	u8 *p = buffer;
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct memory_type_mapping *entry;
-
-	if (!adapter->if_ops.device_dump)
-		return -ENOTSUPP;
-
-	if (adapter->curr_mem_idx == MWIFIEX_DRV_INFO_IDX) {
-		if (!adapter->drv_info_dump)
-			return -EFAULT;
-		memcpy(p, adapter->drv_info_dump, adapter->drv_info_size);
-		return 0;
-	}
-
-	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
-		mwifiex_dbg(adapter, ERROR,
-			    "device dump in progress!!\n");
-		return -EBUSY;
-	}
-
-	entry = &adapter->mem_type_mapping_tbl[adapter->curr_mem_idx];
-
-	if (!entry->mem_ptr)
-		return -EFAULT;
-
-	memcpy(p, entry->mem_ptr, entry->mem_size);
-
-	entry->mem_size = 0;
-	vfree(entry->mem_ptr);
-	entry->mem_ptr = NULL;
-
-	return 0;
-}
-
-static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
-{
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	if (!adapter->if_ops.device_dump)
-		return -ENOTSUPP;
-
-	if (val->flag == MWIFIEX_DRV_INFO_IDX) {
-		adapter->curr_mem_idx = MWIFIEX_DRV_INFO_IDX;
-		return 0;
-	}
-
-	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
-		mwifiex_dbg(adapter, ERROR,
-			    "device dump in progress!!\n");
-		return -EBUSY;
-	}
-
-	if (val->flag == MWIFIEX_FW_DUMP_IDX) {
-		adapter->curr_mem_idx = val->flag;
-		adapter->if_ops.device_dump(adapter);
-		return 0;
-	}
-
-	if (val->flag < 0 || val->flag >= adapter->num_mem_types)
-		return -EINVAL;
-
-	adapter->curr_mem_idx = val->flag;
-
-	return 0;
-}
-
 const struct ethtool_ops mwifiex_ethtool_ops = {
 	.get_wol = mwifiex_ethtool_get_wol,
 	.set_wol = mwifiex_ethtool_set_wol,
-	.get_dump_flag = mwifiex_get_dump_flag,
-	.get_dump_data = mwifiex_get_dump_data,
-	.set_dump = mwifiex_set_dump,
 };
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index b7fbc2c..3ba4e0e 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -982,6 +982,96 @@ void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 }
 EXPORT_SYMBOL_GPL(mwifiex_drv_info_dump);
 
+void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
+{
+	u8 idx, *dump_data, *fw_dump_ptr;
+	u32 dump_len;
+
+	dump_len = (strlen("========Start dump driverinfo========\n") +
+		       adapter->drv_info_size +
+		       strlen("\n========End dump========\n"));
+
+	for (idx = 0; idx < adapter->num_mem_types; idx++) {
+		struct memory_type_mapping *entry =
+				&adapter->mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			dump_len += (strlen("========Start dump ") +
+					strlen(entry->mem_name) +
+					strlen("========\n") +
+					(entry->mem_size + 1) +
+					strlen("\n========End dump========\n"));
+		}
+	}
+
+	dump_data = vzalloc(dump_len + 1);
+	if (!dump_data)
+		goto done;
+
+	fw_dump_ptr = dump_data;
+
+	/* Dump all the memory data into single file, a userspace script will
+	 * be used to split all the memory data to multiple files
+	 */
+	mwifiex_dbg(adapter, MSG,
+		    "== mwifiex dump information to /sys/class/devcoredump start");
+
+	strcpy(fw_dump_ptr, "========Start dump driverinfo========\n");
+	fw_dump_ptr += strlen("========Start dump driverinfo========\n");
+	memcpy(fw_dump_ptr, adapter->drv_info_dump, adapter->drv_info_size);
+	fw_dump_ptr += adapter->drv_info_size;
+	strcpy(fw_dump_ptr, "\n========End dump========\n");
+	fw_dump_ptr += strlen("\n========End dump========\n");
+
+	for (idx = 0; idx < adapter->num_mem_types; idx++) {
+		struct memory_type_mapping *entry =
+					&adapter->mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			strcpy(fw_dump_ptr, "========Start dump ");
+			fw_dump_ptr += strlen("========Start dump ");
+
+			strcpy(fw_dump_ptr, entry->mem_name);
+			fw_dump_ptr += strlen(entry->mem_name);
+
+			strcpy(fw_dump_ptr, "========\n");
+			fw_dump_ptr += strlen("========\n");
+
+			memcpy(fw_dump_ptr, entry->mem_ptr, entry->mem_size);
+			fw_dump_ptr += entry->mem_size;
+
+			strcpy(fw_dump_ptr, "\n========End dump========\n");
+			fw_dump_ptr += strlen("\n========End dump========\n");
+		}
+	}
+
+	/* device dump data will be free in device coredump release function
+	 * after 5 min
+	 */
+	dev_coredumpv(adapter->dev, dump_data, dump_len, GFP_KERNEL);
+	mwifiex_dbg(adapter, MSG,
+		    "== mwifiex dump information to /sys/class/devcoredump end");
+
+done:
+	for (idx = 0; idx < adapter->num_mem_types; idx++) {
+		struct memory_type_mapping *entry =
+			&adapter->mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+		}
+		entry->mem_size = 0;
+	}
+
+	if (adapter->drv_info_dump) {
+		vfree(adapter->drv_info_dump);
+		adapter->drv_info_dump = NULL;
+		adapter->drv_info_size = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(mwifiex_upload_device_dump);
+
 /*
  * CFG802.11 network device handler for statistics retrieval.
  */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 01111fe..5a6c1c7 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -36,6 +36,7 @@
 #include <linux/of.h>
 #include <linux/idr.h>
 #include <linux/inetdevice.h>
+#include <linux/devcoredump.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -950,7 +951,6 @@ struct mwifiex_adapter {
 	u8 key_api_major_ver, key_api_minor_ver;
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
-	u8 curr_mem_idx;
 	void *drv_info_dump;
 	u32 drv_info_size;
 	bool scan_chan_gap_enabled;
@@ -1485,6 +1485,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
 void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter);
+void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 3a99368..77b9055 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2314,7 +2314,6 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 	enum rdwr_status stat;
 	u32 memory_size;
 	int ret;
-	static char *env[] = { "DRIVER=mwifiex_pcie", "EVENT=fw_dump", NULL };
 
 	if (!card->pcie.can_dump_fw)
 		return;
@@ -2334,7 +2333,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 	/* Read the number of the memories which will dump */
 	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
 	if (stat == RDWR_STATUS_FAILURE)
-		goto done;
+		return;
 
 	reg = creg->fw_dump_start;
 	mwifiex_read_reg_byte(adapter, reg, &dump_num);
@@ -2345,7 +2344,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 
 		stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
 		if (stat == RDWR_STATUS_FAILURE)
-			goto done;
+			return;
 
 		memory_size = 0;
 		reg = creg->fw_dump_start;
@@ -2361,7 +2360,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 						FW_DUMP_READ_DONE);
 			if (ret) {
 				mwifiex_dbg(adapter, ERROR, "PCIE write err\n");
-				goto done;
+				return;
 			}
 			break;
 		}
@@ -2373,7 +2372,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 		if (!entry->mem_ptr) {
 			mwifiex_dbg(adapter, ERROR,
 				    "Vmalloc %s failed\n", entry->mem_name);
-			goto done;
+			return;
 		}
 		dbg_ptr = entry->mem_ptr;
 		end_ptr = dbg_ptr + memory_size;
@@ -2385,7 +2384,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 		do {
 			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
 			if (RDWR_STATUS_FAILURE == stat)
-				goto done;
+				return;
 
 			reg_start = creg->fw_dump_start;
 			reg_end = creg->fw_dump_end;
@@ -2396,7 +2395,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 				} else {
 					mwifiex_dbg(adapter, ERROR,
 						    "Allocated buf not enough\n");
-					goto done;
+					return;
 				}
 			}
 
@@ -2409,18 +2408,14 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 			break;
 		} while (true);
 	}
-	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
-
-	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
-
-done:
-	adapter->curr_mem_idx = 0;
+	mwifiex_dbg(adapter, DUMP, "== mwifiex firmware dump end ==\n");
 }
 
 static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
 {
 	mwifiex_drv_info_dump(adapter);
 	mwifiex_pcie_fw_dump(adapter);
+	mwifiex_upload_device_dump(adapter);
 }
 
 static unsigned long iface_work_flags;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 1f32c02..a0b121f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2185,7 +2185,6 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
 	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
 	enum rdwr_status stat;
 	u32 memory_size;
-	static char *env[] = { "DRIVER=mwifiex_sdio", "EVENT=fw_dump", NULL };
 
 	if (!card->can_dump_fw)
 		return;
@@ -2297,17 +2296,15 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
 	}
 	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
 
-	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
-
 done:
 	sdio_release_host(card->func);
-	adapter->curr_mem_idx = 0;
 }
 
 static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
 {
 	mwifiex_drv_info_dump(adapter);
 	mwifiex_sdio_fw_dump(adapter);
+	mwifiex_upload_device_dump(adapter);
 }
 
 static void mwifiex_sdio_work(struct work_struct *work)
-- 
1.8.1.4

