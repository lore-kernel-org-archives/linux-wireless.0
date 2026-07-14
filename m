Received: from smtp.smtpout.orange.fr (smtp-82.smtpout.orange.fr [80.12.242.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B893F39DB;
	Tue, 14 Jul 2026 08:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784018378; cv=none; b=t8J1D+Ua9M+0bSqngTY5Y7SvAtXnVSiiVB48EI8ZyyQvj+wO166XoF2j+7sSdz5XIrUMgMvc39WPn2qoGwNS6mycgpCqr/L2hUgzcJgy/MaBh+QHoUBGb0SUJU20EHfCZqz4UAdrA8+tx552W2DL0nWnUPmVSZL7CEg1KhaT2PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784018378; c=relaxed/simple;
	bh=TcCXI5sFVNdiP4Aa9Hwri0N4gaCFblrR8MfWjNjDi9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ejpp8axpMMxSZ8XyyBrdctH9p1lIvetTDPV8QDpOF9wlH2Y98r8iDn1QZehqa6m98t2T/VKd0re/oUCp+CVdKdvtZ8/4/ZbThG7B70gTr3Iza31mOe4N5pxUrQpbCB457bKZKkJwEVCF5SIHpYzlgKoSRUg0MApZyjSbFZIBDIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=gRpPUzyV; arc=none smtp.client-ip=80.12.242.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="gRpPUzyV"
Received: from device-97.home ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id jYfgwv96VDc2NjYfgwPCKB; Tue, 14 Jul 2026 10:39:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1784018361;
	bh=QgPtgLnsf8qvRaDX9lHTjdZhI5SOrPpagXLEfKGMxTM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=gRpPUzyVFJ7IN1ZMiIuiUrY4DxYS+BmXLoy+qESTd3mhCKxiBX62etJWlTQsaFFhH
	 +hlJuYlmV8LbWRbHV5zatiSSl46bkRdY1QWp71diR+/6M7TIamrLZdFZvlxqsNPU/4
	 KBESBNgoa8kWk/q0LKT75K/C6SkvUD8UGOMGiYQ89FLUfnTRS1ParEWn/7qOyVCVhG
	 +DVi92IX087ztsVo8PzQtMcLy8rWNkGWZW5zO+AH7SNs5rznJevS8kHx9IGP9C7MHt
	 +cF6N3S+ARexkpAxO+4CH+BrNP4zzKPIm+9uDENf0lhVu4mbdcTdBE6h6dxtP+O8GF
	 Vrh4lKmhoUDOg==
X-ME-Helo: device-97.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2026 10:39:21 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: [PATCH v2] wifi: ath12k: Constify struct ath12k_dp_arch_ops
Date: Tue, 14 Jul 2026 10:39:14 +0200
Message-ID: <969d732e2c6f169e1aa5e89c7e01743a1adb55df.1784010931.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct ath12k_dp_arch_ops' is not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   6318	   3384	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   6478	   3224	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

Changes in v2:
  - Add the missing const!   [Ping-Ke Shih]

v1: https://lore.kernel.org/all/469d732e2c6f159e1a05e89c7e417c3a10db5fdf.1784010931.git.christophe.jaillet@wanadoo.fr/
---
 drivers/net/wireless/ath/ath12k/dp.h       | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 64f79e43341e..a94bbc337df4 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -538,7 +538,7 @@ struct ath12k_dp {
 	/* Lock for protection of peers and rhead_peer_addr */
 	spinlock_t dp_lock;
 
-	struct ath12k_dp_arch_ops *ops;
+	const struct ath12k_dp_arch_ops *ops;
 
 	/* Linked list of struct ath12k_dp_link_peer */
 	struct list_head peers;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp.c b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
index c72f604661ce..01a45f428990 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
@@ -139,7 +139,7 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k_dp *dp,
 	return tot_work_done;
 }
 
-static struct ath12k_dp_arch_ops ath12k_wifi7_dp_arch_ops = {
+static const struct ath12k_dp_arch_ops ath12k_wifi7_dp_arch_ops = {
 	.service_srng = ath12k_wifi7_dp_service_srng,
 	.tx_get_vdev_bank_config = ath12k_wifi7_dp_tx_get_vdev_bank_config,
 	.reo_cmd_send = ath12k_wifi7_dp_reo_cmd_send,
-- 
2.55.0

