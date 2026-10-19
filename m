Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A374A64D5;
	Mon, 19 Oct 2026 10:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404069; cv=none; b=dqauAMNq/YmY9ZEplc+Ks4bVUlYo0gcVTaA1BMP2arIeZF1RGVSTu76+LYKsgmqz9rmtsdNI/87S/6mvyPT2eD4UTV8kLcqxoDoiLp05KSEEeFv1YHrJ1rbOlEIPgdszX/GzuYZJIV41KqGNCeK20SFSgdMvS4QI7oav3Ayu+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404069; c=relaxed/simple;
	bh=ts+LuTaIyRVoJduHHGP1IUVBvSl2NSDgHCZBbwLwPrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PQUPD1h17BjXjxGuuKtcuFmzuPEfRTHY5WYd+/7b12cYGIdwGbyzS6M3ibb1+C0EqNZJhZKxufkGFe+ODFwwaktk+FPRhjHeGmvtp2BHgRKfhR0i12iHdu0yTkzU6U0dgoBNUlmlCF6meSOyNQOAvmbsHoLkJj/HX+JEsdSNF+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Xy4H/F3f; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Xy4H/F3f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=RI
	rInL137ITvZYEldVyaB5myPr+oh/eeEduzPMDUH/s=; b=Xy4H/F3fyboTprtHtG
	kZ7uN02zsAPLJYbAdrVDAy1hvYrZzALaj9OslKLFip1xdgeJ4TWOFb+GVNSB2061
	HqmamC/redf6Ig8OYhaYDH+2HNeZJWDFj5BCbLUigZ/qOp4W5Y7hLuJlkOQou8gH
	/YpotwoGOegiN6WpabrHFYewA=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3E3g+6tVqofy8Ag--.62619S3;
	Mon, 19 Oct 2026 18:00:33 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	kbuild test robot <lkp@intel.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 1/4] wifi: ath11k: validate extended regulatory capability count
Date: Mon, 19 Oct 2026 18:00:26 +0800
Message-Id: <20261019100029.1908660-2-yaojiale02@163.com>
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
X-CM-TRANSID:PCgvCgC3E3g+6tVqofy8Ag--.62619S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr17JFWkAF1rWw1xCFy7GFg_yoW8GF4xpF
	WYvFyjyryUJF47C3yUAa1xAFy5uan3tr43KrW5t34fuFyxCF4Fv3WYgFyjvr4FyayDJFnF
	gF40qayfWF90yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeXdUUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8AHaFWrV6kFkDQAA3D

From: Jiale Yao <jiale.yao@example.com>

Firmware reports the number of PHYs separately from the array of
extended regulatory capabilities. The TLV parser rejects excess array
entries, but accepts an array with fewer entries than the reported PHY
count. The subsequent loop uses the reported count and reads beyond the
supplied array.

Reject mismatched counts before indexing the capability array.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
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

