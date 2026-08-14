Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EC04195D2;
	Fri, 14 Aug 2026 07:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694322; cv=none; b=o0kQeG79EMUd5mrglNKyXGIMdJVzmg+iVDiKKNAmosFLfwSzxokgC9bwxvMZ2O1SmqR6ljDvr554H/e40K2APhbv95iZ5LT0li9FX/iGJIjdiwhYVI8mywZzeSHVE0I2A/qQqmZMPLe70AyF2p9zEX8u7hdb8Z4xv68zYeUtKZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694322; c=relaxed/simple;
	bh=3buc7vWyAN0EyhknLMOPYO8rlwEtwRbHfbjP+03lpFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I8xCjOliRlwE34GO0DZeWD4A3oI8XBP7f01IM+3OW/CC6OIGBmgP1tV8hb5DJTsARo+zVlcIqurEpj8POSepLInFjvWiNeA7Ce55lPQfoGp9OPAHUorPwXXCU0wRqI/Nxx0cKjXphyIP8IwlMiS7lJNdFtLKV274Angt24uof2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAX7O+tyn5q7p2eBQ--.63496S2;
	Fri, 14 Aug 2026 15:58:37 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2] wifi: ath9k: reject short WMI command responses
Date: Fri, 14 Aug 2026 15:58:37 +0800
Message-ID: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAX7O+tyn5q7p2eBQ--.63496S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF45KryDGw1DJr17XF1kZrb_yoW5Cr1fpa
	15ZFWavr1vqr17JrZ3XF48X3Z5Janaqa9xK393Ww1rZrykCr1FkFyFgFyjqr1DAF42gry7
	ZF4UKa1rJr1vkrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUsiSdUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

ath9k_wmi_rsp_callback() removes the validated WMI header and copies
the number of bytes expected by the waiting command into its response
buffer. A device response shorter than that expectation can therefore
be read beyond the skb payload.

Record -EMSGSIZE for a short response, complete the waiter, and return
the stored status from the command path. This also prevents callers from
consuming stale response bytes as a successful reply.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/20260704011405.55089-1-pengpeng@iscas.ac.cn/
- return a stored response error to the waiting command
- retain acceptance of replies longer than the requested prefix
- recheck callback synchronization under the existing WMI lock

The WMI callback and waiter synchronization were reviewed statically; no
ath9k firmware fault injection was performed.

 drivers/net/wireless/ath/ath9k/wmi.c | 17 +++++++++++++++--
 drivers/net/wireless/ath/ath9k/wmi.h |  1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b043..06d9975f9717 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -206,8 +206,16 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
-	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
+	if (wmi->cmd_rsp_buf && wmi->cmd_rsp_len) {
+		if (skb->len < wmi->cmd_rsp_len) {
+			wmi->cmd_rsp_status = -EMSGSIZE;
+			goto complete;
+		}
 		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
+	}
+	wmi->cmd_rsp_status = 0;
+
+complete:
 
 	complete(&wmi->cmd_wait);
 }
@@ -300,6 +308,7 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	/* record the rsp buffer and length */
 	wmi->cmd_rsp_buf = rsp_buf;
 	wmi->cmd_rsp_len = rsp_len;
+	wmi->cmd_rsp_status = 0;
 
 	wmi->last_seq_id = wmi->tx_seq_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
@@ -356,9 +365,13 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		return -ETIMEDOUT;
 	}
 
+	spin_lock_irqsave(&wmi->wmi_lock, flags);
+	ret = wmi->cmd_rsp_status;
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
+
 	mutex_unlock(&wmi->op_mutex);
 
-	return 0;
+	return ret;
 
 out:
 	ath_dbg(common, WMI, "WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5c3b710b8f31..0bb9d31f1a1c 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -157,6 +157,7 @@ struct wmi {
 	u16 tx_seq_id;
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
+	int cmd_rsp_status;
 	bool stopped;
 
 	struct list_head pending_tx_events;
-- 
2.50.1 (Apple Git-155)

