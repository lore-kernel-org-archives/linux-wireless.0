Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6548E0E3;
	Mon, 19 Oct 2026 10:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404339; cv=none; b=AJmbFlo8ktHSPsDPomjDHf9jHjzNBo2Fo6rqku3YVrbNBH3ew0nrMVwVsCo6Zmt3Qw3KeDGJDlKvCvvQ1oSzCy56OQyfmH/PTXXWTRlvXzAjXnLK8zWNZ0c5ZLk/DdjtVChsJHUwUH/iQW7s/4eA1OwaZZH9KacUYw7EpIVkce4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404339; c=relaxed/simple;
	bh=3MsWimjF2Sp2CM7pxoq2AWDoDxMpPqimhI9VAK1K9gE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gdKUL4TBI2y57iElmwvU04LVMRHKYB/CazKViQfSpItQbkfHDm5llq+uUShTMD0EF0YySZgSBZScRpbV/NzP8ctonmOxhN/+JrAJ4XScb/KhPQIIOgNF7vCorUpjt795dhQa2LmWDV/b23il1qQu1v8AowaKGF4ppRc9G07oqPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mAL1G0s/; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mAL1G0s/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xc
	r+OqoUcITsKTwGaq9wr934BlFKe6EzcTzLsyKcT14=; b=mAL1G0s/PJzK+R99GP
	Jk7BAVu7IMLiXTUOWoUWpYPNOXbBucdj8wsxpBsaKrEsEgVgGloaqDmICTqRtQGc
	gC+EnvaVH+soQhOI2iIMpFtAMVAkBZ67o+QylbzltOJecz7wa6bKWe0/zfR0p6J3
	qnc2Fw0QACUkAEh1LVDimkYJA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnLyhT69VqOE_ABA--.43992S3;
	Mon, 19 Oct 2026 18:05:10 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Miles Hu <milehu@codeaurora.org>,
	John Crispin <john@phrozen.org>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/4] wifi: ath11k: validate extended regulatory capability count
Date: Mon, 19 Oct 2026 18:05:03 +0800
Message-Id: <20261019100506.1915181-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019100506.1915181-1-yaojiale02@163.com>
References: <20261019100506.1915181-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnLyhT69VqOE_ABA--.43992S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF13CF4UuFy7Aw1ftr4rGrg_yoW8Gr43pr
	WjvF9FyFyUJF47C3yUAF4xAFy5uan3tr43KrW5t34fuFyxCF4Fv3WYgFyjvr4FyayDJFnF
	gF40qa1fWF98t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi0PfLUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xYgWmrV61YC8AAA3z

Firmware reports the number of PHYs separately from the array of
extended regulatory capabilities. The TLV parser rejects excess array
entries, but accepts an array with fewer entries than the reported PHY
count. The subsequent loop uses the reported count and reads beyond the
supplied array.

Reject mismatched counts before indexing the capability array.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index bbca275a8289..995fee2ffdfa 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4859,6 +4859,13 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
 		return ret;
 	}
 
+	if (svc_rdy_ext->n_ext_hal_reg_caps != svc_rdy_ext->param.num_phy) {
+		ath11k_warn(soc, "invalid number of reg caps %u, expected %u\n",
+			    svc_rdy_ext->n_ext_hal_reg_caps,
+			    svc_rdy_ext->param.num_phy);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < svc_rdy_ext->param.num_phy; i++) {
 		ret = ath11k_pull_reg_cap_svc_rdy_ext(wmi_handle,
 						      svc_rdy_ext->soc_hal_reg_caps,
-- 
2.34.1

