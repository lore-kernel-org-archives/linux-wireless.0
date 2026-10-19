Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043084B0495;
	Mon, 19 Oct 2026 10:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404063; cv=none; b=CbJXFDAwyI4P4wvGKdkL41yorbGgTHBbY5HqG8GBKdiDAM3lK72xwIyXw+gyFizLP8sF6p5gassW3GMNdWiM34zFIlThhNXdqTGIV5cc0i82f+nAxmI6A6QRmx+ukITyuUAlEm0WN47I9IeCxMGJ0qylL0mwyvyd26TOJojLESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404063; c=relaxed/simple;
	bh=o7PHV/H0O4xcHVnBleuUSc1rRGkVawNYz265mQHrXf0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qrR1aUOp3P6gMspckkBPd+KgvEcO8734l7rdYJRS+Qk7awR/oHo+T4/XxGgk9ZBv8LijSgVAAZi5+ASwhj20j6KQ2WMEOo3/IBH3U0MjW4e5+g7hdNTdasGZfczhflzfJoUnartu3E5QNegz13I2S+bTiwFXV/45GLiEFUFAHRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bOG+PieI; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bOG+PieI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=sR
	tR6Rf0lOjFcqMZnmsJM6N8yaS8cB3caDn96Mim3r8=; b=bOG+PieI1bi0QPuw2w
	9hgw/ShsaJ8M8VvC6mM0zSZzYMGehiilboy+pyIYxEI8TCtI/1HPaJU90peCw8nV
	FxlRua90hXF0XujrCZGdkbzc1GlfPXOKi/ryGYeCkPqfc3xXmZoy+tCPbS7xoDWt
	Hlnz/O8oWVCt13/AqwM4q8Vd8=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3E3g+6tVqofy8Ag--.62619S4;
	Mon, 19 Oct 2026 18:00:34 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 2/4] wifi: ath12k: validate extended regulatory capability count
Date: Mon, 19 Oct 2026 18:00:27 +0800
Message-Id: <20261019100029.1908660-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019100029.1908660-1-yaojiale02@163.com>
References: <20261019100029.1908660-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3E3g+6tVqofy8Ag--.62619S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr17JFWkAF1rWw1xKFy3Jwb_yoW8GF17pr
	4Y9Fy2kF98JF47C3yUAF4xJa45Za1DJw43Kr15Kas3u3WxAr4Yv3WYgFy5Zr4rt3yrJF1a
	9F40q34xCF98taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jz89NUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQLaFWrV6kI7mgAA32

From: Jiale Yao <jiale.yao@example.com>

Firmware reports the number of PHYs separately from the array of
extended regulatory capabilities. The TLV parser rejects excess array
entries, but accepts an array with fewer entries than the reported PHY
count. The subsequent loop uses the reported count and reads beyond the
supplied array.

Reject mismatched counts before indexing the capability array.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00..66e39672dcda 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4824,6 +4824,13 @@ static int ath12k_wmi_ext_hal_reg_caps(struct ath12k_base *soc,
 		return ret;
 	}
 
+	if (svc_rdy_ext->n_ext_hal_reg_caps != svc_rdy_ext->arg.num_phy) {
+		ath12k_warn(soc, "invalid number of reg caps %u, expected %u\n",
+			    svc_rdy_ext->n_ext_hal_reg_caps,
+			    svc_rdy_ext->arg.num_phy);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < svc_rdy_ext->arg.num_phy; i++) {
 		ret = ath12k_pull_reg_cap_svc_rdy_ext(wmi_handle,
 						      svc_rdy_ext->soc_hal_reg_caps,
-- 
2.34.1

