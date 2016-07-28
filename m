Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52494 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbcG1IFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:30 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 6/8] remoteproc: use firmware_stat instead of completion
Date: Thu, 28 Jul 2016 09:55:10 +0200
Message-Id: <1469692512-16863-7-git-send-email-wagi@monom.org> (sfid-20160728_100550_502151_0ADF36FE)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Loading firmware is an operation many drivers implement in various ways
around the completion API. And most of them do it almost in the same
way. Let's reuse the firmware_stat API which is used also by the
firmware_class loader. Apart of streamlining the firmware loading states
we also document it slightly better.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/remoteproc/remoteproc_core.c | 10 +++++-----
 drivers/soc/ti/wkup_m3_ipc.c         |  2 +-
 include/linux/remoteproc.h           |  6 ++++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index db3958b..3b158f7 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -936,7 +936,7 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 out:
 	release_firmware(fw);
 	/* allow rproc_del() contexts, if any, to proceed */
-	complete_all(&rproc->firmware_loading_complete);
+	fw_loading_done(rproc->fw_st);
 }
 
 static int rproc_add_virtio_devices(struct rproc *rproc)
@@ -944,7 +944,7 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 	int ret;
 
 	/* rproc_del() calls must wait until async loader completes */
-	init_completion(&rproc->firmware_loading_complete);
+	firmware_stat_init(&rproc->fw_st);
 
 	/*
 	 * We must retrieve early virtio configuration info from
@@ -959,7 +959,7 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 				      rproc, rproc_fw_config_virtio);
 	if (ret < 0) {
 		dev_err(&rproc->dev, "request_firmware_nowait err: %d\n", ret);
-		complete_all(&rproc->firmware_loading_complete);
+		fw_loading_abort(rproc->fw_st);
 	}
 
 	return ret;
@@ -1089,7 +1089,7 @@ static int __rproc_boot(struct rproc *rproc, bool wait)
 
 	/* if rproc virtio is not yet configured, wait */
 	if (wait)
-		wait_for_completion(&rproc->firmware_loading_complete);
+		fw_loading_wait(rproc->fw_st);
 
 	ret = rproc_fw_boot(rproc, firmware_p);
 
@@ -1447,7 +1447,7 @@ int rproc_del(struct rproc *rproc)
 		return -EINVAL;
 
 	/* if rproc is just being registered, wait */
-	wait_for_completion(&rproc->firmware_loading_complete);
+	fw_loading_wait(rproc->fw_st);
 
 	/* clean up remote vdev entries */
 	list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)
diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
index 8823cc8..14c6396 100644
--- a/drivers/soc/ti/wkup_m3_ipc.c
+++ b/drivers/soc/ti/wkup_m3_ipc.c
@@ -370,7 +370,7 @@ static void wkup_m3_rproc_boot_thread(struct wkup_m3_ipc *m3_ipc)
 	struct device *dev = m3_ipc->dev;
 	int ret;
 
-	wait_for_completion(&m3_ipc->rproc->firmware_loading_complete);
+	fw_loading_wait(m3_ipc->rproc->fw_st);
 
 	init_completion(&m3_ipc->sync_complete);
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 1c457a8..b8e7ff4 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -41,6 +41,7 @@
 #include <linux/completion.h>
 #include <linux/idr.h>
 #include <linux/of.h>
+#include <linux/firmware.h>
 
 /**
  * struct resource_table - firmware resource table header
@@ -397,7 +398,7 @@ enum rproc_crash_type {
  * @num_traces: number of trace buffers
  * @carveouts: list of physically contiguous memory allocations
  * @mappings: list of iommu mappings we initiated, needed on shutdown
- * @firmware_loading_complete: marks e/o asynchronous firmware loading
+ * @fw_sync: marks e/o asynchronous firmware loading
  * @bootaddr: address of first instruction to boot rproc with (optional)
  * @rvdevs: list of remote virtio devices
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
@@ -429,7 +430,7 @@ struct rproc {
 	int num_traces;
 	struct list_head carveouts;
 	struct list_head mappings;
-	struct completion firmware_loading_complete;
+	struct firmware_stat fw_st;
 	u32 bootaddr;
 	struct list_head rvdevs;
 	struct idr notifyids;
@@ -479,6 +480,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @rsc_offset: offset of the vdev's resource entry
  */
+
 struct rproc_vdev {
 	struct list_head node;
 	struct rproc *rproc;
-- 
2.7.4
