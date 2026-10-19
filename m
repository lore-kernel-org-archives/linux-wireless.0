Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ECD4CDA2A;
	Mon, 19 Oct 2026 10:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404067; cv=none; b=b6BBKuxG/ZCBHkJn3+Q+f0OqhHgPxXeDGkDV3Xjjl1Ly6sWeyChaBlo9A0LlVdCJc5o3RC/b3a3B8oHKifFavIgtzg/FwFrw4RPo6O5g2+/B3FnaPDuy/c38b9boCzRbkkmcqoxOgM3oZIcpzjI/kjo6+PJG3gEkGG05+QdVbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404067; c=relaxed/simple;
	bh=ido2wIx6CxleNGwAUfVG8Lb//0wB2ZAusGin4XQbPPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=umQINlaWA5LMn1mWdxHe94DjTbsSht0W86t96h9fGJcXhQS8VjwbuZhe/ns6zNGKoOC8M18s2/28Cz/LvUPQRpowj+67F723hG80QH/Zzui9HgG+MspaAcxRmdrCAGupesmqR9mcLsmijxbyGFtXUlVDO6eT2lGBr0r3UW2pnAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Wz5y5dd1; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Wz5y5dd1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=eQ
	FJWikUmdm5hTbH2JXMw4PDnsWnUwlmAWb7JNvs+K4=; b=Wz5y5dd1/tGzRF2FlK
	RQJxYGg0ulsAMuP8cEJDVqZXp6/OkKIWOPzu/8oF9s/38tBoeFR94/U2l3Ius8PH
	Oq8QPAlAkpgSsVm4ayRLyAUibL1370Lp7w+XI3W3JgZ8JIUKpb0NNqXJeaYJdmDm
	YLXOdawGBGRDHn6YuEF7k/EqU=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3E3g+6tVqofy8Ag--.62619S5;
	Mon, 19 Oct 2026 18:00:35 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
	Sriram R <quic_srirrama@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	Ganesh Sesetti <gseset@codeaurora.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 3/4] wifi: ath11k: validate ready event MAC address array length
Date: Mon, 19 Oct 2026 18:00:28 +0800
Message-Id: <20261019100029.1908660-4-yaojiale02@163.com>
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
X-CM-TRANSID:PCgvCgC3E3g+6tVqofy8Ag--.62619S5
X-Coremail-Antispam: 1Uf129KBjvJXoWrKFy7XryktF4xJFWfXw18Xwb_yoW8JrWkpr
	WfJ3Wjkr97Ja1xXw45Ja1xCa4rGanxtF17trWF934Y9Fs2vr1Y9F98WFy3XrW5tr48JF12
	vr4jyrsxGF90vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzxRDUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgPaFWrV6kPlOgAA3L

From: Jiale Yao <jiale.yao@example.com>

The ready event reports the number of extra MAC addresses separately
from the fixed-structure address array. ath11k checks the reported
count before assigning addresses to radios, but does not check the
length of the array TLV. A truncated array therefore causes reads past
the supplied event data.

Validate the array capacity before copying any addresses.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 995fee2ffdfa..9a048c7d9858 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -7328,6 +7328,9 @@ static int ath11k_wmi_tlv_rdy_parse(struct ath11k_base *ab, u16 tag, u16 len,
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

