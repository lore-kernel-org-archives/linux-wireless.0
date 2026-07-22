Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BBC3EDE76;
	Wed, 22 Jul 2026 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784694033; cv=none; b=XL39KHvPkAS+YYUb0IeB7zm07knyUc/FK7P9SEt51XaBz70XAAfRHbV8prafSqPFhcJcgEWW/B4p6QHtJTIrj8/ixVAEGUs8kP2Q3xOpRGP/CZFLGar6yh44couOT2jOZFeG0BopTDMhli5WdSMDR+DeSaN+hxznp4Z445aQgqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784694033; c=relaxed/simple;
	bh=oUAmOLmNGXp0Tln9zfz/CVEVtwESMAIAFoov3RAW6oY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J8AYOSMYaZ3Xuvwfw+zj5ftzD3rYt13wPXUCrEpaWnfKvoHClm5ehftRmgZyzZx+i7HtGQ8RsAzwRwbCHc4I1wg4fE2sevT7q7Ij1hNoB3q2Gf8ynr1j0jKEOY9BSA9qBNftTgPqS+fyWJsm2lEmUFi7M49hPE0lAgm6kNYcE1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAB35T8NRWBqQ0W7AA--.34153S2;
	Wed, 22 Jul 2026 12:20:29 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] wifi: ath10k: validate WMI header before reading it
Date: Wed, 22 Jul 2026 12:20:29 +0800
Message-ID: <20260722042029.36066-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAB35T8NRWBqQ0W7AA--.34153S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WF47Jw1fXr15Cw4UAryDGFg_yoW7Cr45pF
	1Uur1xXFWkur4Uur1UZF4kCws0qa4kJ3sIkFyUKw4fZF1vvr1FgFs0gayUJrZIyF13Gr12
	va1jyFW7Grn7t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F
	4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	U2Q6JUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The WMI receive handlers read cmd_id from skb->data before checking that
the skb contains a complete struct wmi_cmd_hdr. The outer HTC payload
check does not establish the nested WMI header length.

Centralize current-item header validation with pskb_may_pull() and use it
in every WMI receive variant before parsing cmd_id.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  8 ++--
 drivers/net/wireless/ath/ath10k/wmi.c     | 46 +++++++++++++----------
 drivers/net/wireless/ath/ath10k/wmi.h     |  2 +
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 01f2d1fa9d7d..345401b97ffb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -638,15 +638,13 @@ static int ath10k_wmi_tlv_event_peer_delete_resp(struct ath10k *ar,
 
 static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
 	bool consumed;
+	u32 cmd_id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
+	if (!ath10k_wmi_pull_cmd_hdr(skb, &cmd_id))
 		goto out;
+	id = MS(cmd_id, WMI_CMD_HDR_CMD_ID);
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e57588c19c80..5b64b5f9bff7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5873,16 +5873,28 @@ static inline void ath10k_wmi_queue_set_coverage_class_work(struct ath10k *ar)
 	}
 }
 
+bool ath10k_wmi_pull_cmd_hdr(struct sk_buff *skb, u32 *cmd_id)
+{
+	const struct wmi_cmd_hdr *cmd_hdr;
+
+	if (!pskb_may_pull(skb, sizeof(*cmd_hdr)))
+		return false;
+
+	cmd_hdr = (const void *)skb->data;
+	*cmd_id = __le32_to_cpu(cmd_hdr->cmd_id);
+	skb_pull(skb, sizeof(*cmd_hdr));
+
+	return true;
+}
+
 static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
+	u32 cmd_id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
+	if (!ath10k_wmi_pull_cmd_hdr(skb, &cmd_id))
 		goto out;
+	id = MS(cmd_id, WMI_CMD_HDR_CMD_ID);
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -6002,15 +6014,13 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10x_event_id id;
 	bool consumed;
+	u32 cmd_id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
+	if (!ath10k_wmi_pull_cmd_hdr(skb, &cmd_id))
 		goto out;
+	id = MS(cmd_id, WMI_CMD_HDR_CMD_ID);
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -6133,15 +6143,13 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10_2_event_id id;
 	bool consumed;
+	u32 cmd_id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
+	if (!ath10k_wmi_pull_cmd_hdr(skb, &cmd_id))
 		goto out;
+	id = MS(cmd_id, WMI_CMD_HDR_CMD_ID);
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -6282,15 +6290,13 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10_4_event_id id;
 	bool consumed;
+	u32 cmd_id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (!skb_pull(skb, sizeof(struct wmi_cmd_hdr)))
+	if (!ath10k_wmi_pull_cmd_hdr(skb, &cmd_id))
 		goto out;
+	id = MS(cmd_id, WMI_CMD_HDR_CMD_ID);
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7f50a1de6b97..7c787173b187 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -7440,6 +7440,7 @@ struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
 struct ath10k_fw_stats_peer;
 struct ath10k_fw_stats;
+struct sk_buff;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
@@ -7449,6 +7450,7 @@ int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
 struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
 int ath10k_wmi_connect(struct ath10k *ar);
+bool ath10k_wmi_pull_cmd_hdr(struct sk_buff *skb, u32 *cmd_id);
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
 int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
-- 
2.43.0

