Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B17A1DDC07;
	Wed, 29 Jul 2026 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329247; cv=none; b=Doj6Ji+86QnyFw5sc5lsSxJ7/TM7Vc4l/sx4kK5TCZYu/omppkI06OlAMNhUiuVffHbBWF1/rtE5cqwbo1v5RmcBToHTsEQADjp+K/mqNTZL/ku7VFX8xCcHTSPUsFSOoVFjkDaDtsJkUWUh+FtPkZhgY0kYx+2iPUXZHJ4dvAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329247; c=relaxed/simple;
	bh=R0xCK5GJa7w0O7/e8gGo1v2o45/zaMynWePC4mVLf6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YHAun7qpfMMqeWwIdXz32q5X5hHxYFBHr4te9drP1QMlqpCI9+wIlDntVEqth5gxVk0hchdc9XlnOvsNNzHhemK8wyCxe9NwMbX8ffCZgnRos/Qoyu5RZdmC/6GMg7ZAhfEDzZhfpx5t6wFyEhsZ3udaBxt3k/MQWyqxZ8hv3us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a25a21a48b4b11f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e09e1acc-d2a9-46bd-a152-c3889b9296c6,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:1f17197949bd7413997d6586c2403df4,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a25a21a48b4b11f1aa26b74ffac11d73-20260729
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 288772942; Wed, 29 Jul 2026 20:47:18 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH] wifi: nxpwifi: detach sync command buffer on interrupted wait
Date: Wed, 29 Jul 2026 20:47:13 +0800
Message-Id: <20260729124713.2849018-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi synchronous commands keep the caller-provided data buffer in
cmd_node->data_buf. Several callers pass stack-allocated objects there,
for example nxpwifi_get_chan_type() and the timeshare_coex debugfs
handlers.

If wait_event_interruptible_timeout() is interrupted or times out, the
caller can return and release that stack object while the command is still
current. nxpwifi_cancel_all_pending_cmd() deliberately keeps the current
command because a response may still arrive. A late firmware response can
then write through cmd_node->data_buf into the stale stack address.

After cancelling pending commands, detach the caller-owned buffer from the
still-current command under nxpwifi_cmd_lock.

Unlike the host command response path, several command response callbacks
do not tolerate a NULL data buffer. Most of them ignore it or check it
already, but nxpwifi_ret_sta_get_chan_info(),
nxpwifi_ret_sta_hs_wakeup_reason() and nxpwifi_ret_sta_robust_coex()
dereference it unconditionally, so let them discard a detached response.
No caller passes a NULL buffer to these commands today, so this only
affects the newly introduced detached state.

nxpwifi was derived from mwifiex before commit ef06882c7d8a ("wifi:
mwifiex: Detach sync cmd buffer on interrupted wait") and retains the same
lifetime bug. Apply the equivalent buffer detachment here.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c | 12 ++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 10 ++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
index 502c96dc40163..702fa1531da1e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
@@ -45,6 +45,18 @@ int nxpwifi_wait_queue_complete(struct nxpwifi_adapter *adapter,
 		nxpwifi_dbg(adapter, ERROR, "cmd_wait_q terminated: %d\n",
 			    status);
 		nxpwifi_cancel_all_pending_cmd(adapter);
+
+		/*
+		 * The response path writes through cmd_node->data_buf. The
+		 * caller can release a stack-allocated data_buf after an
+		 * interrupted wait while a late response is still pending.
+		 * Detach it from the current command before returning.
+		 */
+		spin_lock_bh(&adapter->nxpwifi_cmd_lock);
+		if (adapter->curr_cmd == cmd_queued)
+			adapter->curr_cmd->data_buf = NULL;
+		spin_unlock_bh(&adapter->nxpwifi_cmd_lock);
+
 		return status;
 	}
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 0b140e84916f3..5e8ffd306b31f 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -2133,6 +2133,9 @@ nxpwifi_ret_sta_robust_coex(struct nxpwifi_private *priv,
 	u16 action = le16_to_cpu(coex->action);
 	u32 mode;
 
+	if (!is_timeshare)
+		return 0;
+
 	coex_tlv = (struct nxpwifi_ie_types_robust_coex
 		    *)((u8 *)coex + sizeof(struct host_cmd_ds_robust_coex));
 	if (action == HOST_ACT_GEN_GET) {
@@ -2679,6 +2682,10 @@ nxpwifi_ret_sta_hs_wakeup_reason(struct nxpwifi_private *priv,
 {
 	struct host_cmd_ds_wakeup_reason *wakeup_reason =
 		(struct host_cmd_ds_wakeup_reason *)data_buf;
+
+	if (!wakeup_reason)
+		return 0;
+
 	wakeup_reason->wakeup_reason =
 		resp->params.hs_wakeup_reason.wakeup_reason;
 
@@ -2771,6 +2778,9 @@ nxpwifi_ret_sta_get_chan_info(struct nxpwifi_private *priv,
 		(struct nxpwifi_channel_band *)data_buf;
 	struct host_cmd_tlv_channel_band *tlv_band_channel;
 
+	if (!channel_band)
+		return 0;
+
 	tlv_band_channel =
 	(struct host_cmd_tlv_channel_band *)sta_cfg_cmd->tlv_buffer;
 	memcpy(&channel_band->band_config, &tlv_band_channel->band_config,

base-commit: 3652b49adac266a3d27cb41cdfdb7d8790fc3633
-- 
2.25.1

