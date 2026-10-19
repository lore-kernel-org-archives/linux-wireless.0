Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF4E4C9E1A;
	Mon, 19 Oct 2026 10:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404066; cv=none; b=Q60azybazAXDAWoNKCak/pkqHJ7DX659pYyedR0BICBO+IFcECM6yvaJMuLH3rbK7TkRfBCR3XARPH796EqIqQHyuvajEdy6SrN/EuR1prd66glGqbPDhYSfqcEvDS1FrEy/rMJGNpr2qjm5JB/9rjYYU55bYfUsxPlhXX63ePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404066; c=relaxed/simple;
	bh=fgLIl1u3pgW3QAahjn3x2BnU1NuZQX2hKWiRj/fW6bc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NqT6565pQs2b9uV5bFOLIuqgzD66XcgLn4fNJMXyJ0hvIcxwrIGxJjzfaZZ+luhvQ1kwPu/xRnmm99V2QMjqGzyIKbpdnct60j4EqTYp4PLS7/Vqu9Ul9vna2GwI5S/qnTERHBKSrlAQsTTSw/OTsbaibAU3spQZfEFfTO5h9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Eho0Vz53; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Eho0Vz53"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lO
	PRAb0Kpa6dz/yQkxa87qgu8YqS6xHie1GJGb07jNA=; b=Eho0Vz53yXYFs+E0cT
	9A4MjpBMBfnMTkjrGuP7+Z/dAbionYDPrxzp+1TUnSilL/xRNsXzeE25Nw3ZHe6K
	OI+gEBlMd86zORItDni2rY6ZMtA72zsxFa+ITwFOonVcypWi0ksTIYtRAfUvrEGM
	C+k1XRY1/weILZAEHltNSObBA=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3E3g+6tVqofy8Ag--.62619S2;
	Mon, 19 Oct 2026 18:00:31 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	John Crispin <john@phrozen.org>,
	Kalle Valo <kvalo@kernel.org>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath12k@lists.infradead.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 0/4] wifi: ath11k/ath12k: validate firmware array lengths
Date: Mon, 19 Oct 2026 18:00:25 +0800
Message-Id: <20261019100029.1908660-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3E3g+6tVqofy8Ag--.62619S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFy7tr47trW8Gry3XryUtrb_yoWkJrX_Wr
	4ktr9rX3W8GF4UKFyvkF1UZryFyayj9F1kJFWUtF93Z3yDArWYyr95AFn8ur1UAw4UXF9a
	9rnxJFWxZw129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU81v35UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzh-ZFGrV6j-kzgAA3c

From: Jiale Yao <jiale.yao@example.com>

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

