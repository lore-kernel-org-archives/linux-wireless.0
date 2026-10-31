Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793486415;
	b=1NblersNIkNYBXUHxhZ4GwGWNySoTfrir5e4HxSOOqP1cuTeTu7XogcCsjqoGBzlfSAE
	 Jo0AoUk6ZDJoUE9b7PEZnuvA7BSnX6AfNYwsz8j3DcYtzCLFiJErcUS6Vpst6h61upfDy
	 yN5FnQntPbWC00L9Wq21kF+EQdD+Z//cgVirWaGV6E2rNSQUDR5ZsDtxpkWFGRGDrOPqw
	 VQWSJZ/nQc0NQmOlWMo2yCRznZTuBe2YL4aWYPjA5MdDyPgPkXwYC+1DJj9BCgy3rm4mf
	 yUgJAhz4eVaUVjz3WkbJhIFMgt3SrLtdUopu0vFFVwjTies0kJsarVyHOyYavCnPNIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793486415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wmEdL1wxlI2opNeRSfFeBJ7usDo/UgVPde2rMRHJ6uU=;
	b=qrjE/Uxkc1gXuPvxI0nENGOM8+AmzOKhZ9VyD8yAWGUoZX/0Xvf+NQ+bqk6pEnUEfbwS
	 Zbsy7j7SCP55KNVWRNZ7ktrku4HlyXKcNxSF6JV/OFijO9wCZjYAMuIOX2n5y1AkTxeqi
	 Z/YYP8iOacJo1zD3XOL91pk9ziHKqtHQTPsOeoBTnoYDGJPYfgrUXvYuhG0NMoeyW+3+9
	 YKB27qOkXmtibW/1IXNzDwwViYC1QKIDYZVaLcZMdkSvkAuYGPRJ88ESOR6J/QPUtWoxX
	 iDE78x0m0eAwOzbVHGCt0+/SQjiHvrdVln5rzKQuCTlWDNYHfqTWGJrmNTGVmZ8opgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYI7hXmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046FC606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 22:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYI7hXmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D881F000C1;
	Sat, 31 Oct 2026 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793486414;
	bh=wmEdL1wxlI2opNeRSfFeBJ7usDo/UgVPde2rMRHJ6uU=;
	h=From:To:Cc:Subject:Date;
	b=UYI7hXmR1PKJMN52n/mY0BwYhBhkkrZLfhH68LmkhsKFVw8uYW5BC0+YtS7fHe/HE
	 W/UcUFdtw9GQ4yDc4kF10uJVbUmEl/2J0JXU+UD6HPikM7xDnrNfWnzUsPO1n4xMel
	 B6/6mKakuCh//MwEpEmmESZ7dIP5POWEQ0feWj/lsisH71TuHe+e5B7htgnQIbnbxe
	 QXITN+EdS8h+dkxc+wfnEgxdRmRQJX+NKDZw+z6QS1MRsn6ryYiS5T0qnlvyVBwCdI
	 91eR5+eZa3D03z2jNDyF2qKBs8xVwukedawDfs7Syg7uoRLAM3xl7MYO0Xi7KdMGMH
	 7lOqUwlpgTgog==
From: Vladimir Zapolskiy <vz@kernel.org>
To: Jeff Johnson <jjohnson@kernel.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Subject: [PATCH v2 0/2] wifi: ath11k/ath12k: Fix MHI leak on power up failure
Date: Sun,  1 Nov 2026 00:40:07 +0200
Message-ID: <20261031224009.2323055-1-vz@kernel.org>
X-Mailer: git-send-email 2.51.0
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

If MHI power up fails, for instance due to a missing firmware file, the
MHI device context and the RDDM image table allocated by
mhi_prepare_for_power_up() are leaked on probe error path in both ath11k
and ath12k drivers.

The fixes keep MHI prepared on the power up error path, so a firmware
crash dump collection in the reset work can still read the RDDM image,
and release it on driver unregistration or before MHI is prepared again.

Changes from v1 to v2:
* fixed double unprepare by introducing new "MHI prepared" flag (Baochen),
* added a similar ath12 memory leak fix.

Link to v1:
* https://lore.kernel.org/linux-wireless/20261028104336.1686334-1-vz@kernel.org/

Vladimir Zapolskiy (2):
  wifi: ath11k: Unprepare MHI on power up failure
  wifi: ath12k: Unprepare MHI on power up failure

 drivers/net/wireless/ath/ath11k/mhi.c |  9 ++++++++-
 drivers/net/wireless/ath/ath11k/pci.h |  1 +
 drivers/net/wireless/ath/ath12k/mhi.c | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

-- 
2.51.0

