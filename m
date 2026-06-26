Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6675E258EE9
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782493134; cv=none; b=Q/giqYzzA10v7wcuP+ZjkZkm4re8CnufVxTjtZojLCagWnz4JGi9M78Dz3WDqpEFZXko9ow+MRoTIxxSefQ8kE+9rJ1rF2H3w5jPjihQt/vL1xpDmpQPiWuPmOtv8EquFLtUX4ayEy7tlAFIHpbv1vj8yvWpdJGPKw3TO6RsgGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782493134; c=relaxed/simple;
	bh=ecKU70uSiEjiAu15YfOIEXvWWXh6UDcc6k8qippsop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQy6MhWBrOCR6Vr1IOTNcg8MrssiF6IFqxb8XLvIabqPyA+ntX6h8jSyKzC8KT4WFSeq5wU+zIkraBdBZ+08SICX6tGbIu1jBorXjtUqnFPLw6iWAu8HEbBbvafLLR4J5Dm/mbWmBmJdejgi3h32NQ5kxCOm7I5tWeqrw2r5y7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowAA3dv7Brz5qXhYyAA--.45566S3;
	Sat, 27 Jun 2026 00:58:44 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	linville@tuxdriver.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	roxy520tt@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] wifi: mac80211: free ack status frame on TX header build failure
Date: Sat, 27 Jun 2026 00:58:30 +0800
Message-ID: <9de0423da840e92084915b8f92e66a421245c4b8.1782462409.git.roxy520tt@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782462409.git.roxy520tt@gmail.com>
References: <cover.1782462409.git.roxy520tt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowAA3dv7Brz5qXhYyAA--.45566S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF13CFy3XrW8Gr1rGF1fCrg_yoW5Jr45pF
	y7GrZ8KFykXF13ZF1fGr1IqFWakr4kG34SvrsrAan7ZFnagF1v9F10kFZFvFyFyFWjgF1f
	uF4vyF15Ca1qkrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVCm
	-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEKCWo+NlQIEgAAsv

From: Zhiling Zou <roxy520tt@gmail.com>

ieee80211_build_hdr() stores an ACK status frame before it has
finished all validation and header construction. If a later error path
is taken, the transmit skb is freed but the stored ACK status frame
remains in local->ack_status_frames.

This can happen for control port frames when the requested MLO link ID
does not match the link selected for a non-MLO station. Repeated
failures can fill the ACK status IDR and leave pending ACK frames until
hardware teardown.

Remove any stored ACK status frame before returning an error after it
has been inserted into the IDR.

Fixes: a729cff8ad51 ("mac80211: implement wifi TX status")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/mac80211/tx.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ea7f63e1fc17..8e7f43ee10e5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2597,6 +2597,18 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 	return info_id;
 }
 
+static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
+{
+	struct sk_buff *ack_skb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->ack_status_lock, flags);
+	ack_skb = idr_remove(&local->ack_status_frames, info_id);
+	spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+	kfree_skb(ack_skb);
+}
+
 /**
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
@@ -2972,7 +2984,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
-			return ERR_PTR(-ENOMEM);
+			ret = -ENOMEM;
+			goto free;
 		}
 	}
 
@@ -3040,6 +3053,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	return skb;
  free:
+	if (info_id)
+		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }
-- 
2.43.0

