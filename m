Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD920208D0;
	Sat,  4 Jul 2026 01:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127556; cv=none; b=Rzo9nx0jaBmS9/0dL7gCVit9y/iy2JQBMHgVEoOLehTzKTCY3Dorz0tBnHeF0c5Zq84nEadXfsN0hn791kd1HG0jEg7E9tsdBfh5RDwYQFx99uphmgPK/2v1MmlJKJRpB3KcH5yt7kOwkBAiDNytV1rpSWyyamlR+cQIovw7rjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127556; c=relaxed/simple;
	bh=3i6/3z36pXsM+BLfZUJsZymb6SDbztX0bP5vmersiJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h8suq8w0mvFtzHkYASw9z/ZiNXc0bSsHtv1O37GTKRQf8j3C5gzT8iE/DhJoB93bW22W3qn48LsAMKwRcuJOJTeuPlFeszT++t06d5Xf1mXCiHLx/CMt215x1+pj1hMGgLrM77sb+XKIT/fWVPLVoo9AGgsdXF3PtOr/qRPXh3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowABXrdAAXkhql6vEFg--.38789S2;
	Sat, 04 Jul 2026 09:12:32 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] wifi: rsi: bound background scan probe request copy
Date: Sat,  4 Jul 2026 09:12:30 +0800
Message-ID: <20260704011231.45593-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXrdAAXkhql6vEFg--.38789S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw1UKF4DCr47Jr4kJryUtrb_yoWDJwc_C3
	4UZFZ8G34UGF4jqFWYkr43ArZ0k39rCFyrJr92q3yrGa4qqr4Iqr4Fkrs8JrW7Gayrtr93
	Gw4kZas5ZF9xKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzxFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb4v3UUUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

rsi_send_bgscan_probe_req() allocates room for struct
rsi_bgscan_probe plus MAX_BGSCAN_PROBE_REQ_LEN bytes, but copies the
entire mac80211-generated probe request skb after the fixed header.
The probe request length depends on scan IEs and is not checked
against the fixed firmware buffer.

Reject generated probe requests that do not fit the firmware command
buffer before copying them into the skb.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1909,6 +1909,12 @@
 	if (!probereq_skb) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
+	}
+
+	if (probereq_skb->len > MAX_BGSCAN_PROBE_REQ_LEN) {
+		dev_kfree_skb(probereq_skb);
+		dev_kfree_skb(skb);
+		return -EINVAL;
 	}
 
 	memcpy(&skb->data[frame_len], probereq_skb->data, probereq_skb->len);

