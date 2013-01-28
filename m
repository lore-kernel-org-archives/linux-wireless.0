Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3A1Jia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/37] iwlwifi: add the MVM driver (binding)
Date: Mon, 28 Jan 2013 10:37:21 +0100
Message-Id: <1359365864-4259-15-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103835_651313_57CE7B1F)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/binding.c | 197 +++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/binding.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/binding.c b/drivers/net/wireless/iwlwifi/mvm/binding.c
new file mode 100644
index 0000000..73d24aa
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/binding.c
@@ -0,0 +1,197 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <net/mac80211.h>
+#include "fw-api.h"
+#include "mvm.h"
+
+struct iwl_mvm_iface_iterator_data {
+	struct ieee80211_vif *ignore_vif;
+	int idx;
+
+	struct iwl_mvm_phy_ctxt *phyctxt;
+
+	u16 ids[MAX_MACS_IN_BINDING];
+	u16 colors[MAX_MACS_IN_BINDING];
+};
+
+static int iwl_mvm_binding_cmd(struct iwl_mvm *mvm, u32 action,
+			       struct iwl_mvm_iface_iterator_data *data)
+{
+	struct iwl_binding_cmd cmd;
+	struct iwl_mvm_phy_ctxt *phyctxt = data->phyctxt;
+	int i, ret;
+	u32 status;
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	cmd.id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(phyctxt->id,
+							   phyctxt->color));
+	cmd.action = cpu_to_le32(action);
+	cmd.phy = cpu_to_le32(FW_CMD_ID_AND_COLOR(phyctxt->id,
+						  phyctxt->color));
+
+	for (i = 0; i < MAX_MACS_IN_BINDING; i++)
+		cmd.macs[i] = cpu_to_le32(FW_CTXT_INVALID);
+	for (i = 0; i < data->idx; i++)
+		cmd.macs[i] = cpu_to_le32(FW_CMD_ID_AND_COLOR(data->ids[i],
+							      data->colors[i]));
+
+	status = 0;
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, BINDING_CONTEXT_CMD,
+					  sizeof(cmd), &cmd, &status);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to send binding (action:%d): %d\n",
+			action, ret);
+		return ret;
+	}
+
+	if (status) {
+		IWL_ERR(mvm, "Binding command failed: %u\n", status);
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+static void iwl_mvm_iface_iterator(void *_data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_iface_iterator_data *data = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif == data->ignore_vif)
+		return;
+
+	if (mvmvif->phy_ctxt != data->phyctxt)
+		return;
+
+	if (WARN_ON_ONCE(data->idx >= MAX_MACS_IN_BINDING))
+		return;
+
+	data->ids[data->idx] = mvmvif->id;
+	data->colors[data->idx] = mvmvif->color;
+	data->idx++;
+}
+
+static int iwl_mvm_binding_update(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif,
+				  struct iwl_mvm_phy_ctxt *phyctxt,
+				  bool add)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_iface_iterator_data data = {
+		.ignore_vif = vif,
+		.phyctxt = phyctxt,
+	};
+	u32 action = FW_CTXT_ACTION_MODIFY;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_iface_iterator,
+						   &data);
+
+	/*
+	 * If there are no other interfaces yet we
+	 * need to create a new binding.
+	 */
+	if (data.idx == 0) {
+		if (add)
+			action = FW_CTXT_ACTION_ADD;
+		else
+			action = FW_CTXT_ACTION_REMOVE;
+	}
+
+	if (add) {
+		if (WARN_ON_ONCE(data.idx >= MAX_MACS_IN_BINDING))
+			return -EINVAL;
+
+		data.ids[data.idx] = mvmvif->id;
+		data.colors[data.idx] = mvmvif->color;
+		data.idx++;
+	}
+
+	return iwl_mvm_binding_cmd(mvm, action, &data);
+}
+
+int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (WARN_ON_ONCE(!mvmvif->phy_ctxt))
+		return -EINVAL;
+
+	return iwl_mvm_binding_update(mvm, vif, mvmvif->phy_ctxt, true);
+}
+
+int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (WARN_ON_ONCE(!mvmvif->phy_ctxt))
+		return -EINVAL;
+
+	return iwl_mvm_binding_update(mvm, vif, mvmvif->phy_ctxt, false);
+}
-- 
1.8.0

