Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FDE4A689A;
	Mon, 19 Oct 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404350; cv=none; b=m1g6eyHuVTf9NHFjCNXhJ5/wOt6OYaxy3waMoAycCAyzguQnehw6JxebbqN+B0LVAXE5HO8kk13R0nzi1mYVWMWjRreS8pRT0I5NOQ1ftgo/IonLrZSWyUiUGEK03lwo6oYMImACcHhY3gEiLYLdiVYhs4aVNkZH20JnxcAkQJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404350; c=relaxed/simple;
	bh=V9FHCDlbHZ/Vbv15EqWjFGe76Y5HBU5DM2JuuPm7U7g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MGN8CyiJ/Zaj/IEesBsLW8F9t+kWi9b0sRrVTpPf4VJmcoz0jqFHxjXme2EfW2MFI/R5gK6H4fnwEhRin3HtsYmvZxyNYVgl7v+ZTh3gEJEBHJT2anxtr3y8TQelWh1kirpS0hoiJ24gHOsZrTEMiymU6M9Cahl3q8EJu2hmguQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JhU1hRxi; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JhU1hRxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Fg
	wZuL9W30hNH/mH6r7M7fmLLxrNmmb2Xswt5OIvzOg=; b=JhU1hRxi3HRnHriiE6
	ra+Gi8rc7KDxCmuJku+PnwpCMgF8J9kgzyHXIdGVtAlrK+ajA8ZgIne3RzI/sN9Q
	30/PuG8mH7TTzaG0ROpSPr/DrL5leWpPU3nfIldLq+eJAUUbr55C3S/zfG3NnyZg
	SA9GxnlKT1ZFNJsY4ep1jBsTk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnLyhT69VqOE_ABA--.43992S2;
	Mon, 19 Oct 2026 18:05:09 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Shashidhar Lakkavalli <slakkavalli@datto.com>,
	kbuild test robot <lkp@intel.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	Govindaraj Saminathan <quic_gsamin@quicinc.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Bhagavathi Perumal S <bperumal@codeaurora.org>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath12k@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/4] wifi: ath11k/ath12k: validate firmware array lengths
Date: Mon, 19 Oct 2026 18:05:02 +0800
Message-Id: <20261019100506.1915181-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnLyhT69VqOE_ABA--.43992S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry7CF45Ar43Gw1rZrWkJFb_yoWDZFX_Wr
	4ktrZxZ3WxGF4UKa4vkF1UZryFyayj9FykAFWUtFZ3Z39rArWYvr95AFn8ur1UAw4UXF9a
	9rnxJFWfZw129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sREFks7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRUgWmrV61VXTgAA36

ath11k and ath12k consume two firmware-provided arrays without fully
validating their lengths. The service-ready-ext parser accepts fewer
extended regulatory capability entries than the separately reported PHY
count, while the ready-event parser trusts the reported extra MAC address
count without checking the fixed-structure array length.

Malformed firmware data can therefore make both drivers read beyond the
corresponding TLV arrays. Add matching validation to each driver before
the arrays are indexed.

The four patches are independent and each addresses one parsing path in
one driver.

Jiale Yao (4):
  wifi: ath11k: validate extended regulatory capability count
  wifi: ath12k: validate extended regulatory capability count
  wifi: ath11k: validate ready event MAC address array length
  wifi: ath12k: validate ready event MAC address array length

 drivers/net/wireless/ath/ath11k/wmi.c | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/wmi.c | 10 ++++++++++
 2 files changed, 20 insertions(+)

-- 
2.34.1

