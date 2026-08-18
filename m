Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E922E9730;
	Tue, 18 Aug 2026 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065032; cv=none; b=rWXSMgG+l1F4vT4r6sYeaXaKZcYCy046jp1SFtiFbsPWZr68we50NWwpqUxezY456Q+cudhUSLXevKqSaTmaC9RmzHFqWA3XNAxMgGozgkcRKMgvZUuuCYVJLk9uqTdX100VO8pndPzPQacfrJeU7T1Btv2u0goIp9hd3xlTDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065032; c=relaxed/simple;
	bh=jCepnyRQKiy/0fJYVvG5+hkJYE2EYxoa1PmVNU3I8nU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=N8HU1q7H0oqA6QHit/0Q8gb0PVQ4iODBAX1TIm6vYcTKwYSWV2Et2tBPBCv1QM9viY5zZXUlismWI3Yy8MkMBpggaBD05g53019vGuyzh+8idnl2w/0zNAhr/6M3gldpr7HMpzau1dybHZnDeeLxie4vJRW5RPKazGGYFeRXSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlG2V5Ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlG2V5Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1211F000E9;
	Tue, 18 Aug 2026 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787065030;
	bh=m7dVJLkNi28+BTlhsO3WjBgH7kpW+cZErXxqcXKNxuE=;
	h=From:Date:Subject:To:Cc;
	b=IlG2V5RofAupbPL4mXBtWcP1II1kkYrwfkFijrAKD6EDmc1cAaUQskgFP08KeSj7W
	 eP3KsuqOHQg1y0ushC6KK7vXuSKiyO0NoX3MQKCsl26RDqktrE07ZZS/B0L/3WhsyS
	 yNO85xUL3vy6JygEfGXIDfV6JlEbhgq/c8f1jamIOnIfr+YzJMfYn2d3Pen4/VEFP+
	 2JQLeRf/UoRKqEHFTFSH0e5lkC/p8+oVkT4OXKdm9Pi7+rN2+SosoDJMjl5EAtB/Bo
	 pMgLRuGSHU0uB8ztaosnROXTQhlksykMuxLXZ20AtHeYRm3Ric30sdd1IoY9g4ADh5
	 jm8jFerXJi3LQ==
From: Konrad Dybcio <konradybcio@kernel.org>
Date: Tue, 18 Aug 2026 16:57:05 +0200
Subject: [PATCH ath-next] wifi: ath12k: wmi: Complete regulatory update for
 dropped events
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-topic-wifi_reg_fix-v1-1-18c7c289e528@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywqAIBCF4VeJWSeYUFSvEhE2jjUtKrQbhO+e1
 fI7cP4bPDkmD3Vyg6ODPS9zRJYmgKOeBxJsokFJVcgyK8W2rIziZMudo6GzfAmtJFYqLzC3BuJ
 xdRTnL9q0v/3eT4TbW4IQHqD0uxh2AAAA
X-Change-ID: 20260818-topic-wifi_reg_fix-a20c9256c5fd
To: Jeff Johnson <jjohnson@kernel.org>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>, 
 Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787065027; l=1840;
 i=konrad.dybcio@oss.qualcomm.com; s=20230215; h=from:subject:message-id;
 bh=hvZ5AUZfou67LdEvHueGUsn8P6t9OZp7Fyj2rqGhT0c=;
 b=YegAy2qbb3sIHDaFpOU2QMaLFi9phuM0A3HuJNqUxyn5hdSI+uUZ+ZzlRY1iXJj7OkaFa3jeQ
 +Nm8DcWlng7DP6TO3koWMnwKw1JY5mHsd/mmdrGJQZx9okOv72Rk7ql
X-Developer-Key: i=konrad.dybcio@oss.qualcomm.com; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

If ath12k_reg_validate_reg_info() returns STATUS_FALLBACK/DROP (which
are not fatal), the code then jumps to mem_free with pdev_idx still set
to 255, making the following completion never take place.

That then results in repeating "Timeout while waiting for regulatory
update" messages, as observed e.g. on a Glymur-based ASUS Zenbook A16.

Fix that by updating the pdev_idx right after the actually-fatal case
of not being able to extract the reg info data is ruled out.

Fixes: 906619a00967 ("wifi: ath12k: handle regulatory hints during mac registration")
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00..4ac78ba6c790 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6975,6 +6975,8 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 		goto mem_free;
 	}
 
+	pdev_idx = reg_info->phy_id;
+
 	ret = ath12k_reg_validate_reg_info(ab, reg_info);
 	if (ret == ATH12K_REG_STATUS_FALLBACK) {
 		ath12k_warn(ab, "failed to validate reg info %d\n", ret);
@@ -6991,7 +6993,6 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 	}
 
 	/* free old reg_info if it exist */
-	pdev_idx = reg_info->phy_id;
 	if (ab->reg_info[pdev_idx]) {
 		ath12k_reg_reset_reg_info(ab->reg_info[pdev_idx]);
 		kfree(ab->reg_info[pdev_idx]);

---
base-commit: e6664f2b33db9b6811eb4cec109f06cb2b4f458d
change-id: 20260818-topic-wifi_reg_fix-a20c9256c5fd

Best regards,
--  
Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

