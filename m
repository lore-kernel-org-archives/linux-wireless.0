Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD9344999F
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788531893; cv=none; b=CbAUIE2EUS5GNNLUJsozjYWZJghJw3hf6mHOf5c9gOVWrTJm2ET4U33yydk2D9wrWXgvjZPVZC6fgqylBWaj00CYviRq4PAe4ziaHPnqSRF57lq5wZ/uegpXTSy43I54GJ23BaaTSPNKLKMZHQxR2IEkmK0oC0YnZNYYWb9cRVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788531893; c=relaxed/simple;
	bh=2TOjKpiQDuKkSYFBrgeLSO8YuRj2qMEpLtWfgIyc9Rk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=XJTE313u+vxnOAIX19kHuDtEJHwLY7FDsAhxaoU2S+E+ztdpKRjFalYkww8cl9ggQkGlPhaEH469QSxPqKSuYYTSgeuGHDGGlMnReKo84ajCUal2MKnU8g6nfvEaDE8ItiBgsZ7DZmw9p+U9OGHXphuhfLyUgO02hAj3KMb6IGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Am2/ukVc; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Am2/ukVc"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2TOjKpiQDuKkSYFBrgeLSO8YuRj2qMEpLtWfgIyc9Rk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788531889; v=1; x=1789136689;
 b=Am2/ukVcNhCx6xGzW7RDULo6wrnYl4JL2NhuUKtxifR4Lo0ZI7PoLJthmJo1h04gg1ZgReIo
 L8uiwceSvNX7P2aZ8gojRy9K0S+GQmyYtKpMsAoUqakQxrmNwbW80xKuGy7sCTs+mhTPyqwrnpH
 SxkDqjA+QUtkpGa9JSP6IZ8g=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 36cecdea86e02bbf;
	Fri, 04 Sep 2026 14:24:49 +0000
X-Mizu-Trace-ID: 36cecdea86e02bbf
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 14:24:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <90bb2b07007942064c04aa3729cedd9eb1e930b1@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: rsi: fix heap OOB write on key removal
To: linux-wireless@vger.kernel.org
Cc: pengpeng@iscas.ac.cn

From: Tianchu Chen <flynnnchen@tencent.com>

When a key is removed (data =3D=3D NULL), rsi_hal_load_key() runs:

	memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);

set_key is a struct rsi_set_key *, so the subscript is scaled by
sizeof(struct rsi_set_key) (160 bytes): &set_key[FRAME_DESC_SZ] is
skb->data + 2560, and the memset writes 144 zero bytes starting
2.4KB past the end of the 160-byte skb data buffer, corrupting
unrelated heap objects. The intended byte offset would have been
(u8 *)set_key + FRAME_DESC_SZ.

The write fires on every DISABLE_KEY callback, so plain disconnects,
roams and interface teardowns trigger it on real networks.

The memset is redundant: the whole buffer is zeroed right after
allocation, so the frame sent to the device is byte-identical
without it. Drop the else branch; normal operation is unaffected.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wirele=
ss/rsi/rsi_91x_mgmt.c
index bb167f03367bf..d9dcbb2553176 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -852,8 +852,6 @@ int rsi_hal_load_key(struct rsi_common *common,
 			memcpy(set_key->tx_mic_key, &data[16], 8);
 			memcpy(set_key->rx_mic_key, &data[24], 8);
 		}
-	} else {
-		memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);
 	}
=20
=20	skb_put(skb, frame_len);
--=20
2.51.0
