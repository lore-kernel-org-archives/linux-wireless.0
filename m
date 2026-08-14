Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879446C4A3;
	Fri, 14 Aug 2026 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710507; cv=none; b=jrCFw+fn9eB48u4y9rXx0pWs1d+YACfbUQjUytg8we22Qm2UJlmxKTutRfROYAU00RSWu59RwSbS4q+ouCUQwwJmv9lp7JJ+ndQ13ViaiGs2aDGY4EfCbJrs/LFL9K+6sKi8GcRF7X9b6cc5ECkboN9OFJ6Kl8JnF0FYrIfWu4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710507; c=relaxed/simple;
	bh=2P5Gc3Is03hQgwND7ruC36jXV4PUahlyxLtqscfpGvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bWN2cU9Cm0UeKFWCCR9uJhzayTJHc/G7ZkCANJ1vnGYKQIyAPwTn9Y7OzxSs0eDmsbmaCjiJitGnDWGoMQH6Wd3K3eCxtu1ySZguUTlQUzzZWiEEOQh1HEnS/UWnpCsv7YH/AmEmzMKJn0KIj+C+hgpQgArRz0Pt8Ji8NPS8eqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a126e34897db11f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e67fa118-135e-4dc6-9982-bfac917809a1,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:60df73f0ab7585f505f2084eac97868a,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a126e34897db11f1aa26b74ffac11d73-20260814
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1755544429; Fri, 14 Aug 2026 20:28:18 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 2/3] wifi: nxpwifi: reject VDLL blocks that do not fit the command buffer
Date: Fri, 14 Aug 2026 20:28:09 +0800
Message-Id: <20260814122810.2999536-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814122810.2999536-1-lilinmao@kylinos.cn>
References: <20260814122810.2999536-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_download_vdll_block() copies block_len bytes into ctrl->skb, a
single NXPWIFI_SIZE_OF_CMD_BUFFER byte buffer allocated once at init
time.  block_len comes from the VDLL indication event and is clamped
only against the length of the VDLL image, which is taken from the
firmware file and is far larger than the command buffer.

Two things go wrong once a block exceeds it.  msg_len is a u16, so a
block_len near 65535 wraps it to a small value: skb_put_zero() then
reserves a few bytes while the memcpy() below still writes block_len
bytes past the end of the buffer.  Without the wrap, skb_put_zero()
itself runs past the tail of the skb and panics.

Reject a block that does not fit before the skb is touched.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index 549661ca049a0..97811ee25f392 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -1228,6 +1228,12 @@ int nxpwifi_download_vdll_block(struct nxpwifi_adapter *adapter,
 	u16 msg_len = block_len + S_DS_GEN;
 	int ret = 0;
 
+	if (block_len > NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "VDLL block does not fit: len: %d\n", block_len);
+		return -EINVAL;
+	}
+
 	skb_trim(ctrl->skb, 0);
 	skb_put_zero(ctrl->skb, msg_len);
 
-- 
2.25.1

