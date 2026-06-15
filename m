Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5C433F377
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 12:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781526207; cv=none; b=XlD9FcQIzv8HkhAhMmWJh6v7mwa6uJ8SqlhXwlvpiOPrAmN2dy3SaaY+OQ4ST64LcnWNFAW90KfU953VQUdBsNyurlLh9GBODgtVDG4LTDrmHc/equ/SaUZqHyTWBSWPu53mckGU9lU7RuFnbgSPcjJJUunfdFgcoXaA16u5w4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781526207; c=relaxed/simple;
	bh=9AhUzTPXW06iepjicTUk8KdUkKVvFXLZUIYC0xH75Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+g5ghNULQ3cF/xM8Ig2re1un3H6eaY5w7coZ4TCovDSBWuU4+EgMrFKj9DweqcvRTe0sefUNo9H2w9Alx9kURPIh6V+JaopP+DksRlx1zvl3kSiG56HZS5Bmi4xpzLUBB3pcQk/XoA0JF0GIrf75zadnMr52AymhdEkO+Yabjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUm+VOIY; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUm+VOIY"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aa7a7c9711so3614915e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 05:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781526204; x=1782131004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NxNwzg+e+NRp49UH9pl97KcoyF640OFUJSGThEXSWcQ=;
        b=GUm+VOIYllYVkvRxmQtrvp+Hls9NTGyRRj+H0Mj4NMXeAAkce0/r5OpY8x1SsZ8ug4
         ZS0uzs94krtYnTstbzv66kgQdCzyOzhk/zTN005yDqZhBHFOSQtrPWtm4ZshQDttqFEg
         aM4b47NDznyUclMJSLQFP0AuNOXgy58fOY59uFExHbyRWQDGyY573E5+14XAhbHFis9+
         WP73ekHR4U/q0kpgNrXf3Cuk0TYdrMDtw8yEqi9iNNIpUKUOUSy1pPiY/E73kDm5fGtU
         nuCPFvUDiSm9IOwB/yTYdjsY3Gxi9VVYnFphlokvZjFSKPGVyxnFv0I+2FSDFseM/fAK
         cfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781526204; x=1782131004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxNwzg+e+NRp49UH9pl97KcoyF640OFUJSGThEXSWcQ=;
        b=FgIMRd/8EoOXYI390v2o1i3uRJX2RRyXUcIBRwN0S+G164159NEKVGes04ToUMH6BH
         /PdMvnlof49Q7T5Veiq/7XK1YNMo14RjuUChPrqnvIVP8KDdNIWF0ZgW4Ow5ixPvOz4f
         piYjRBkiv4xRR6mXbuN0ZUkFfb7ydwFnKTpKAJb4z71I/eJW83bqAF3uAfMQcRPWLEFf
         LD4j0+HOncguePlRDaZRi63HzSdFYJFWqtpQUfHN/vyAu4BKaJxP/sWpQok6SSPtLjLd
         6mHENV20b1SFvQDB4JX9NJupcm3384yREsEI1WSu2pvHwEeUl76T+2YhSROXXqNfh6vw
         VxQg==
X-Forwarded-Encrypted: i=1; AFNElJ/nf2mAawupje+ZdjRWbfjRVe8FcNchIOjSGKJkZLmGfh1knHlCchGE/HM9pqZtLjpxYoJEZcNLJfG1vRy7KA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHixldt89GuPZpaMs5wCK3qjBWeXZV0HiplhI1NKjk8kqGsuD4
	BA0ZK9/kRd79HrrHK5BrkZA5tu2FTWLYl3ymxfvlygS7fAWi42FA1CJ9
X-Gm-Gg: Acq92OEq34sHhxqT2uv/GsAwRpyIb6ze134qaJE1aVRuVmlJGwZHEO20+/blzLsW+ct
	1Mn/+OB2UCGd4Fz9IXTevQ3eJDiN3B7UbSFM9Q9zjV+sq6QLJvEVRhJFEE/z3J/8MvY5/EavNAu
	ychnBMd72oln6UCXoyP6tMEHTEIzzUoI9qZu6dhKSx7FpYAWmlwRypU8HlXPq5RyTtt6+OSY4nz
	obKyj7yS6Dc43dfcCKPRtOEzjMUv1blboPDoPrbQ4MDkWyofNMZnhwm6MUy9fAHSQzopyqSEePg
	4X1Im+4ovqP0a1wT3ABVpD6Ql86kk0D8V3GDli9m5FfhISlh7A+GgsxRbwE8gW7d4L+/itcm2Ia
	wAN1BRHDPxTE5b42Xumvb53vO1Ee+SxBiH3+iseBdgiOWd86DtZkbQx0axun7nzAOOisBQqx+F8
	b4RctFWUgUBn9FLLiasZHIku3zwJr/NX9tuXkni6P6ifyikB5E57joj0fNb3kZMhQFNTXN20k=
X-Received: by 2002:ac2:51d4:0:b0:5aa:8827:73bd with SMTP id 2adb3069b0e04-5ad2e13f751mr3102317e87.23.1781526204433;
        Mon, 15 Jun 2026 05:23:24 -0700 (PDT)
Received: from cherrypc.astra-academy.ru (109-252-17-231.nat.spd-mgts.ru. [109.252.17.231])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e1a7092sm2656037e87.50.2026.06.15.05.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 05:23:23 -0700 (PDT)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nazar Kalashnikov <sivartiwe@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Luca Coelho <luciano.coelho@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.15/6.1/6.6/6.12] wifi: iwlwifi: fix 22000 series SMEM parsing
Date: Mon, 15 Jun 2026 15:20:58 +0300
Message-ID: <20260615122100.137560-1-sivartiwe@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

commit 58192b9ce09b0f0f86e2036683bd542130b91a98 upstream.

If the firmware were to report three LMACs (which doesn't
exist in hardware) then using "fwrt->smem_cfg.lmac[2]" is
an overrun of the array. Reject such and use IWL_FW_CHECK
instead of WARN_ON in this function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110150012.16e8c2d70c26.Iadfcc1aedf43c5175b3f0757bea5aa232454f1ac@changeid
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
---
Backport fix for CVE-2026-43172
 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index 3f1272014daf..e2fc2f5de442 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
@@ -6,6 +6,7 @@
  */
 #include "iwl-drv.h"
 #include "runtime.h"
+#include "dbg.h"
 #include "fw/api/commands.h"
 
 static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
@@ -17,7 +18,9 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 	u8 api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
 					     SHARED_MEM_CFG_CMD, 0);
 
-	if (WARN_ON(lmac_num > ARRAY_SIZE(mem_cfg->lmac_smem)))
+	/* Note: notification has 3 entries, but we only expect 2 */
+	if (IWL_FW_CHECK(fwrt, lmac_num > ARRAY_SIZE(fwrt->smem_cfg.lmac),
+			 "FW advertises %d LMACs\n", lmac_num))
 		return;
 
 	fwrt->smem_cfg.num_lmacs = lmac_num;
@@ -26,7 +29,8 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 	fwrt->smem_cfg.rxfifo2_size = le32_to_cpu(mem_cfg->rxfifo2_size);
 
 	if (api_ver >= 4 &&
-	    !WARN_ON_ONCE(iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg))) {
+	    !IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg),
+			  "bad shared mem notification size\n")) {
 		fwrt->smem_cfg.rxfifo2_control_size =
 			le32_to_cpu(mem_cfg->rxfifo2_control_size);
 	}
-- 
2.47.3
