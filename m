Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37198 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752523AbdA3Kes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 05:34:48 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 30 Jan 2017 12:34:32 +0200
Message-Id: <20170130103432.24613-1-luca@coelho.fi> (sfid-20170130_113546_608452_4868BD5C)
In-Reply-To: <87efzmt11g.fsf@kamboji.qca.qualcomm.com>
References: <87efzmt11g.fsf@kamboji.qca.qualcomm.com>
Subject: [PATCH] iwlwifi: alloc memory dynamically also for DVM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For old firmwares the memory wasn't allocated, resulting in panic.
Make it dynamically allocated as well. Allow any order of functions
call.

Fixes: eef187a7b8a1 ("iwlwifi: enlarge number of ucode sections")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

Kalle,

Could you test this patch to see if it solves the problem?

Thanks!


drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 1d1af4bc1530..d22821501676 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -291,11 +291,33 @@ static struct fw_sec *get_sec(struct iwl_firmware_pieces *pieces,
 	return &pieces->img[type].sec[sec];
 }
 
+static void alloc_sec_data(struct iwl_firmware_pieces *pieces,
+			   enum iwl_ucode_type type,
+			   int sec)
+{
+	struct fw_img_parsing *img = &pieces->img[type];
+	struct fw_sec *sec_memory;
+	int size = sec + 1;
+	size_t alloc_size = sizeof(*img->sec) * size;
+
+	if (img->sec && img->sec_counter >= size)
+		return;
+
+	sec_memory = krealloc(img->sec, alloc_size, GFP_KERNEL);
+	if (!sec_memory)
+		return;
+
+	img->sec = sec_memory;
+	img->sec_counter = size;
+}
+
 static void set_sec_data(struct iwl_firmware_pieces *pieces,
 			 enum iwl_ucode_type type,
 			 int sec,
 			 const void *data)
 {
+	alloc_sec_data(pieces, type, sec);
+
 	pieces->img[type].sec[sec].data = data;
 }
 
@@ -304,6 +326,8 @@ static void set_sec_size(struct iwl_firmware_pieces *pieces,
 			 int sec,
 			 size_t size)
 {
+	alloc_sec_data(pieces, type, sec);
+
 	pieces->img[type].sec[sec].size = size;
 }
 
@@ -319,6 +343,8 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
 			   int sec,
 			   u32 offset)
 {
+	alloc_sec_data(pieces, type, sec);
+
 	pieces->img[type].sec[sec].offset = offset;
 }
 
-- 
2.11.0
