Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F8D4A43EC;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097736; cv=none; b=Z9ViZbJm5Q5X1vXkOyXaFdCclxPEFLZnNzLtku692HvLPWl9rhOi20hNp2lAdNq2NaIB6z8ZkSJ/laj0UlYLedk4sSHpRT4qhlfH1umlAHGtzQHrg9iQs5N3nHu4Swzez63zJq6lpqpfkbtSxxvmzq1RaEdjQvrgrDU++JPwW3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097736; c=relaxed/simple;
	bh=8TFgXrqm00gTUkYWKQDkyq2nEt87hZ1bR+nt+jFn4KY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c55/H+KMjTVkWYlKB01GSDRWuSuWiHkHfK3odnBY0p8gmN4vNlc94+xtG8EM96Yrr/Ie/LQKBXRSrMnBC7nkphTiLbz/mkVeWIKoP7AXXzvRk+GcMH8XOgrRwcLvuNkrsAW8mcDryEW6Hq7rVMF8mfKtmtrnNZg7KP/WzSVeC8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCuEMW7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCuEMW7y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51017C2BCFF;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792097736;
	bh=8TFgXrqm00gTUkYWKQDkyq2nEt87hZ1bR+nt+jFn4KY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XCuEMW7yHvNa50Pc6fIRq4R8fcDklDEWseu5tr0BYxA0IbOwzi6ITi6byt/65aEZY
	 0ZLGI3dMg/qPwXPn4C8/vU19Wo1FMJeLNk0RcrGWhGMTDLLpfZvt101yv361ucNbpI
	 zRPwxthqgmCDRv/FO+pBLamGCP9y+0EAk75J5lMOClITzjwy66uwtOGgGykY7L1gSY
	 VmgZcTbSDCX+KclTo0XSyR5YWN1PndmspkIylE0+ABa50gIBJXFM4fPtPdruv/9ifg
	 s+1oKs02FbeBweIV4REWCqOXZAS8mV/+Sai1Qb18HcDfaJzYiPJeHKGbsObrjqHITd
	 wG3XocqFBC3sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F05CCA464;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
From: John Macias via B4 Relay <devnull+dencity7.gmail.com@kernel.org>
Date: Thu, 15 Oct 2026 13:55:25 -0700
Subject: [PATCH RFC ath-next 2/2] wifi: ath12k: bound READY MAC address
 array reads
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-rdy-mac-array-bounds-v1-2-5de276b752a3@gmail.com>
References: <20261015-rdy-mac-array-bounds-v1-0-5de276b752a3@gmail.com>
In-Reply-To: <20261015-rdy-mac-array-bounds-v1-0-5de276b752a3@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, ath12k@lists.infradead.org, 
 John Macias <dencity7@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097735; l=1848;
 i=dencity7@gmail.com; s=20261015; h=from:subject:message-id;
 bh=Q7bR+qmBnYByCGbR1Dt5w8wYWTuypEv1iCd0orMgbPU=;
 b=ep45ZWSDL6ranuUgrWsBGU9OMaYKx7UAoVEQdVgNNlPaBcT+MtrLTsK4H+er3Zk+QobJQE5tK
 eD+x4sEMsHBCGHkLiKnE5Bhwd282SAFQnUWslyydsc4jEQWSLCDKlfz
X-Developer-Key: i=dencity7@gmail.com; a=ed25519;
 pk=z7cMHA0B6NULvJzsST/bbOOegMB6xCo9+/ytQure7B8=
X-Endpoint-Received: by B4 Relay for dencity7@gmail.com/20261015 with
 auth_id=1198
X-Original-From: John Macias <dencity7@gmail.com>
Reply-To: dencity7@gmail.com

From: John Macias <dencity7@gmail.com>

ath12k_wmi_rdy_parse() has the same pattern as ath11k: after checking
that the READY fixed record advertises at least num_radios extra MAC
addresses, it copies one address per radio from the
WMI_TAG_ARRAY_FIXED_STRUCT TLV without checking that the TLV actually
holds num_radios entries.

With two radios and an array shorter than two 8-byte entries, the second
ether_addr_copy() reads past the end of the TLV value.

Check the array length against num_radios before copying. When it is too
short, warn and leave pdevs_macaddr_valid unset, so the driver keeps its
default per-radio addresses instead of failing READY processing.

A userspace harness that includes the unmodified parser reports a 6-byte
heap-buffer-overflow read under AddressSanitizer for 8- and 12-byte
arrays with two radios, and the fixed parser passes. Compile tested only
(ath-next, W=1).

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: LLM
Signed-off-by: John Macias <dencity7@gmail.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 75b259990c..ef070ace08 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7099,6 +7099,12 @@ static int ath12k_wmi_rdy_parse(struct ath12k_base *ab, u16 tag, u16 len,
 		if (!(ab->num_radios > 1 && num_mac_addr >= ab->num_radios))
 			break;
 
+		if (len < ab->num_radios * sizeof(*addr_list)) {
+			ath12k_warn(ab, "ready event mac address array too short: %u bytes for %d radios\n",
+				    len, ab->num_radios);
+			break;
+		}
+
 		for (i = 0; i < ab->num_radios; i++) {
 			pdev = &ab->pdevs[i];
 			ether_addr_copy(pdev->mac_addr, addr_list[i].addr);

-- 
2.47.3


