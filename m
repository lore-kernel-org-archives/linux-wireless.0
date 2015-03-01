Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCATch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/31] iwlwifi: mvm: add framework for triggers for fw dump
Date: Sun,  1 Mar 2015 21:31:36 +0200
Message-Id: <1425238304-498-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_659694_D152047F)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the time, the issues we want to debug with the
firmware dump mechanism are transient. It is then very
hard to stop the recording on time and get meaningful
data.
In order to solve this, I add here an infrastucture
of triggers. The user will supply a list of triggers
that will start / stop the recording. We have two types
of triggers: start and stop. Start triggers can start a
specific configuration. The stop triggers will be able to
kick the collection of the data with the currently running
configuration. These triggers are given to the driver by
the .ucode file - just like the configuration.

In the next patches, I'll add triggers in the code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c           | 46 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 18 +++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 88 ++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-fw.h            | 53 ++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  4 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  6 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c            | 37 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  5 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h           | 59 ++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  7 +-
 10 files changed, 243 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index b608114..141331d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -175,6 +175,8 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 	kfree(drv->fw.dbg_dest_tlv);
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_conf_tlv); i++)
 		kfree(drv->fw.dbg_conf_tlv[i]);
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++)
+		kfree(drv->fw.dbg_trigger_tlv[i]);
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
@@ -293,8 +295,10 @@ struct iwl_firmware_pieces {
 
 	/* FW debug data parsed for driver usage */
 	struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
-	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
-	size_t dbg_conf_tlv_len[FW_DBG_MAX];
+	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
+	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
+	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
+	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 };
 
 /*
@@ -914,6 +918,31 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			pieces->dbg_conf_tlv_len[conf->id] = tlv_len;
 			break;
 			}
+		case IWL_UCODE_TLV_FW_DBG_TRIGGER: {
+			struct iwl_fw_dbg_trigger_tlv *trigger =
+				(void *)tlv_data;
+			u32 trigger_id = le32_to_cpu(trigger->id);
+
+			if (trigger_id >= ARRAY_SIZE(drv->fw.dbg_trigger_tlv)) {
+				IWL_ERR(drv,
+					"Skip unknown trigger: %u\n",
+					trigger->id);
+				break;
+			}
+
+			if (pieces->dbg_trigger_tlv[trigger_id]) {
+				IWL_ERR(drv,
+					"Ignore duplicate dbg trigger %u\n",
+					trigger->id);
+				break;
+			}
+
+			IWL_INFO(drv, "Found debug trigger: %u\n", trigger->id);
+
+			pieces->dbg_trigger_tlv[trigger_id] = trigger;
+			pieces->dbg_trigger_tlv_len[trigger_id] = tlv_len;
+			break;
+			}
 		case IWL_UCODE_TLV_SEC_RT_USNIFFER:
 			usniffer_images = true;
 			iwl_store_ucode_sec(pieces, tlv_data,
@@ -1198,6 +1227,19 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
+		if (pieces->dbg_trigger_tlv[i]) {
+			drv->fw.dbg_trigger_tlv_len[i] =
+				pieces->dbg_trigger_tlv_len[i];
+			drv->fw.dbg_trigger_tlv[i] =
+				kmemdup(pieces->dbg_trigger_tlv[i],
+					drv->fw.dbg_trigger_tlv_len[i],
+					GFP_KERNEL);
+			if (!drv->fw.dbg_trigger_tlv[i])
+				goto out_free_fw;
+		}
+	}
+
 	/* Now that we can no longer fail, copy information */
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 919a254..fabddd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -230,4 +230,22 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
 	return (void *)(data->data + le32_to_cpu(data->len));
 }
 
+/**
+ * enum iwl_fw_dbg_trigger - triggers available
+ *
+ * @FW_DBG_TRIGGER_USER: trigger log collection by user
+ *	This should not be defined as a trigger to the driver, but a value the
+ *	driver should set to indicate that the trigger was initiated by the
+ *	user.
+ * @FW_DBG_TRIGGER_FW_ASSERT: trigger log collection when the firmware asserts
+ */
+enum iwl_fw_dbg_trigger {
+	FW_DBG_TRIGGER_INVALID = 0,
+	FW_DBG_TRIGGER_USER,
+	FW_DBG_TRIGGER_FW_ASSERT,
+
+	/* must be last */
+	FW_DBG_TRIGGER_MAX,
+};
+
 #endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 5970682..d2c4d21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -66,6 +66,7 @@
 #define __iwl_fw_file_h__
 
 #include <linux/netdevice.h>
