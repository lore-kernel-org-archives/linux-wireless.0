Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793164400;
	b=kDLT95180Vt/FjSdY4thhICzu3CvN26vGq8Sajkc5YN4fJFwW9bh59NaAdewKkhFT2SL
	 8ZEFEJi40KHi67MgQFvT+DAt+7vOjjrB6Y2E7mHBmAz3rdNdpXUa0qgpAyZYx8QxE5maD
	 q3rGLKaapJL8SH1KOJT9ubWvvr8M+bavK8Wi7qePZSGIPvfVsR2qyF28T6GX6TIFCcCWr
	 VcYCvC+2BwFYUlppP+FNYncq1GzarjgfkM06jFRQs9LqMwOxw9QkYuNZNg/XrM4sxnD6X
	 4YeuiigFe3vQdktTAgC++Sz/Z6FcBNdVd21yCi37JVXHc1AeM/P0B59EDYMRahNEB4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793164400;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=8dYAfOXJbpf0cjqVZmnxuZ04yPrZrQrcWgodKK7vItE=;
	b=oAyyHozDl/ICL7oNlw+LIGuErx7O1+EQ1q1FLtLkn79O1DiM4lOSGop16cHcNY3LX4i4
	 6huWAccfjZog+A4tsHfDJgFl5n5JZJGARSAJ46Sg8NauwQByrLz2+ejIlNdj/3S9uOeDL
	 BYao+s4qm87V7XZj+DFG+Czr9r+Ugp+UoAIMHs4bZeq+wFRXkt1icYuTY+jstoxvzu0sS
	 IdhfX2JfyLr49w/MzOrZPY3WpmPY+QhVKW71OfAMXTKHosa5XL/jdi6I+byGNvTvmCs3s
	 h6f3EhL+1PDuRGB7KrLxh36zAgZJea0UPPugvcCyX91jmVwzh/ojHrEUjjLDsookCrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=g4pzlv7+;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F8606A32A;
	Wed, 28 Oct 2026 05:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C07F8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=g4pzlv7+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=8d
	YAfOXJbpf0cjqVZmnxuZ04yPrZrQrcWgodKK7vItE=; b=g4pzlv7+CJCwYsjf3t
	02F9US2tnUeAAPP44T1N7qqx8MJTwBCh95t0+EorZU6WdcZGPOekibMnWXV/ixGG
	CFU5U69zmGqIj/Dh4cGlo/75iFEckJQ94c3LvkhWCmCZnptyFxaGAuUZ0Vew0PEI
	s4HBQsHglcF2q1VgbFt3gdzzc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3_3lYhOFqTkVqDQ--.14113S2;
	Wed, 28 Oct 2026 13:12:57 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
	Miles Hu <milehu@codeaurora.org>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Bhagavathi Perumal S <bperumal@codeaurora.org>,
	Wen Gong <quic_wgong@quicinc.com>,
	Aloka Dixit <quic_alokad@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: [PATCH 0/5] wifi: ath11k/ath12k: validate capability TLV lengths
Date: Wed, 28 Oct 2026 13:12:49 +0800
Message-Id: <20261028051254.147628-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3_3lYhOFqTkVqDQ--.14113S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7uw15XF1fXFyfCw43trb_yoWfAwc_Zr
	WrKr9Fvw47W3WUtFWUKr17ArySyrWkWF1kGFWUtFyUtFs7ArWYvr93CF98uF10yFykAr9a
	9rs8Wry8ZwnF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8BMKJUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhlKhGrhhFkXBAAA3c

Several ath11k and ath12k WMI parsers count firmware TLVs and later
consume them as arrays of complete capability structures.  The generic
iterator validates that a TLV fits in its enclosing message, but these
tags have no minimum-length policies, so a short element can still cause
an out-of-bounds structure read.

Add policies for the DMA buffer release, hardware mode, DMA ring, and
extended MAC/PHY capability TLVs used by these paths.

Jiale Yao (5):
  wifi: ath11k: validate DMA buffer release TLV lengths
  wifi: ath11k: validate hardware mode capability TLVs
  wifi: ath11k: validate DMA ring capability TLVs
  wifi: ath12k: validate DMA buffer release fixed TLV length
  wifi: ath12k: validate service-ready capability TLV lengths

 drivers/net/wireless/ath/ath11k/wmi.c | 8 ++++++++
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++++++
 2 files changed, 16 insertions(+)

-- 
2.34.1

