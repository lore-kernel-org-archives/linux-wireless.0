Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793539027;
	b=ETW70dbn9Ml0RdUUdgkybzrAxE1qzCdC3ElqhOcy5+ZWPHErbns7l+ZWE8rsvC1wIxeb
	 vtvVRslp6AXGVteuxnjgtgzHoqly8qR6BcnmeQJ0YMvocVHPRzvsg8EtgWIzD6tZ0i5hr
	 oA2buK7lfb1ddp30PMLuhx0gXjNbP1mJi0jheqvtx1fNU5O5+vYGHMmSLuDPVbAnmmI+Z
	 Wbfel2pOSFF+TYSLrp7aVbCN4GLYoRQ4JVGoDaSk7o4bvKs1AGXK0hDA6r8iWaxZ9Lu9O
	 pSLy9Vf1zgzkqXaFu+ixqrfR0ixMCDoMzn58fopJd6YgDx3xAt3bDBE1dFe4hcN1Waw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793539027;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sR5ie4tJ1WjHnkmUfnOmHpKTm3TzECiPGao53FlKIfo=;
	b=kYgtC9LeXhM7HZyzujsHgX3xF/blKHgW9ZqoFdW0in41erAV/+UA8b8JS2LBVP6XCU6j
	 CdTpwdbHYEGwQNJrsxuVPQFRSU9+LN8Y+QWPR5+yYOIS6bfz0z/WeLYMr+yTQlyj6GcHt
	 02e7Syz1c9u78toayxEbzQPTYLMX7ZB6pKza4ibOfCIxdLJx9Mu08zu7rfX6AfMsF2GXm
	 pmBx2MPwi7tlsS1DF3wvMeyOjGm1V2rLutogze3Vamzys16SpsfPUiEm1UWn2/+DPbJzo
	 E3XQc57mhDnxVayJDNKwoaQBlxc2bAT8dkCIQqQ4b/pSQtbvm1uZd0ODOHuadmShQAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b="hsHTIJG/";
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7599C606A324;
	Sun,  1 Nov 2026 13:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7599C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=hsHTIJG/
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id D77EC8086C;
	Sun, 01 Nov 2026 14:17:04 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id aTqhoqVt2ltI; Sun,  1 Nov 2026 14:17:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793539023; bh=Cap59tPzgyoMi8G0Vy10GjN4ejlXEnh4z+J/nWuu/zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsHTIJG/nC9YT8EfoYvlmP1+2yioi8Ciw00gShVGkdkD2770WfXmIhjF1/qnLbCsI
	 B8XVD4Z/rw8ksH+SnAMkrFfMBmlc+dUfalWP94mPsehMO3fKjvlfgsHg2I2b3i2ROH
	 l3YbFiMAbtv0YB7oAqw0B817Xsn6RJ+jK89Yggprva6QM+gSL7NrFYtXuZvx3Vi32W
	 jI7xP28prkwH7e6uTROXhDyqPz25IHkeu8NgndPwWXqmn+CZsYQGHJXZfnt5TuunBz
	 J3HZLChSIRc5C7XwCvXFPboel0m8POQ8y/Emyz2hON/LAiebuLmmOtoqw7lRKLkp+h
	 DHzbIbyX0ECsQ==
From: Florian Maurer <fmaurer@disroot.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/5] wifi: ath11k: firmware crash recovery fixes
Date: Sun,  1 Nov 2026 13:15:50 +0000
Message-ID: <20261101131550.1890062-1-fmaurer@disroot.org>
In-Reply-To: <20261018210153.1925962-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
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

Hi Julius,

I have been chasing the same recovery problems on IPQ8074 (Xiaomi
AX3600, WLAN.HK.2.9.0.1-02146) in a Freifunk mesh network and ended up
with fixes very close to your 2/5-5/5, so I tested your series instead.

Setup: OpenWrt 25.12, kernel 6.12.112, your series backported to
backports-6.18.55 on top of the three ath-next IRQ fixes (a7ab5c835e42,
f7a74e131d3f, e56c9d429ba0), plus two fixes of mine that I posted on
top of your series [1], together with a Kconfig prerequisite (A: stop
TX before remoteproc resets WCSS; B: don't disable the ext IRQs twice
after a failed recovery). AP and mesh vifs on both radios, real
clients and mesh peers.

With your series + A:
- 10 simulated asserts (debugfs) while survey and station dumps are
  polled and downlink traffic runs: all recovered, no WARN/Oops.
- 10 real firmware asserts under load (5 AP vif, 5 mesh vif),
  triggered by an out-of-tree patch that sends WMI_PEER_FLUSH_TIDS_CMDID
  with all 32 TID bits set: all recovered, no WARN/Oops.
- Failed recovery (forced via a test-only knob) followed by another
  crash: the radios come back, but TX completions stop, TX fails with
  -12 and the firmware asserts again repeatedly, 2/2. That is what B
  fixes.

With your series + A + B:
- Failed recovery followed by another crash: recovered 3/3, which
  your 2/5 and 3/5 make possible in the first place.

One case is still open. It is not a regression of your series: before
3/5 the same failure freed the srng memory and crashed in the same
ath11k_ce_cleanup_pipes() path. If the firmware crashes again while
the restart work is bringing it up, the QMI firmware start can fail:

  remoteproc remoteproc0: remote processor cd00000.q6v5_wcss is now up
  remoteproc remoteproc0: crash detected in cd00000.q6v5_wcss: type fatal error
  ath11k c000000.wifi: fw_version 0x290b84a5 ...
  remoteproc remoteproc0: stopped remote processor cd00000.q6v5_wcss
  ath11k c000000.wifi: failed to send firmware start: -104
  ath11k c000000.wifi: failed to start firmware: -104
  ath11k c000000.wifi: failed to reconfigure driver on crash recovery

That recovery fails after ath11k_hal_srng_clear() but before
ath11k_ce_init_pipes(). The next recovery then tears down the CE pipes
on the cleared rings and hits a NULL pointer with BHs disabled (under
ce_lock):

  Unable to handle kernel read from unreadable memory at virtual address 0000000000000000
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  Kernel panic - not syncing: Oops: Fatal exception in interrupt

Decoded call chain (6.18 backport, the raw trace has wrong symbols
for the stripped module):

  ath11k_hal_srng_access_begin       hal.c:834
  ath11k_ce_poll_send_completed      ce.c:706
  ath11k_ce_cleanup_pipes            ce.c:884
  ath11k_core_reconfigure_on_crash   core.c:2403
  ath11k_core_restart                core.c:2574

Reproduced 2/2 by triggering a remoteproc crash 10-20 ms after "is now
up" (measured 11 and 21 ms), with your series and my two patches
applied. So 2/5 and 3/5 cover a recovery that fails once the rings are
set up again, but not a failure inside ath11k_core_start_firmware().

I haven't tried a fix yet. Since the CE-layer guard from v1 was
dropped, one option at the core level would be to remember whether the
CE pipes and DP were set up again since the last teardown, and to skip
that teardown in ath11k_core_reconfigure_on_crash() otherwise. I can
try that if you don't plan to cover it in a v3.

For the series:

Tested-by: Florian Maurer <fmaurer@disroot.org> # IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146 (backport to 6.18)

[1] https://lore.kernel.org/linux-wireless/cover.1793531790.git.fmaurer@disroot.org/

Regards
Florian
