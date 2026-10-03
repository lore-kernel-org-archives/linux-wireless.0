Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA823B9D97;
	Sat,  3 Oct 2026 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019313; cv=none; b=tDmDxt5WWV2irIrY1iqwNC5+EBWQ0oJklut4jTxfxKePvmbMesSCNus898vpFznZBvQBJXRmI/a9KPc1kpDCumRGI2G6xReaWia/uKabeY+Uw9DPQU+ZrJMqzE7rzypbZi+kBKX3V7llJ0EWot+Mu/MlBWSS3wfJAsn1/ls/4/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019313; c=relaxed/simple;
	bh=P+WYJazsFhLKmSqczxPf/ms0L8fgL0loTd1fpuQ1uQk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H7e4DJuDiaZUEZDcxNv79If4OGa0Nh17k6VhSc1yDH14XXyE9DDq31WDcq9hdS1UHrCJ9lONBHGz8Dm4+50pHPDbTRNZIDV1mtOC1OV0HW7nOmBnehgHaco8s3cX94OmpD7jxIPN1N0ofO/WBggC2eIVEW8eziBlXTCJJ9EtVYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NbGJkTcV; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NbGJkTcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=AF
	ojHjA+4FDN4JhFb5+uFEMCc+xZ9O93LXDyh2k/6GM=; b=NbGJkTcVNbx9d34ixE
	FIMoN7zt/+04JJqHuln4jZqRxm6xwFd41lIBUgKlbaVfCrefiJc5D8PgIEQ2Qvk7
	Rb84NX0YrHwe/wvCYoIsu6cCkZwR0A9nCWJ1q9lorRETwhArejV7XgCADevC2uCU
	rTIei32CLCWzd07tRBnM6YyJY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3n1YCycBqC7WjCQ--.62376S2;
	Sat, 03 Oct 2026 17:21:07 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Shashidhar Lakkavalli <slakkavalli@datto.com>,
	Bhagavathi Perumal S <bperumal@codeaurora.org>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Govindaraj Saminathan <quic_gsamin@quicinc.com>,
	Sriram R <quic_srirrama@quicinc.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Wen Gong <quic_wgong@quicinc.com>,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v2 0/5] wifi: ath: avoid IDR mutation while iterating
Date: Sat,  3 Oct 2026 17:20:57 +0800
Message-Id: <20261003092104.520135-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n1YCycBqC7WjCQ--.62376S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrWxAw4kuF1kKryUKrW3KFg_yoW8WFyDpF
	4fu3Wa9F1xZrsrtr1fJw4xJFyrWan3CF1YgrZrCa4ruF4rCF1rtF1Yq3WfXFyUAFWxG3W2
	93yUtr1fCr92y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piY9akUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgQ+eGrAyQShsQAA37

The ath10k, ath11k, and ath12k cleanup paths walk an IDR while removing
the current entry. idr_for_each() retains radix-tree iterator state across
the callback, so that removal can invalidate the walk.

Use idr_for_each_entry() in each cleanup path. It performs a fresh
idr_get_next() lookup for every iteration, allowing the current entry to
be removed safely before its skb is released. Keeping the existing locked
removal helpers also ensures that a concurrent TX completion cannot find
an IDR entry which points to an already freed skb.

Changes in v2:
- Rework the ath11k and ath12k pending management TX cleanup patches to
  remove each IDR entry before freeing its skb, as pointed out by
  Rameshkumar and Jeff.
- Use idr_for_each_entry() for the pending cleanup callers instead of
  leaving freed skb pointers in the IDR until idr_destroy().

Jiale Yao (5):
  wifi: ath10k: avoid IDR mutation during TX cleanup
  wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
  wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
  wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
  wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup

 drivers/net/wireless/ath/ath10k/htt_tx.c |  7 ++++-
 drivers/net/wireless/ath/ath11k/core.c   |  3 +--
 drivers/net/wireless/ath/ath11k/mac.c    | 33 ++++++++++++------------
 drivers/net/wireless/ath/ath11k/mac.h    |  2 +-
 drivers/net/wireless/ath/ath12k/core.c   |  3 +--
 drivers/net/wireless/ath/ath12k/mac.c    | 33 ++++++++++++------------
 drivers/net/wireless/ath/ath12k/mac.h    |  2 +-
 7 files changed, 44 insertions(+), 39 deletions(-)

-- 
2.34.1

