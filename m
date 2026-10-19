Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FC2496D53;
	Mon, 19 Oct 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404334; cv=none; b=ivSsg8T9T7S0ZjbVoe6jA6j8qtQfrFTGvtZ5BkTQj2hIovF8+ujSnt13hyaihVPbb+baJDVVyNz/LS+s1iQF5edQDUwen11oBLHMY9MEYnQMLWB7pwLuMAKV2EVxm2AYNJtiaQIPnzIabfHJIwHQWb87dWf4KOgpjOag4DzS9RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404334; c=relaxed/simple;
	bh=ujqVSjjwQb4U4UW++LG/5q4TL2JMtyIhcBfJGde7+0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xb2rZjvqx/26c9vbvDU4WUnIN7Fi1L5HKwYxE3yR5jpNBboPOfU4a0RRQ5S/VW946+KHLOhPhH2jI/UeQEewcBrekDtv0ysLOOdRUmm/8UJd6Ft0D4YaMOi68F6+nrdNSAQQ/uCzQEvbqKn+0bopPBpdwC5qjuf5WZggEx36BvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j0Slfccc; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j0Slfccc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Rn
	lkJFAVcMP2fmlDBCKbYyby2RpC8jzhOLmx2fC3lOs=; b=j0Slfccc+di3F+2YEx
	1uFCvaFVTg+EtWipMBFdDP8XD7voYDvD4amdTgxcRCYak/QF4MdYT9okRPBIpAGy
	5HOKlQo7btCIaW9KM/m+xuwULMl71GY2xAtC8ppLKABSibrPB85AO8IoN/lVN5j6
	GIr+Uaupf0FlcdPFLfE6Dmsnk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnLyhT69VqOE_ABA--.43992S6;
	Mon, 19 Oct 2026 18:05:13 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 4/4] wifi: ath12k: validate ready event MAC address array length
Date: Mon, 19 Oct 2026 18:05:06 +0800
Message-Id: <20261019100506.1915181-5-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnLyhT69VqOE_ABA--.43992S6
X-Coremail-Antispam: 1Uf129KBjvdXoW7JrWDtr4rKr18KF15trWfuFg_yoWkKFc_WF
	WFywn7X39rC3W3K3yjkF4SvrZ2k3WUAF4kWr9avrZ3Ga9xJF97Z34rZry5XryDGrWDAFn3
	Crn8Ga1xZ3s0gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiCzuDUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xkhW2rV61kDQQAA3D

The ready event reports the number of extra MAC addresses separately
from the fixed-structure address array. ath12k checks the reported
count before assigning addresses to radios, but does not check the
length of the array TLV. A truncated array therefore causes reads past
the supplied event data.

Validate the array capacity before copying any addresses.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 66e39672dcda..0ae366e8a944 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7082,6 +7082,9 @@ static int ath12k_wmi_rdy_parse(struct ath12k_base *ab, u16 tag, u16 len,
 		if (!(ab->num_radios > 1 && num_mac_addr >= ab->num_radios))
 			break;
 
+		if (len / sizeof(*addr_list) < ab->num_radios)
+			return -EINVAL;
+
 		for (i = 0; i < ab->num_radios; i++) {
 			pdev = &ab->pdevs[i];
 			ether_addr_copy(pdev->mac_addr, addr_list[i].addr);
-- 
2.34.1

