Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6574BEE43;
	Fri, 25 Sep 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348830; cv=none; b=RpEN0tkKPIywzESDuuNSFkvGCkBOuzWTU5+ZE2zFdipHqC2votcCk1n5PQRmgYKuZ1vnuhONW9Z1c6PsFPjUoQZ5zue00hJ3jmQ4FiIIUD9z5JJrIvDy2HB5yKmdyc4YLztSLAJ1oyNZmsNmuqDt+A4ksNcZhoPsBACv8ELEiTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348830; c=relaxed/simple;
	bh=Hv3bmdzUw4/r+8TfNCdYJTMFiuJJMIfp4mRcW+Xsda4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PfkLdnTVOe5TdC400wknZRQSp09ajszifzO5judIyvaES4O049Hmc3OESbvARjXUviZh7YaXrVMnXZM5YWQz7CiXxsoI77QMc6ALruGt6elnKySryd35dGgrZtZDWDp6do8NhTJikZtpFVx3mQwsKqjWm+IxfsRiDnzmiybHpQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AqGpoukT; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AqGpoukT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=vh
	1u+AU53kKhXv1QZx33pP/jyG36QNPJdJIMmE/yVT8=; b=AqGpoukTycE0gDo13C
	C1yIOckO1Fgo7eCRuOYHL8uBoQ+sB4Y1cEBkFlu7tGsSScMbSLnvn34Fzs3fMl4Y
	KzINBKbwaB3BIjsj68Qr2Ichz2Yjco2d7TVaWFpFUbuCu51p2v1ruaUcJxxjzkqC
	VFIdoRPj7tNVPaSMg8jM9GMMg=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3J8zYjbZq2yQpAw--.5414S2;
	Fri, 25 Sep 2026 23:06:01 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Markus Theil <markus.theil@tu-ilmenau.de>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/2] wifi: mt76: fix USB copy source overreads
Date: Fri, 25 Sep 2026 23:05:53 +0800
Message-Id: <20260925150556.2304003-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3J8zYjbZq2yQpAw--.5414S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw15GFWUWF17uFyfCryrtFb_yoWkZrb_XF
	Wv9a4ft3W8JFZxtayakrWUAFW3Cayv9ryxCa4vqrWSq3y7tF1Uur1vvrn5Zw4Ika1Fkrsr
	Gr9rXw1Iv3sYgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU0eH3UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BnhHGq2jdknpwAA3c

The USB copy helpers round up the caller's length to four bytes and
then use the rounded length as the bound for memcpy() from the source
buffer. If the caller supplies a length that is not a multiple of four,
the final transfer reads one to three bytes past the source buffer.
The beacon write path can pass such an unaligned length.

The MMIO copy helpers already handle their unaligned tail through a
four-byte bounce buffer. Apply the same principle to the USB helpers:
keep the original length as the source-copy bound and zero the unused
bytes in the transmit buffer so that the register access width remains
four-byte aligned.

The two patches are independent and both apply to the same baseline:

  wifi: mt76: usb: fix source overread in mt76u_copy
  wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy

Jiale Yao (2):
  wifi: mt76: usb: fix source overread in mt76u_copy
  wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy

 drivers/net/wireless/mediatek/mt76/mt7615/usb.c | 17 ++++++++++++-----
 drivers/net/wireless/mediatek/mt76/usb.c        | 16 +++++++++++-----
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.34.1

