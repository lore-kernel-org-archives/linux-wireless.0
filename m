Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793537941;
	b=opaMsTxOxgjLMfrKc8tIBPX+eQo1A8rwzPdF0ZRdjRnJknmDkJrAzD2KYDeneukkZioy
	 sEafqW4Q4cqM1n+PwYnmj5Bb6VNrK00/R4TsJrO2703Xdf5C8VROAAUY/JbNy7awDli5b
	 leNdufkYNl0TfA6Bfm+AxX0dxtXVdIYH8abgBz41EBZAE68WVR0rRYwlWlBSFpFA70Mzw
	 7emTCtj4Kt19dm8yBjgWTY/AZZo/tJN/5/8FlsSGdM+OVlK90pPRUv690F0DhiPX8k0pa
	 ImTaq1IB2Mo5/STHedFAdL84DyDJuP4/dO0aZ31KtbOi1WpWX4Ea2Iun7v3f80BoWeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793537941;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=42uUpwxeFlIt+oVlZYyg3MehKD4BJExenLU7k+2MNBE=;
	b=k696wgEWk9whM+oyAYbTM+MZE+Jg3v9SZY8Jk2Opwusg2IF4OScjC/g85T+BEG1x8wXw
	 Nxl/MPHBSZSDclZkqL5wcnU8Oj1VQ6dROsHArsxkI/TqW7nh1mXHpNxZcenAS/sHhOCWj
	 /KjrPj60ZzV81iNTDvEEYo7L+SgPGvZX4xN5NTSfw7T3RkTUyq1FcjMpuurJulcYLY5xz
	 A63dR+fLm5EB0o3D0EmzB9cTz4kFpD/ZxV0prXx9YtZb7dMv8zLqZbqW/iuImmB3uM4Ee
	 6obLnMMnztP9TssNcbijgzyKsQ+AuNH5pri7r9DJic2fJBFCstrIsumnOrl9W3rsaDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=Zbq8qJbI;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7E1606A329;
	Sun,  1 Nov 2026 12:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F7E1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=Zbq8qJbI
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 70E3D80710;
	Sun, 01 Nov 2026 13:58:53 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id Esdo88_qE1eM; Sun,  1 Nov 2026 13:58:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793537932; bh=6sl3s0b1KzqpQad7r6W0dlFWZcquTtdY7WN+602Jpg4=;
	h=From:To:Cc:Subject:Date;
	b=Zbq8qJbIWzsun0y2XIFeg7/KX+NbKsNCqrjoDxGmkBzL4fwlXZVeSG+/CGbMdWyKs
	 pfUex37BHb4Q9aF/J5BgZ1USh/HD16pG7nXrSOBD84txLi6RgyqiWJNLMCI2XJA2Eh
	 AAAKLLYhMkyuD6LS+hpnAz675iNkC7fKpauVqQALKcDdH0USzWDGOX1EWGiznQh3kI
	 eEeClwNexVxFEpGaEdaxwVG/80XA9hrRIZjQ8jbqRCHlcawFQx4W/rGv2d/HDwx7Il
	 pwKXkr8bD2DardiPhwDEvtgW/L6NEr/rAPDnnhGvr/RnSXaql8MXJH6RVTjMKmXG4N
	 spEZQ3H9wql+A==
From: Florian Maurer <fmaurer@disroot.org>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Florian Maurer <fmaurer@disroot.org>,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 0/3] wifi: ath11k: more firmware crash recovery fixes for AHB
Date: Sun,  1 Nov 2026 12:58:00 +0000
Message-ID: <cover.1793531790.git.fmaurer@disroot.org>
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

Three patches on top of Julius Bairaktaris' "wifi: ath11k: firmware crash
recovery fixes" v2 [1], for firmware crash recovery on IPQ8074 (AHB).

Patch 1 keeps the ext IRQs from being disabled twice when a recovery
follows a failed one. With 2/5 and 3/5 of [1] a failed recovery is
recoverable, but without this patch TX completions stop afterwards.

Patch 2 turns the "select RPMSG" of ATH11K_AHB into a dependency, which
patch 3 needs to depend on QCOM_RPROC_COMMON without a recursive
Kconfig dependency.

Patch 3 stops TX before remoteproc resets WCSS on a firmware crash.
Today a TX in that window ends in an asynchronous SError and a kernel
panic. It depends on 4/5 of [1].

Patches 1 and 3 were tested on a Xiaomi AX3600 (IPQ8074,
WLAN.HK.2.9.0.1-02146) together with [1], backported to
backports-6.18.55 (OpenWrt 25.12), with real firmware asserts under AP
and mesh load, with simulated crashes, and with a forced failed
recovery followed by another crash.

Not covered yet, both to be addressed separately:
- A second firmware crash 10-20 ms after the firmware is up again can
  make the QMI firmware start fail before the CE pipes are set up
  again; the next recovery then dereferences the cleared srngs in
  ath11k_ce_cleanup_pipes(). This is not caused by these patches; I'm
  reporting it in the thread of [1].
- A crash within the few milliseconds before the restart work clears
  ATH11K_FLAG_CRASH_FLUSH (see patch 3).

[1] https://lore.kernel.org/linux-wireless/20261018210153.1925962-1-julius@bairaktaris.de/

Florian Maurer (3):
  wifi: ath11k: don't disable ext IRQs twice
  wifi: ath11k: depend on RPMSG instead of selecting it
  wifi: ath11k: ahb: stop TX before WCSS is reset on a firmware crash

 drivers/net/wireless/ath/ath11k/Kconfig |  3 +-
 drivers/net/wireless/ath/ath11k/ahb.c   | 63 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath11k/ahb.h   |  2 +
 drivers/net/wireless/ath/ath11k/ce.c    |  7 +++
 drivers/net/wireless/ath/ath11k/core.c  |  1 +
 drivers/net/wireless/ath/ath11k/hw.h    |  1 +
 drivers/net/wireless/ath/ath11k/pcic.c  |  4 +-
 7 files changed, 76 insertions(+), 5 deletions(-)


base-commit: 7b14c8f4a9615579b09cbcdc4515b65ae6124753
prerequisite-patch-id: cd9f2849ade92e165f15fe3f887edabd1d06b6e8
prerequisite-patch-id: 3c9ba2aec0d93942448aba1dc5d26b632d519e5a
prerequisite-patch-id: 9a833c602db147b490fba6df590eeea3847f4877
prerequisite-patch-id: 6fd3e11242fb3ead65751e3cd9972c4d7c63f989
prerequisite-patch-id: 01e149ed860e5e40e79725580548ce4034f344b2
-- 
2.47.3

