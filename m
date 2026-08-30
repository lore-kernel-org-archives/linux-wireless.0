Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4B14F70;
	Sun, 30 Aug 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788097866; cv=none; b=eDDPihN0z90HhOoIU8iQXieTbqy7bX4litjd3KreUqIyV7H8pc4KGEBrrVnkVOuC1tBKzhvJ69r1YsdRdf8XV91oUYZJUgQmMy8P2ZCXITYCrfvxD8A67FIP2B5N9OzfVCW9p4Uo/J1LDzhQqJUdciO8i2jSz8UbvQMBpS2dh3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788097866; c=relaxed/simple;
	bh=sZjt/88t0yp1o1qNCN4hAc8PR5vR2Lijk1FBmjwVI9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgreHJutI9tErPV5RUd3kJskUzTZ8i7XA/legMs6jyMFl+Oyh0oMhW7hakeuDkKwnlRjdY/f+g5vteeC8+xBM/Gmyk0cr9hWr/S6bG0Trmn0ahy/N+ixm2X2cdUBqHREqwEtps4Q0XFAYejjk96a/1ocf66b78sssFycoQTx0tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHzz1FNZRqWVmbBg--.26180S2;
	Sun, 30 Aug 2026 21:51:01 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath10k: validate DFS TLV payload lengths
Date: Sun, 30 Aug 2026 21:50:59 +0800
Message-ID: <20260830135059.11390-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHzz1FNZRqWVmbBg--.26180S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWrKryDGr1xCF1kXw1DKFg_yoW8Cw18pF
	W2gF9Fqr90y39Fvw1UJan5C34Yka97CwsFkFWYk345W3s5ZrnYqFs0qa4Dtr45Gr43C345
	Xa1UtryxJr1Dt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUxcT
	PUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The DFS event parser verifies that a fixed report fits in the enclosing
event buffer but does not require the current TLV to declare that report
size. A short TLV can therefore consume following records as part of its
payload.

Validate each TLV against the remaining event buffer and require known
report types to declare their fixed payload size.

Fixes: 9702c6860812 ("ath10k: add phyerr/dfs handling")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e57588c19c800..befb84a7bd709 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4236,13 +4236,18 @@ void ath10k_wmi_event_dfs(struct ath10k *ar,
 		tlv = (struct phyerr_tlv *)&phyerr->buf[i];
 		tlv_len = __le16_to_cpu(tlv->len);
 		tlv_buf = &phyerr->buf[i + sizeof(*tlv)];
+		if (tlv_len > buf_len - i - sizeof(*tlv)) {
+			ath10k_warn(ar, "tlv length exceeds remaining buffer (%d)\n",
+				    i);
+			return;
+		}
 		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 			   "wmi event dfs tlv_len %d tlv_tag 0x%02X tlv_sig 0x%02X\n",
 			   tlv_len, tlv->tag, tlv->sig);
 
 		switch (tlv->tag) {
 		case PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY:
-			if (i + sizeof(*tlv) + sizeof(*rr) > buf_len) {
+			if (tlv_len < sizeof(*rr)) {
 				ath10k_warn(ar, "too short radar pulse summary (%d)\n",
 					    i);
 				return;
@@ -4252,7 +4257,7 @@ void ath10k_wmi_event_dfs(struct ath10k *ar,
 			ath10k_dfs_radar_report(ar, phyerr, rr, tsf);
 			break;
 		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
-			if (i + sizeof(*tlv) + sizeof(*fftr) > buf_len) {
+			if (tlv_len < sizeof(*fftr)) {
 				ath10k_warn(ar, "too short fft report (%d)\n",
 					    i);
 				return;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

