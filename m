Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793247515;
	b=AQv/aQvHr8lW8y7a4Mllg/MDexQYQmvrwK0U7X82aMxH2UaZtb9AzfWzSAV8ah218P33
	 92AnrSsGY7/xpaJwK2XmZ8QKUWhP/qCvTPsQ8tDcC5epF9SDzKPF8gEZRbigdwOm1wuvs
	 Z0TFLxMpFEdi4qbQPQP7GNnusAtlsNhp+SoJ5TGJRid4cgXEq/OEpx33/cVxVnWYsG6Gl
	 IBJf82MBZeTZLtNZF3oOeE5Kji2hzzEYcACjueann8FD1nWjOzZboSzcBBcYZyM8BwCBm
	 UXHu3Mj20vrJ6o8VG2T0yL7yA2ESoz7fuaagChr5oIpFUY7drD/ZkzFhbA5rdvrG6Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793247515;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=7zOgXiaHhlEwWC6Yfc1EB6/zxOl2FQ3wcptFbEXmBUQ=;
	b=hQCfCdnuVNKxzBjC4u1hjCf/MpPhXmwy2EepR26cB9pLlhy52mzt1X9+MzB7pDfuJk1B
	 F37xEXFDIfuDs19Q/Ijj4cYcAF+gdyEdmnlDz9XygG+bbVf/EmP9tui9U9aZTJzpuZ+mz
	 zstcRdpy9yxWU+6dimAk0jTIBRYQ7eGyI3QYR+LT5rjZCgf9wnOELH4kqBNMXXgGhd5yt
	 KB67ELpb+tVgtEtHG2AqDXRzaE9rz5R7aLekauq3X1/jjcBAcnOXKY+0kxjr312NDTcF7
	 HcI1Vhm+uy4fhI8qskXpqSkcj/kI6QFY9KPrLBQcQHlxrKQmVZks9xdGKQ68gZ9Bh4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XFWTzLfa;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385E9606A31A;
	Thu, 29 Oct 2026 04:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 385E9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XFWTzLfa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7z
	OgXiaHhlEwWC6Yfc1EB6/zxOl2FQ3wcptFbEXmBUQ=; b=XFWTzLfa5RrY2BMNe2
	fVwV+NS6jH3cLfWlswU7TRzytNb8MZ3ZxTqRpmuywJs8MUPdqdK0H+pDQ/qVXzEb
	vdGe8arjL1PIDLXB9phQTjsAU1SGZ4vrc6eb4j3mMy2bFlW6YkHFHBmCgj3urKjL
	cuRBZaZiTOrIMj3CLbeGiyDNs=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3nzIDyeJqQW5fDg--.62716S2;
	Thu, 29 Oct 2026 12:18:12 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/5] wifi: ath11k/ath12k: validate capability TLV lengths
Date: Thu, 29 Oct 2026 12:18:06 +0800
Message-Id: <20261029041811.2379878-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3nzIDyeJqQW5fDg--.62716S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWDCryUuF15tF4rKF45Jrb_yoWDAwb_Xr
	Z5K3sFvw47W3WUta47Kr17ArWSyrWkWF18GayjyFWjqFs7ArWY9r97CF98ur10yaykAr9a
	9r4DWry8Zr1agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUb66zUUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wTGAWriyQTt3AAA3Y

Several ath11k and ath12k WMI parsers copy fixed firmware TLVs or count
nested TLVs and later consume them as complete capability structures.
The generic iterator validates that a TLV fits in its enclosing message,
but these tags have no minimum-length policies, so a short element can
still cause an out-of-bounds structure read.

Add policies for the DMA buffer release, hardware mode, DMA ring, and
extended MAC/PHY capability TLVs used by these paths.

Changes in v2:
- Validate both the fixed and nested DMA buffer release TLVs in ath11k
  and ath12k.

Jiale Yao (5):
  wifi: ath11k: validate DMA buffer release TLV lengths
  wifi: ath11k: validate hardware mode capability TLVs
  wifi: ath11k: validate DMA ring capability TLVs
  wifi: ath12k: validate DMA buffer release TLV lengths
  wifi: ath12k: validate service-ready capability TLV lengths

 drivers/net/wireless/ath/ath11k/wmi.c | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/wmi.c | 14 ++++++++++++++
 2 files changed, 24 insertions(+)

-- 
2.34.1

