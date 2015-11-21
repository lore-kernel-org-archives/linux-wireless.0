Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:42538 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbbKUVM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2015 16:12:59 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Luca Coelho <luca@coelho.fi>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman\, Liad" <liad.kaufman@intel.com>
Subject: [PATCH] iwlwifi: mvm: add hwmon device for the temperature sensor
References: <541F23D2.90600@gmail.com>
	<1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	<87ppeoc4s0.fsf@nemi.mork.no>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	<87d2amd24t.fsf@nemi.mork.no>
	<0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
	<1411760678.18773.5.camel@dubbel>
	<A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no>
Date: Sat, 21 Nov 2015 22:12:30 +0100
In-Reply-To: <A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no> (=?utf-8?Q?=22?=
 =?utf-8?Q?Bj=C3=B8rn?= Mork"'s
	message of "Sat, 27 Sep 2014 08:41:55 +0200")
Message-ID: <877flbuke9.fsf_-_@nemi.mork.no> (sfid-20151121_221302_792132_2ABC435B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enabling nic temperature monitoring using lmsensors:
 $ sensors
 ..
 phy0-pci-0300
 Adapter: PCI adapter
 temp1:        +50.0°C  (high = +114.0°C, crit = +118.0°C)

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---

Bjørn Mork <bjorn@mork.no> writes:
> On 26 September 2014 21:44:38 CEST, Luca Coelho <luca@coelho.fi> wrote:
>
>>Yeah, the temperature sensor is used to avoid heating the NIC too much
>>and potentially damaging things.  We do things like throttle down the
>>data flow and, in the most dramatic cases, turn the chip entirely off.
>>
>>The mean reason for the new debugfs entry is for, well, debugging. :)
>>
>>Bjørn, do you have any ideas on how this information could be used in a
>>useful way so that it would be worth the effort of exporting it in a
>>more "official" way?
>
> No, not really. It was just a random thought that this should be made
> available for monitoring applications.
>
> It sounds like this sensor is similar to the sensors associated with
> each CPU core. Which have been made available through the coretemp
> driver although I don't think that was the intention of the hardware
> designer. But I don't know if exporting it has any practical value.

Reviving an old discussion...

I got bored and made an attempt on this. Still just for fun.  I don't
have a real usecase.  What do you think?  Completely useless?

FWIW, in my laptop the nic temperature seems to align pretty well to
other temperature sensors:

bjorn@nemi:~$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +48.0°C  (crit = +127.0°C)
temp2:        +45.0°C  (crit = +105.0°C)

thinkpad-isa-0000
Adapter: ISA adapter
fan1:        4951 RPM
temp1:        +48.0°C  
temp2:        +43.0°C  
temp3:        +42.0°C  
temp4:            N/A  
temp5:        +28.0°C  
temp6:            N/A  
temp7:        +25.0°C  
temp8:            N/A  
temp9:        +39.0°C  
temp10:           N/A  
temp11:       +45.0°C  
temp12:           N/A  
temp13:           N/A  
temp14:           N/A  
temp15:           N/A  
temp16:           N/A  

coretemp-isa-0000
Adapter: ISA adapter
Core 0:       +46.0°C  (high = +105.0°C, crit = +105.0°C)
Core 1:       +46.0°C  (high = +105.0°C, crit = +105.0°C)

phy0-pci-0300
Adapter: PCI adapter
temp1:        +44.0°C  (high = +114.0°C, crit = +118.0°C)


 drivers/net/wireless/iwlwifi/mvm/mvm.h | 11 ++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c |  2 ++
 drivers/net/wireless/iwlwifi/mvm/tt.c  | 62 ++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4bde2d027dcd..25c6d14b3543 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -788,6 +788,10 @@ struct iwl_mvm {
 	 */
 	bool temperature_test;  /* Debug test temperature is enabled */
 
+#if IS_ENABLED(CONFIG_HWMON)
+	struct device *hwmon;
+#endif
+
 	struct iwl_time_quota_cmd last_quota_cmd;
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -1416,6 +1420,13 @@ void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_get_temp(struct iwl_mvm *mvm);
+#if IS_ENABLED(CONFIG_HWMON)
+int iwl_mvm_hwmon_register(struct iwl_mvm *mvm);
+void iwl_mvm_hwmon_unregister(struct iwl_mvm *mvm);
+#else
+static inline int iwl_mvm_hwmon_register(struct iwl_mvm *mvm) { return 0; }
+static inline void iwl_mvm_hwmon_unregister(struct iwl_mvm *mvm) {}
+#endif
 
 /* Location Aware Regulatory */
 struct iwl_mcc_update_resp *
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 13c97f665ba8..903b30986e65 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -595,6 +595,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->refs[IWL_MVM_REF_UCODE_DOWN] = 1;
 
 	iwl_mvm_tof_init(mvm);
+	iwl_mvm_hwmon_register(mvm);
 
 	return op_mode;
 
@@ -616,6 +617,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	int i;
 
+	iwl_mvm_hwmon_unregister(mvm);
 	iwl_mvm_leds_exit(mvm);
 
 	iwl_mvm_tt_exit(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index cadfc0460597..38b36251c883 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -64,6 +64,7 @@
  *
  *****************************************************************************/
 
+#include <linux/hwmon.h>
 #include "mvm.h"
 
 #define IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT	HZ
@@ -414,6 +415,67 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 	}
 }
 
+#if IS_ENABLED(CONFIG_HWMON)
+static ssize_t temp1_input_show(struct device *device,
+				struct device_attribute *devattr,
+				char *buf)
+{
+	struct iwl_mvm *mvm = dev_get_drvdata(device);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mvm->temperature * 1000);
+}
+static DEVICE_ATTR_RO(temp1_input);
+
+static ssize_t temp1_crit_show(struct device *device,
+			       struct device_attribute *devattr,
+			       char *buf)
+{
+	struct iwl_mvm *mvm = dev_get_drvdata(device);
+	struct iwl_tt_params *params = &mvm->thermal_throttle.params;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", params->ct_kill_entry * 1000);
+}
+static DEVICE_ATTR_RO(temp1_crit);
+
+static ssize_t temp1_max_show(struct device *device,
+			      struct device_attribute *devattr,
+			      char *buf)
+{
+	struct iwl_mvm *mvm = dev_get_drvdata(device);
+	struct iwl_tt_params *params = &mvm->thermal_throttle.params;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", params->tx_protection_entry * 1000);
+}
+static DEVICE_ATTR_RO(temp1_max);
+
+static struct attribute *mvm_hwmon_attrs[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_temp1_crit.attr,
+	&dev_attr_temp1_max.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(mvm_hwmon);
+
+int iwl_mvm_hwmon_register(struct iwl_mvm *mvm)
+{
+	struct wiphy *wiphy = mvm->hw->wiphy;
+	struct device *hwmon;
+
+	hwmon = hwmon_device_register_with_groups(mvm->dev, wiphy_name(wiphy),
+						  mvm, mvm_hwmon_groups);
+	if (!IS_ERR(hwmon))
+		mvm->hwmon = hwmon;
+	return PTR_ERR_OR_ZERO(hwmon);
+}
+
+void iwl_mvm_hwmon_unregister(struct iwl_mvm *mvm)
+{
+	if (mvm->hwmon)
+		hwmon_device_unregister(mvm->hwmon);
+	mvm->hwmon = NULL;
+}
+#endif /* CONFIG_HWMON */
+
 static const struct iwl_tt_params iwl_mvm_default_tt_params = {
 	.ct_kill_entry = 118,
 	.ct_kill_exit = 96,
-- 
2.1.4

