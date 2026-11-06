Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965915;
	b=vbDFJIIapL88gvjD8prFfs8Wf178q9z4IcZO+Vdd/YFpTZLsoivV1bHnYLbPt/GN1q2Q
	 a5tUFhunBuCecs3Z1bTewJa81O/xU1X+rVt58RbPFvlZ8OPI9m4uXJjXYrorJSBGQIwSH
	 Fmcql3/YCTzflabwGHhKe9eXrP/iXzyYxG5BZ4laeVGn3Hg5uSNYCKZ5EAFmnBI651m2E
	 53GNNIIOFA4yl4TYlGMSxBhLOuVyV1dkg6GpQcCfnL4UHChKwgoPNIPbcOqkMdHvEXqRj
	 l47D50IIwx8t8uQdyg+MKvnuRyclpWitG7VChxdH00Wmh4EXwAct9g0UkLee+icRXLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965915;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=E2wwc7zaFaKTAagn5XMB9neG9tz4zIsm5fHynsnqTz8=;
	b=C+taAG7GzGcKrUH1nH9Og86I3rA5FyTLSPIJ+uM0rsevk3FgqPcIdKT9/ZpksvD+Lzo6
	 01Zdd4Z/Vu92dBElDwWCmiuLuy/XabVd5EgiZ+LBy6dJmsSAS3H7trSBLdWYLDxux5UGM
	 HQRyAo46Ic2tfYlKqatITXqkSjWoQVnb6XzpEfV+o8oeSAPmh3Yzclu/eJPLi/KxRVNTY
	 rcDK3HQQ9Lhs93vBRX7alrJNx/NpIR3rpCUMbMtG/ooVjIs4aAzkMTNN1eLayzz6nBlFT
	 ZMPYrdM0LZ4GHtPbna9kwMZbJguc8Blo6O2uBhSRkmY/sT41PStia6usLbTXFwfdGsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=e8bCn0xj;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2C606A326;
	Fri,  6 Nov 2026 11:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEC2C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=e8bCn0xj
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id DD71080449;
	Fri, 06 Nov 2026 12:51:51 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id oszisWeC_mLU; Fri,  6 Nov 2026 12:51:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793965911; bh=r6rXpQ7fhFSWHIdpUzyK8xO9/DWNH+d88klaR/M4tpE=;
	h=From:To:Cc:Subject:Date;
	b=e8bCn0xjo8DYglI3sgomLSMSiwhNWF7PY6QTs0R9FHuWU9Dx2FI/bI4uJTlU/xriz
	 NHM+2uYfP2o8GgCVfPSX08s59okwapKY8LLwjMRI2Yw2dkHgdMO4CH5xbfLvk/o5Uv
	 TVN7oWdmhX+ePJdezI5g1SH96peAC8iHkqoIkRlgQq7TAPmdoQURFERz3rdtXbbW9N
	 7iWpNJcSDOLBv7XWY/Le0EO7KUlY2T1ksoUbclL5vBwWfUBnhh+oZcEqO7hciiWUaE
	 XxUAJhZADeqLtrICJ/RUbmcx5q08UJ4viSKP3X2PICallR5+UIJjzuGWI+4cHbwZ1l
	 Hu92Hpz15VMtA==
From: Florian Maurer <fmaurer@disroot.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless 0/2] wifi: mt76: npu: fix rx ring handling
Date: Fri,  6 Nov 2026 11:51:11 +0000
Message-ID: <cover.1793927986.git.fmaurer@disroot.org>
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

On a Gemtek W1700K (Airoha AN7581 + MT7996) with the NPU offload
enabled, 5 GHz rx load crashed the board within seconds. Patch 1 fixes
that crash.

With patch 1 applied, the two WARN_ON_ONCE() checks in
mt7996_mac_tx_free() fired on misframed rx frames. A debug patch counted
2-4 of these bogus events per 30 minutes. Patch 2 fixes the misframing.
It needs multi-slot frames, which were frequent here because of a patch
that leaves the de-aggregation of mesh A-MSDUs to mac80211 [1]. Without
that patch the race may be hard to hit.

Lorenzo, I have no documentation for the NPU. Everything here relies on
what I inferred from the code, so can you confirm these?
- dma_idx is the host's consumer index, and the NPU leaves one slot free
  in front of it.
- The NPU writes the info word before it sets DONE in ctrl.

Also, with patch 1 the NPU can no longer get slots without buffers, so
a lasting page pool failure can stall the ring until something else
polls it. mt76_dma_rx_poll() has the same behaviour, so I left it. I
haven't tested this case.

Tested on OpenWrt with kernel 6.18.55 and openwrt/mt76 at 467ae2e3. Its
npu.c differs from this tree only in mt76_npu_setup_tc_block_cb(). The
test image also carried [1], [2] and other local patches. The W1700K
was meshed with an ath11k node and ran iperf3 in both directions on 2.4
and 5 GHz for 60 minutes (5 GHz rx mostly around 220 Mbit/s). There was
no reboot, and neither WARN_ON_ONCE() fired. That image had no debug
patch to count bogus events directly.

Reset/restart: repeated wifi down/up rounds under about 30 Mbit/s of
rx load were clean, but they don't reach the rx queue reset that
patch 1 changes.

Recovery itself can't be tested on this board because of a separate
problem, which I don't think comes from these patches: a build without
them also became unreachable after `echo 0,8` into the mt7996
sys_recovery debugfs file (full system error recovery, the same path a
real firmware crash takes). I will report this separately.

With the patches, the same trigger wedges the board with and without
rx load: the MT7996 stops responding on PCIe (completion timeout), the
firmware reload fails, and the retry loop deadlocks in
mt76_worker_disable(). A sysrq dump shows kthread_park() blocked on a
TX worker kthread that is already parked. `echo 0,1` ended in the same
state.

On this tree the patches are only build-tested (arm64, W=1); the
above was tested on the 6.18.55 image. Not tested: a completed
recovery with patch 1, and MT7992.

The same code is also open as a pull request against the OpenWrt mt76
tree [3].

[1] https://github.com/openwrt/mt76/pull/1170
    ("wifi: mt76: mt7996: let mac80211 de-aggregate mesh A-MSDUs")
[2] https://github.com/openwrt/mt76/pull/1132
    ("wifi: mt76: mt7996: use own MAC as BSS BSSID for mesh interfaces")
[3] https://github.com/openwrt/mt76/pull/1169

Florian Maurer (2):
  wifi: mt76: npu: return rx slots to the NPU only after refilling them
  wifi: mt76: npu: read the rx slot count after the first slot is
    complete

 drivers/net/wireless/mediatek/mt76/npu.c | 28 +++++++++++++++++++-----
 1 file changed, 22 insertions(+), 6 deletions(-)


base-commit: c4328134f3f7c2ce141121a8f82a5ec0cc8a709c
-- 
2.47.3

