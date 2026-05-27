Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A093DFC88
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876090; cv=none; b=E7K0NAT/kCfMtGVKb7DTZR2JVYPzx1QVMH5pktA4TkcLHcDrCTTVM6LVqf7zyVbo1qz5umMM2qsYoo+3u+5yzKevqE+yZhwRrSmZeChT0IemtZL0RPBlYPjal1ftr0rCTr/dNpl0PRfbYr+CZ/Ekj0TL5mUicatvHqrExCJ9KVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876090; c=relaxed/simple;
	bh=w2cqiKlphkBC6QHoEaLO+llq+fz2T0vo7707KiYUees=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI92gI7YaHx8/JL7Pj3rmaTYBFUvpD0jNJxoPo2r7KbtyoPgtm8gWSRpPfHk5FIVuhtr9n3zEA/Nghmu6P8Yqa15LPB0ApV1GgELWZeAlzVMOvZMhPRFrozWrGoNS+59GA/G0DNOGJrP3Kgdp+165AYGhHn7M/03/6ttlWVY5QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app2 (Coremail) with SMTP id zQmowABH4wrrwBZqrHUQAA--.38265S3;
	Wed, 27 May 2026 18:01:18 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	quic_alokad@quicinc.com,
	yuantan098@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	xuyq21@lenovo.com,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] wifi: nl80211: reject oversized EMA RNR element lists
Date: Wed, 27 May 2026 18:01:09 +0800
Message-ID: <db614d22c4d3cdae0f5fb94b9d78c8e3142c2ecd.1779632165.git.xuyq21@lenovo.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1779632165.git.xuyq21@lenovo.com>
References: <cover.1779632165.git.xuyq21@lenovo.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQmowABH4wrrwBZqrHUQAA--.38265S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyDtFWDXr1UJFW7XF4xWFg_yoW8JFWkpr
	WrGry8Kr93Krn7Jr48G3WrZrWxJa1DGrsxuFZ0qas3Z3ZFqr1Fq3s0gFW5Zrn8Zw48GFWF
	qrsIqF4DC395A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMxkIecxEwVCm
	-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0ACWoWqU4C7QAAsx

From: Yuqi Xu <xuyq21@lenovo.com>

nl80211_parse_rnr_elems() stores the parsed element count in a
u8-backed cfg80211_rnr_elems::cnt field and uses that count to size
the flexible array allocation.

Reject nested NL80211_ATTR_EMA_RNR_ELEMS input once the count reaches
255, before incrementing it again. This keeps the parser aligned with
the data structure it fills and matches the existing bound check used
by nl80211_parse_mbssid_elems().

Fixes: dbbb27e183b1568d5a907ace1cd144b0709ea52a ("cfg80211: support RNR for EMA AP")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f334cdef8958..500eb84ff55a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6354,6 +6354,9 @@ nl80211_parse_rnr_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		if (ret)
 			return ERR_PTR(ret);
 
+		if (num_elems >= 255)
+			return ERR_PTR(-EINVAL);
+
 		num_elems++;
 	}
 
-- 
2.54.0

