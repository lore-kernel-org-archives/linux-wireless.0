Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA34048E0E3;
	Mon, 19 Oct 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404334; cv=none; b=mVJ6r7l5m0VLJFfE1PS7y0qtOapwbfRSUAoMzSEjda3X0wQhEtZGOZitL18wbYzCr4xqNy4AZBHd5gHk59h2z74leIDuwveNLzQWynRsoTwWiNJOQVzseRbC2h5lyF3uNSBt4riqcG0AmOUiVRrzaxfeSjGCM7YuTCGLmjT3spE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404334; c=relaxed/simple;
	bh=OquhVR54zPvvzXYnaF2MJRJAutsVTTIh0r30P8nbx7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mKUCNDEKR+q9QW417VR6o+hWmKVPfhUdvEwsF1Ffgj7nk6pM1Vo526yOEVVCsaHb6yk1ybJ5os2+4ym06tXroIURqy9+UHaNLfAmyo5mbRFvl/Bu7X8IlQjx3zsUHZCnzwodVMncpl2hDH+hDAYdyBq+FQhJzbeIrSGlPN/0epU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gZNSvOd4; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gZNSvOd4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5B
	qts2upWMzH+47ykKr+dSq846IXymKS3c7i4G/GQGI=; b=gZNSvOd4wBE0AFVG2p
	J09ltE4SocWXHOGp3hV6rHWgTXnRXgXwDI101gY5eRV5r5S7UF6Jvl9lu7nc9uTI
	GN779ImruXVaAddvj8YRpxcx2TkG3a+QHWS8zKuVeSzL72xbY/FMyWmPOarSOBza
	UEHCawduIprnr+u+KJkiPIxOI=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnLyhT69VqOE_ABA--.43992S4;
	Mon, 19 Oct 2026 18:05:11 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Sriram R <quic_srirrama@quicinc.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/4] wifi: ath12k: validate extended regulatory capability count
Date: Mon, 19 Oct 2026 18:05:04 +0800
Message-Id: <20261019100506.1915181-3-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnLyhT69VqOE_ABA--.43992S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF13CF4fAFWxCw4kXrWfGrg_yoW8Gr1xpr
	4Y9Fy2yF98JFW7C3yUAF4xJa45Za1kJw4fKr43Kas3u3WkAr1av3WF9Fy5Zr4rt3ykJF12
	gF40qa4xuF98t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMT5dXUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BcgWmrV61d-+wAA3a

Firmware reports the number of PHYs separately from the array of
extended regulatory capabilities. The TLV parser rejects excess array
entries, but accepts an array with fewer entries than the reported PHY
count. The subsequent loop uses the reported count and reads beyond the
supplied array.

Reject mismatched counts before indexing the capability array.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
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

