Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478549A3AE;
	Mon, 19 Oct 2026 10:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404349; cv=none; b=AtyJU4meuovgtKgfOv/82byW71VYuwubU/x3y+A9XPuo/vVrylUaoZ9nJq8521elDEKCXePwfLYgJgjpy4LzMVQLHVC4bbNfdT/aReX/5J2QSeiM0n5dxsSss8O7CfANYBweH8cfnSC1v5Kczx0yl0n/9Q894d/7rclcF0KFyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404349; c=relaxed/simple;
	bh=cmLH/ycCNvs1cslTh6wqSAW5gYflw07bckubyrv4I+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LiVUaeMP9EddQO6+qCrOBvXkpnDox4f4DmGffjACMXEDKmMluWr+WssGrKX0a+25CeuHMlGYNba7ryGmvJL/37XF1DZir8HAuSgyr/Zh6rGjh6gaJ4AdhBu3g2UNfM5Bc6NfjC/0CAhJtTZoG+pcePIdvwDTVbra9HeGYclrsxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EVJSNz/n; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EVJSNz/n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=x/
	lTBcvbDBAETbw6KOJHM2bPYpGYh6uRe7+houmWly4=; b=EVJSNz/nEqhy9DLwmr
	iqglyHq26MpxkwDWfTKPNOOD/QFRcBzrEu1MQhYI8kKuIOCA6Q0gcAOpV8cCVGyM
	wSVkMM7QOUvDlwKH+6A5qQx3UO7AdRz4n6Cf2mPzLE6LDFqTXD5wN26LKI92bxr+
	tvy/0B1dfZC1ENfMz+Cha8n9Q=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnLyhT69VqOE_ABA--.43992S5;
	Mon, 19 Oct 2026 18:05:12 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	Muna Sinada <quic_msinada@quicinc.com>,
	Rajkumar Manoharan <rmanohar@codeaurora.org>,
	Bhagavathi Perumal S <bperumal@codeaurora.org>,
	John Crispin <john@phrozen.org>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 3/4] wifi: ath11k: validate ready event MAC address array length
Date: Mon, 19 Oct 2026 18:05:05 +0800
Message-Id: <20261019100506.1915181-4-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnLyhT69VqOE_ABA--.43992S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7JrWDtr4rKrWktF17Cw45ZFb_yoW8Jr1Upr
	WfJ3Wjyr97Ja17Xw4rJa1xuFyrG3ZxJF17trWrK34F9Fs2vr15CF98WFy5Xry5tr48JF12
	vF4jyrsxWF90v3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pM5lbXUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BghW2rV61iALQAA3z

The ready event reports the number of extra MAC addresses separately
from the fixed-structure address array. ath11k checks the reported
count before assigning addresses to radios, but does not check the
length of the array TLV. A truncated array therefore causes reads past
the supplied event data.

Validate the array capacity before copying any addresses.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
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

