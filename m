Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792931553;
	b=czYheMuUoBH/OsaHX4QyzJ6eTMakN+GMREG3bv5bukTARQ3Dkkf8D6ROdx5bMV53W7/4
	 7jV0xGwRe8X1vxLLSJJWAnrVL7CnzkrxIrN+9EAgMmr9qVsnScBdIl4C+zFDjrhXIbIUU
	 asU7x73KSzK3lDecueBklWiV16Xj+PB81jQiiWt621wLJIxO3JcIWUB54NTER7bNMkk29
	 K5vT7SufdjM6siashT7M+h9YHIRUx/dhQPEXsHcLZA+4Zk9KPuE0ne9bBkKu4hC/hbzSJ
	 493r7l7NzQbmAHO7tWY6DrxBtRzP1xcKoVq+M6KaYLR4xk6moD5OAF+8SBKAyYsfkIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792931553;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0cnknNhOj5zkQlFMsyiW3e1+BOYkAhcP8KKxB3A1/OE=;
	b=jtHUtA1terS8/Fs2oSQRm8mSkpWKV4eQXuZPLOC8N68yTrK/9MJpxTHKRmdL5O1S5IXS
	 PxhtPLIx7rUxrBukSs6AmTABoT5Dl7cC0Dkmcjbm0tGvlnNmUI7JCzxXQXTZo0Tw6l8Mh
	 lXyWyq3IwWvfNw4tMhBbg6wS+d21WfiQ2KiFqD8L8gV7icMyee4+F3cdf5OVt/88hp1wE
	 suAyc07z7NkZrOl7O0SbXHAX9GwSUlY0VezPF3+tVrFiN9Ug/GCYQfFQnUFWuVINKUEJu
	 ViSEpdNdYUnH+ze08HMzASq6dvS6qciT2dIrimqDZ47RgRnPd1YvdE3GkUUgpnKcubg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGPJUmz8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7AF606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGPJUmz8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792931552;
	b=J/9Oq1nD5vbRmPRMVrfQ/KoytAi/BlJQ8r4sO3C18LHRPrFk3hZjfv8BSIp5c/+2JfQ1
	 J0nTNAuc1YdiUm0lmHRW06IXONYMEIRrgivfgeQYGG59obCpVcXSjda4ZVNSQWZe8AzEI
	 hWn5xqQjDUsWufkWxKsdk18F2BuSP76epABmq65WhPzGyg0YmmbMCQu5PyEo0u2RfNj3T
	 pQKVXEyQ/hJiJSpQ+CHvrYkOdq48E9ahgdV53FJB/GNJ+Kneu3rWlxMV9LYnBhlsE4mPs
	 hZpGWlKYsWMnaaEl/3F9ypCvhQryxWWg2IoFbJQPxoXtPVMjolYAibBFUk3yZIEYCfQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792931552;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0cnknNhOj5zkQlFMsyiW3e1+BOYkAhcP8KKxB3A1/OE=;
	b=vWdX1IHACJjF7M6uKl0Baim2e4SU7W32yxg/AZ6LVBgLCN6htOpuh4O+vuLt0M0XrHGx
	 KPVuVUa6+2WyMgQEIiPzwO6V69jkBWbuWV7IkCSg8YB4OvbwsRZKtsSvsY1njv+4MZln4
	 FD2gUK/5C6hbrwCkpDaXMgf9X8pb5eECCUSmfnyXTp6yKzM7dveFNzvlMsXTR4S/eYtvt
	 Naa90bmi2pm4RJmLa/ayLyd790M1oeOcDETJwN7Y8ceymidGA526jz4PUsoxadGQ+nx/l
	 Bf505tVKUUDj40mvWnLPxFsCNBimp15PbVR1F/CErkdzvI2rtXwStOcWqfn8DB1JgKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B5BDA1F01828;
	Sun, 25 Oct 2026 12:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792931552;
	bh=0cnknNhOj5zkQlFMsyiW3e1+BOYkAhcP8KKxB3A1/OE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NGPJUmz8PH86NcY2sOGu1GULcPfjo2b9THIzBI5pveCXD/tiMd3TJyQIxGTnNDXwH
	 zy/cqEhD47MI5/86f7Ey+7d7sGNPR//gDTOq10LTrVfmJ+MNR1rQxuEEzVwfiZB75D
	 t8QtD1fLNkc48zRvS1oHV93Fn/uNv3K1LC2lInfcBH/ngTdC2fzjTHkGl/pIH8qzb5
	 JPNaY+vPhbk9w7+oMcXIZa/+MZmGM2WBRdZAuc3DLj0tornPGpGwvMpmNq4qbaoUV9
	 SduqJTaFMMhtRANhQHog9ArjjM71CmeGRKm3Eod6Ef5qWDtsThAMPpJAvW00hgovqE
	 BiYtT54ZYhnFg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 283E044A18;
	Sun, 25 Oct 2026 12:32:31 +0000 (UTC)
From: Francesco Palmarini via B4 Relay <devnull+palmarini.unive.it@kernel.org>
Date: Sun, 25 Oct 2026 12:32:32 +0000
Subject: [PATCH 2/2] wifi: mt76: mt7615: release patch semaphore on timeout
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261025-mt7622-patch-sem-v1-2-e16e31c1face@unive.it>
References: <20261025-mt7622-patch-sem-v1-0-e16e31c1face@unive.it>
In-Reply-To: <20261025-mt7622-patch-sem-v1-0-e16e31c1face@unive.it>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, 
 Francesco Palmarini <palmarini@unive.it>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792931550; l=1053;
 i=palmarini@unive.it; s=20261025; h=from:subject:message-id;
 bh=gm2VLBwmfqY23pExgMK+uypJiAwiosMBXJDOkm1v6RE=;
 b=gWZ0YAfCqwHipQdYCe6q71ZgHMHe1mMQ6A9PlotTC2QPDjExNWI4VCZ1S7D+l/2Dny3W0dlzV
 6Jnn8EGxvgtCUSUgWwZN+YlMNVY2Tuh9JwCE+tBub5kvNawUGHYewi6
X-Developer-Key: i=palmarini@unive.it; a=ed25519;
 pk=3OQ6zyqkl8a98pNobVtrSRWmLpTk0XEeKGtpd+/yK70=
X-Endpoint-Received: by B4 Relay for palmarini@unive.it/20261025 with
 auth_id=1317
X-Original-From: Francesco Palmarini <palmarini@unive.it>
Reply-To: palmarini@unive.it
Content-Transfer-Encoding: 7bit

From: Francesco Palmarini <palmarini@unive.it>

If the PATCH_SEM_CONTROL reply gets lost, the rom may still have granted
the semaphore and every following attempt fails with
PATCH_NOT_DL_SEM_FAIL. Release it on timeout so the next retry can get
it again.

Signed-off-by: Francesco Palmarini <palmarini@unive.it>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index aab4303fe..5f5e29f49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1259,6 +1259,10 @@ static int mt7615_load_patch(struct mt7615_dev *dev, u32 addr, const char *name)
 		goto release_fw;
 	case PATCH_NOT_DL_SEM_SUCCESS:
 		break;
+	case -ETIMEDOUT:
+		/* rom might have granted the semaphore anyway */
+		mt76_connac_mcu_patch_sem_ctrl(&dev->mt76, false);
+		fallthrough;
 	default:
 		dev_err(dev->mt76.dev, "Failed to get patch semaphore\n");
 		ret = -EAGAIN;

-- 
2.39.5