+#include <linux/nl80211.h>
 
 /* v1/v2 uCode file layout */
 struct iwl_ucode_header {
@@ -136,6 +137,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_VERSION	= 36,
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
+	IWL_UCODE_TLV_FW_DBG_TRIGGER	= 40,
 };
 
 struct iwl_ucode_tlv {
@@ -458,44 +460,78 @@ struct iwl_fw_dbg_conf_hcmd {
 } __packed;
 
 /**
- * struct iwl_fw_dbg_trigger - a TLV that describes a debug configuration
+ * enum iwl_fw_dbg_trigger_mode - triggers functionalities
  *
- * @enabled: is this trigger enabled
- * @reserved:
- * @len: length, in bytes, of the %trigger field
- * @trigger: pointer to a trigger struct
+ * @IWL_FW_DBG_TRIGGER_START: when trigger occurs re-conf the dbg mechanism
+ * @IWL_FW_DBG_TRIGGER_STOP: when trigger occurs pull the dbg data
  */
-struct iwl_fw_dbg_trigger {
-	u8 enabled;
-	u8 reserved;
-	u8 len;
-	u8 trigger[0];
-} __packed;
+enum iwl_fw_dbg_trigger_mode {
+	IWL_FW_DBG_TRIGGER_START = BIT(0),
+	IWL_FW_DBG_TRIGGER_STOP = BIT(1),
+};
 
 /**
- * enum iwl_fw_dbg_conf - configurations available
- *
- * @FW_DBG_CUSTOM: take this configuration from alive
- *	Note that the trigger is NO-OP for this configuration
+ * enum iwl_fw_dbg_trigger_vif_type - define the VIF type for a trigger
+ * @IWL_FW_DBG_CONF_VIF_ANY: any vif type
+ * @IWL_FW_DBG_CONF_VIF_IBSS: IBSS mode
+ * @IWL_FW_DBG_CONF_VIF_STATION: BSS mode
+ * @IWL_FW_DBG_CONF_VIF_AP: AP mode
+ * @IWL_FW_DBG_CONF_VIF_P2P_CLIENT: P2P Client mode
+ * @IWL_FW_DBG_CONF_VIF_P2P_GO: P2P GO mode
+ * @IWL_FW_DBG_CONF_VIF_P2P_DEVICE: P2P device
  */
-enum iwl_fw_dbg_conf {
-	FW_DBG_CUSTOM = 0,
-
-	/* must be last */
-	FW_DBG_MAX,
-	FW_DBG_INVALID = 0xff,
+enum iwl_fw_dbg_trigger_vif_type {
+	IWL_FW_DBG_CONF_VIF_ANY = NL80211_IFTYPE_UNSPECIFIED,
+	IWL_FW_DBG_CONF_VIF_IBSS = NL80211_IFTYPE_ADHOC,
+	IWL_FW_DBG_CONF_VIF_STATION = NL80211_IFTYPE_STATION,
+	IWL_FW_DBG_CONF_VIF_AP = NL80211_IFTYPE_AP,
+	IWL_FW_DBG_CONF_VIF_P2P_CLIENT = NL80211_IFTYPE_P2P_CLIENT,
+	IWL_FW_DBG_CONF_VIF_P2P_GO = NL80211_IFTYPE_P2P_GO,
+	IWL_FW_DBG_CONF_VIF_P2P_DEVICE = NL80211_IFTYPE_P2P_DEVICE,
 };
 
 /**
- * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration
- *
- * @id: %enum iwl_fw_dbg_conf
+ * struct iwl_fw_dbg_trigger_tlv - a TLV that describes the trigger
+ * @id: %enum iwl_fw_dbg_trigger
+ * @vif_type: %enum iwl_fw_dbg_trigger_vif_type
+ * @stop_conf_ids: bitmap of configurations this trigger relates to.
+ *	if the mode is %IWL_FW_DBG_TRIGGER_STOP, then if the bit corresponding
+ *	to the currently running configuration is set, the data should be
+ *	collected.
+ * @stop_delay: how many milliseconds to wait before collecting the data
+ *	after the STOP trigger fires.
+ * @mode: %enum iwl_fw_dbg_trigger_mode - can be stop / start of both
+ * @start_conf_id: if mode is %IWL_FW_DBG_TRIGGER_START, this defines what
+ *	configuration should be applied when the triggers kicks in.
+ * @occurrences: number of occurrences. 0 means the trigger will never fire.
+ */
+struct iwl_fw_dbg_trigger_tlv {
+	__le32 id;
+	__le32 vif_type;
+	__le32 stop_conf_ids;
+	__le32 stop_delay;
+	u8 mode;
+	u8 start_conf_id;
+	__le16 occurrences;
+	__le32 reserved[2];
+
+	u8 data[0];
+} __packed;
+
+#define FW_DBG_START_FROM_ALIVE	0
+#define FW_DBG_CONF_MAX		32
+#define FW_DBG_INVALID		0xff
+
+/**
+ * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
+ * @id: conf id
  * @usniffer: should the uSniffer image be used
  * @num_of_hcmds: how many HCMDs to send are present here
  * @hcmd: a variable length host command to be sent to apply the configuration.
  *	If there is more than one HCMD to send, they will appear one after the
  *	other and be sent in the order that they appear in.
- * This parses IWL_UCODE_TLV_FW_DBG_CONF
+ * This parses IWL_UCODE_TLV_FW_DBG_CONF. The user can add up-to
+ * %FW_DBG_CONF_MAX configuration per run.
  */
 struct iwl_fw_dbg_conf_tlv {
 	u8 id;
@@ -503,8 +539,6 @@ struct iwl_fw_dbg_conf_tlv {
 	u8 reserved;
 	u8 num_of_hcmds;
 	struct iwl_fw_dbg_conf_hcmd hcmd;
-
-	/* struct iwl_fw_dbg_trigger sits after all variable length hcmds */
 } __packed;
 
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index ffd785c..cf75baf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -68,6 +68,7 @@
 #include <net/mac80211.h>
 
 #include "iwl-fw-file.h"
+#include "iwl-fw-error-dump.h"
 
 /**
  * enum iwl_ucode_type
@@ -157,6 +158,8 @@ struct iwl_fw_cscheme_list {
  * @dbg_dest_tlv: points to the destination TLV for debug
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
  * @dbg_conf_tlv_len: lengths of the @dbg_conf_tlv entries
+ * @dbg_trigger_tlv: array of pointers to triggers TLVs
+ * @dbg_trigger_tlv_len: lengths of the @dbg_trigger_tlv entries
  * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
  */
 struct iwl_fw {
@@ -186,9 +189,10 @@ struct iwl_fw {
 	u32 sdio_adma_addr;
 
 	struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
-	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
-	size_t dbg_conf_tlv_len[FW_DBG_MAX];
-
+	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
+	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
+	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
+	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 	u8 dbg_dest_reg_num;
 };
 
@@ -206,46 +210,29 @@ static inline const char *get_fw_dbg_mode_string(int mode)
 	}
 }
 
-static inline const struct iwl_fw_dbg_trigger *
-iwl_fw_dbg_conf_get_trigger(const struct iwl_fw *fw, u8 id)
+static inline bool
+iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
 {
 	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg_conf_tlv[id];
-	u8 *ptr;
-	int i;
 
 	if (!conf_tlv)
-		return NULL;
-
-	ptr = (void *)&conf_tlv->hcmd;
-	for (i = 0; i < conf_tlv->num_of_hcmds; i++) {
-		ptr += sizeof(conf_tlv->hcmd);
-		ptr += le16_to_cpu(conf_tlv->hcmd.len);
-	}
-
-	return (const struct iwl_fw_dbg_trigger *)ptr;
-}
-
-static inline bool
-iwl_fw_dbg_conf_enabled(const struct iwl_fw *fw, u8 id)
-{
-	const struct iwl_fw_dbg_trigger *trigger =
-		iwl_fw_dbg_conf_get_trigger(fw, id);
-
-	if (!trigger)
 		return false;
 
-	return trigger->enabled;
+	return conf_tlv->usniffer;
 }
 
-static inline bool
-iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
-{
-	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg_conf_tlv[id];
+#define iwl_fw_dbg_trigger_enabled(fw, id) ({			\
+	void *__dbg_trigger = (fw)->dbg_trigger_tlv[(id)];	\
+	unlikely(__dbg_trigger);				\
+})
 
-	if (!conf_tlv)
-		return false;
+static inline struct iwl_fw_dbg_trigger_tlv*
+iwl_fw_dbg_get_trigger(const struct iwl_fw *fw, u8 id)
+{
+	if (WARN_ON(id >= ARRAY_SIZE(fw->dbg_trigger_tlv)))
+		return NULL;
 
-	return conf_tlv->usniffer;
+	return fw->dbg_trigger_tlv[id];
 }
 
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a96bd8d..542a681 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -595,6 +595,7 @@ enum iwl_d0i3_mode {
  * @dflt_pwr_limit: default power limit fetched from the platform (ACPI)
  * @dbg_dest_tlv: points to the destination TLV for debug
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
+ * @dbg_trigger_tlv: array of pointers to triggers TLVs for debug
  * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
  */
 struct iwl_trans {
@@ -628,7 +629,8 @@ struct iwl_trans {
 	u64 dflt_pwr_limit;
 
 	const struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
-	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
+	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
+	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
 	u8 dbg_dest_reg_num;
 
 	enum iwl_d0i3_mode d0i3_mode;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 82c09d8..f890d5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -942,7 +942,7 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 					  size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	enum iwl_fw_dbg_conf conf;
+	int conf;
 	char buf[8];
 	const size_t bufsz = sizeof(buf);
 	int pos = 0;
@@ -966,7 +966,7 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	if (WARN_ON(conf_id >= FW_DBG_MAX))
+	if (WARN_ON(conf_id >= FW_DBG_CONF_MAX))
 		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
@@ -985,7 +985,7 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_fw_dbg_collect(mvm);
+	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, 0);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 7426bb0..8d684d5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -217,8 +217,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	struct iwl_sf_region st_fwrd_space;
 
 	if (ucode_type == IWL_UCODE_REGULAR &&
-	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_CUSTOM) &&
-	    iwl_fw_dbg_conf_enabled(mvm->fw, FW_DBG_CUSTOM))
+	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE))
 		fw = iwl_get_ucode_image(mvm, IWL_UCODE_REGULAR_USNIFFER);
 	else
 		fw = iwl_get_ucode_image(mvm, ucode_type);
