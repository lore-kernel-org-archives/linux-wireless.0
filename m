Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D36F4C14F9;
	Mon, 19 Oct 2026 10:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404059; cv=none; b=WiDKbzyfQnt5eDUKV8UurR/ni/gUMDx0jAQ7Oc9/8Bl8XBseS1xrwpcjbAZPXE3J0mWKKYTyORmryCViSU0e3AOwJutECSUMppJZkRcDe3XnvN+EZ5YaCfIiZOFm31LzXt7FGCo+BCpY29GATLmsTgn45RjHSYDq3OqTNLTASMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404059; c=relaxed/simple;
	bh=gK0vaYMH5HRv14FTEF4yXnmP0vRMrh8nlWn5G9pJWf0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hsaDA7K4E+q1C58vn5g/dU3LTmNXLHCP6ELzZ+sLli1104ecQY/sQBnfZvXF7uemXDdVXjzRaBsuOjSZxR9wa6PZesVnNLTThAujab1Z86waBx3L2HVj5AaghCyPeDm3zQvDWss/n+F2tfeX50YmBPJTs89m879WRiN7LgNKsOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RK+gUZ/k; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RK+gUZ/k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7z
	1IH8d9WiJE9iAQ9sbSsv6NiWzZ4op7yrNpw6Ajsxg=; b=RK+gUZ/kLNZc+Z1Ury
	0cBdWzAdkV8jnX+8qRBoYpZW0UK3WsmWvfo6S1GWkYn61n5Jy3DAk2yq8NeRWMbS
	vQZA4Fd5kElH/pmSQksUxNQRWeXAqWDOdsAo06UF/wyPukhIZLiutIrzeL0/wMS1
	267lL7bQHas1DNcSyDkc12Glk=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3E3g+6tVqofy8Ag--.62619S6;
	Mon, 19 Oct 2026 18:00:36 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 4/4] wifi: ath12k: validate ready event MAC address array length
Date: Mon, 19 Oct 2026 18:00:29 +0800
Message-Id: <20261019100029.1908660-5-yaojiale02@163.com>
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
X-CM-TRANSID:PCgvCgC3E3g+6tVqofy8Ag--.62619S6
X-Coremail-Antispam: 1Uf129KBjvJXoWrKFy7XryktF4xJFW3ur15urg_yoW8JrW7pr
	WfWF1jkrykJrsrZws8Ja1xCa4rKanrJF17KrWF9a4F9rsavr1Y9F98WFy5Xry5tr4rJF17
	ur4Utrs7CF90qaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UQ0edUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQXbFmrV6kU77AAA3C

From: Jiale Yao <jiale.yao@example.com>

The ready event reports the number of extra MAC addresses separately
from the fixed-structure address array. ath12k checks the reported
count before assigning addresses to radios, but does not check the
length of the array TLV. A truncated array therefore causes reads past
the supplied event data.

Validate the array capacity before copying any addresses.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
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

