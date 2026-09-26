Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069B372EE4;
	Sat, 26 Sep 2026 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437785; cv=none; b=f/BT52x1yeXz21/5YmojxdwVMohuXocmXR6xMZEHcOxvV8KBwrtv9WIRiZe3C/o+2VI+3f4aiXiPi73bUqBYe580QRaZGtWBuLHz8ncK3nNPLA6SnB+amIbNjyLJD0TnTqc4pv+zH5lNrhQDsskX1OgqtOQlFSwbJawDtkDG/xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437785; c=relaxed/simple;
	bh=dDVTxfuqicOs1qLFtUy/wo7apKD669UknqYG/52ptz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D0s1sf9OIcS/vIU5cgHOaMle2xeqCr0yYf6EtYz/qBUsvsWDu3VOm6YeohEgf7TkpaTZqjzjwc3ohbilnCYpYMq2LJ8cnjK/kVkIfdGGgeFaBGN/Vgj9CHgwYvlnXEE+1fFUKigQvtgn7xhO5MJP5vyfgcMxxeZbw3hIJcxLJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EiLm0ZvC; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EiLm0ZvC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=N9
	0PVcEBaJjmtFZtExELpFQU0K3QU2o0KNqwUaSuAI8=; b=EiLm0ZvCe5CBHYTiLl
	W9lY7Yjk1P4AVlRDElfr5VxaNsuCIdp9fzP1fEqz04TBwVk6hZ5GXKIQGXX+4Wyn
	C4yc6fvzAohOPPB4N1S9lXUQ+V9Vx1zqEhQrk4z+mLvkKpoDR2HmQ6xFCMg1CvlF
	BE4qimdsMkxwrF31lecIHr7UA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F4pL6bdqlpIIBA--.11355S2;
	Sat, 26 Sep 2026 23:48:28 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Bhagavathi Perumal S <bperumal@codeaurora.org>,
	Sriram R <quic_srirrama@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/5] wifi: ath: avoid IDR mutation while iterating
Date: Sat, 26 Sep 2026 23:48:19 +0800
Message-Id: <20260926154824.75224-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F4pL6bdqlpIIBA--.11355S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrKr4xur4kGr1xCw4xXr4UXFb_yoW8JF15pr
	4fu3W3uF1xZr97tFnxJa18WF1rWFn3CF4jgrZFk3WrWrn5CF18tF98tF1fZFy7GFWfJw12
	93yUtr1fCryDA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piY9akUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQwWUGq36Uz7GgAA3e

The ath10k, ath11k, and ath12k cleanup paths walk an IDR while their
callbacks remove the current entry. idr_for_each() retains radix-tree
iterator state across the callback, so that removal can invalidate the
walk.

For ath11k and ath12k full teardown, keep the callback limited to
releasing the supplied skb and leave IDR teardown to the following
idr_destroy(), matching the established SCMI fix. For selective per-vif
cleanup, use idr_for_each_entry() so each iteration starts with a fresh
lookup before removing a matching entry. ath10k also uses
idr_for_each_entry() because its shared TX completion helper must retain
the per-entry removal.

Jiale Yao (5):
  wifi: ath10k: avoid IDR mutation during TX cleanup
  wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
  wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
  wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
  wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup

 drivers/net/wireless/ath/ath10k/htt_tx.c |  7 +++-
 drivers/net/wireless/ath/ath11k/mac.c    | 46 +++++++++++++-----------
 drivers/net/wireless/ath/ath12k/mac.c    | 46 +++++++++++++-----------
 3 files changed, 58 insertions(+), 41 deletions(-)

-- 
2.34.1