@@ -480,8 +479,14 @@ exit:
 	iwl_free_resp(&cmd);
 }
 
-void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
+int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
+			   unsigned int delay)
 {
+	if (test_and_set_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status))
+		return -EBUSY;
+
+	IWL_WARN(mvm, "Collecting data: trigger %d fired.\n", trig);
+
 	/* stop recording */
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
@@ -491,10 +496,30 @@ void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
 		udelay(100);
 	}
 
-	schedule_work(&mvm->fw_error_dump_wk);
+	queue_delayed_work(system_wq, &mvm->fw_dump_wk, delay);
+
+	return 0;
+}
+
+int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
+				struct iwl_fw_dbg_trigger_tlv *trigger)
+{
+	unsigned int delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
+	u16 occurrences = le16_to_cpu(trigger->occurrences);
+	int ret;
+
+	if (!occurrences)
+		return 0;
+
+	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), delay);
+	if (ret)
+		return ret;
+
+	trigger->occurrences = cpu_to_le16(occurrences - 1);
+	return 0;
 }
 
-int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf conf_id)
+int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 {
 	u8 *ptr;
 	int ret;
@@ -613,7 +638,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
 	mvm->fw_dbg_conf = FW_DBG_INVALID;
-	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_CUSTOM);
+	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_START_FROM_ALIVE);
 
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ce5a5ff..a5261a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1038,6 +1038,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump, 0,
 		      GFP_KERNEL, iwl_mvm_read_coredump, iwl_mvm_free_coredump);
+
+	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
 }
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
@@ -1088,6 +1090,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
+	mvm->fw_dbg_conf = FW_DBG_INVALID;
 
 	/* keep statistics ticking */
 	iwl_mvm_accu_radio_stats(mvm);
@@ -1257,7 +1260,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 
 	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
-	flush_work(&mvm->fw_error_dump_wk);
+	cancel_delayed_work_sync(&mvm->fw_dump_wk);
 
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_mac_stop(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 885d096..4068139 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -75,6 +75,7 @@
 #include "iwl-trans.h"
 #include "iwl-notif-wait.h"
 #include "iwl-eeprom-parse.h"
+#include "iwl-fw-file.h"
 #include "sta.h"
 #include "fw-api.h"
 #include "constants.h"
@@ -703,8 +704,8 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
-	struct work_struct fw_error_dump_wk;
-	enum iwl_fw_dbg_conf fw_dbg_conf;
+	u8 fw_dbg_conf;
+	struct delayed_work fw_dump_wk;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
@@ -840,6 +841,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_IN_D0I3,
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
 	IWL_MVM_STATUS_D3_RECONFIG,
+	IWL_MVM_STATUS_DUMPING_FW_LOG,
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
@@ -1411,7 +1413,56 @@ struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 
-int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf id);
-void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm);
+int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 id);
+int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
+			   unsigned int delay);
+int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
+				struct iwl_fw_dbg_trigger_tlv *trigger);
+
+static inline bool
+iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
+			     struct ieee80211_vif *vif)
+{
+	u32 trig_vif = le32_to_cpu(trig->vif_type);
+
+	return trig_vif == IWL_FW_DBG_CONF_VIF_ANY || vif->type == trig_vif;
+}
+
+static inline bool
+iwl_fw_dbg_trigger_stop_conf_match(struct iwl_mvm *mvm,
+				   struct iwl_fw_dbg_trigger_tlv *trig)
+{
+	return ((trig->mode & IWL_FW_DBG_TRIGGER_STOP) &&
+		(mvm->fw_dbg_conf == FW_DBG_INVALID ||
+		(BIT(mvm->fw_dbg_conf) & le32_to_cpu(trig->stop_conf_ids))));
+}
+
+static inline bool
+iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      struct iwl_fw_dbg_trigger_tlv *trig)
+{
+	if (vif && !iwl_fw_dbg_trigger_vif_match(trig, vif))
+		return false;
+
+	return iwl_fw_dbg_trigger_stop_conf_match(mvm, trig);
+}
+
+static inline void
+iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
+			       struct ieee80211_vif *vif,
+			       enum iwl_fw_dbg_trigger trig)
+{
+	struct iwl_fw_dbg_trigger_tlv *trigger;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, trig))
+		return;
+
+	trigger = iwl_fw_dbg_get_trigger(mvm->fw, trig);
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trigger);
+}
 
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1f64d23..96a4a15 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -455,7 +455,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
-	INIT_WORK(&mvm->fw_error_dump_wk, iwl_mvm_fw_error_dump_wk);
+	INIT_DELAYED_WORK(&mvm->fw_dump_wk, iwl_mvm_fw_error_dump_wk);
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
@@ -503,6 +503,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans->dbg_dest_reg_num = mvm->fw->dbg_dest_reg_num;
 	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg_conf_tlv,
 	       sizeof(trans->dbg_conf_tlv));
+	trans->dbg_trigger_tlv = mvm->fw->dbg_trigger_tlv;
 
 	/* set up notification wait support */
 	iwl_notification_wait_init(&mvm->notif_wait);
@@ -826,7 +827,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 {
 	struct iwl_mvm *mvm =
-		container_of(work, struct iwl_mvm, fw_error_dump_wk);
+		container_of(work, struct iwl_mvm, fw_dump_wk.work);
 
 	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_FW_DBG_COLLECT))
 		return;
@@ -878,7 +879,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (!mvm->restart_fw && fw_error) {
-		schedule_work(&mvm->fw_error_dump_wk);
+		iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_FW_ASSERT, 0);
 	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 				    &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
-- 
1.9.1

