Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E242BEC52
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785104385; cv=none; b=Fm3sZgUwtle+oOHNns36Ajf6+kZiQ6CGLDlTJ61qJ66J2FeGk5UFvhloDBuY+P8dEEbCfoXjZXkz4/8teGhTZmx5kbiml51j+eWiUiEl9nzPDRpxzeH9CuKkFZg3WSyXsv7NzcChGj0eYHu0CwZbVtWOmEgp/rx02qZ5uZrc8Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785104385; c=relaxed/simple;
	bh=/yDyEKG75YqKDusww/DX2764BjZuS3yKOk6JMkg83a8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eTd5BGSh5Q2iBJZ3G01sMZL7GyRL7Y2swtmIQwmIKy0ANMVPxf0OBjsyY4gfx4cUo6aafEUem1/QeiZtgdd3d4hQ3W/pfkHKmMDDtAiDgU09OAbuPgZEIx7E6NJTyPISY6cZcFVEgOFeyv/PtcZB/8CgTp2xOcaMkH93vS4DbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=eGkkRZHQ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="eGkkRZHQ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69fe400c14aso1007100a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785104382; x=1785709182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z6N0boIWyU0J5K0rc/NgMjVGoZ83sDuVKA9GvDpL6Ug=;
        b=eGkkRZHQt6tODwIVB6vrQD1n522piEIfL1+r9RoN6vh18Vu97VFRKATQOK1bIQnIP4
         dRK+aswsoxeGARtTtGP48iVzhn02MS9H8uFe7Tus+Pww/IPyUc7JAWHb9KzBiZ7O/wIY
         oHx++uPKg8C4yK+/5FhUVFyQ0qoB1xRiQGQiK4FsrYwDnsIN9RjueJwFov7VTBVA4IwG
         kD3U+PbAcUmiGpnqvmwzjP9KCn6HgeseXYcQSy2WMz/w72CTAzai+CrcJAfZ5GtSrxUT
         /tCX4hTaIbJWFN1KoGMq06n/cxdl7KES9NoKnSTXZnt4FRT6/81NLwSOgPWDFvBdpIQZ
         ADQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104382; x=1785709182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z6N0boIWyU0J5K0rc/NgMjVGoZ83sDuVKA9GvDpL6Ug=;
        b=jAlxSucwDJIplXopr8Z8cRgCiw9AXjEglJWvfT2pJGFLzsNC3goVSrGv4PTJLSVOEC
         Plyo5BpyQYi+/NZ2GnSxbAINWrC++H2f3z//pBKu29mGGwU7Mr/77nzskQRFYruNF0pm
         ALLyJSY++6EdLmyRVYonZCFjOZstHH2+bShQagEAr4S3htYdp+fIsXNe0/uXBoQR6DbG
         d8WRFEjUokG6QSnZUwW5uNxBc7mfxPYN0rt8ZMXMvoGN1AkJyFVk+HymrxVGExkCP+hq
         DZ1IQGQ0HG3S4F0muB9h1KUKxoJgsWi0fBq2wg4Om53k2BciYKoeqjaMnBeYu99Dqo8m
         eixA==
X-Forwarded-Encrypted: i=1; AHgh+RrAx/S/LLpt+vKO0xSls/uDMCXoU/vTB3NaLF29cD4k8SFfivnkoPbbQ39W5pLE1B1615+FapXfHZXY40X+xw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIQ2pU17kNC0xwkbxlDSv616XbUn2aCU5/b6C4zp+XUXnJMu3v
	a6KjY7OaIWViJcxQ9alj20xff9n4ayLF4ZZ3JASx6uRSt8YZQnw47h0lHJspZzEffw==
X-Gm-Gg: AR+sD115CVh6EwsbjrlCMqSWJMPX3GsslSQB5U8sgoTTbY/Bm3swn0U3nVgQ9LmQj12
	VcjvUCJj3lpPmQeALvEv7zgo3oF9WWAmovHi2YojLj33qrOzWvpW/GRFSUXeVzqfTJFic8+SJoT
	81ik4MWwfZHN2pBL4EqkGEuecKiMkRTKPrD4O63THOk44BC2vEEYI477Rd9Mvvo9v9nzjvP6u3L
	n7SSl13VOLSakqrDuxiZ5HwyuorX8ZZVAq7fyrxK5UZ/KSvejTWkDTjudab4OLw+0nWodqecGl0
	HoVLcCKRVsIlCsNV+Tkdk4VvANWKLyf/SGKGBhX/0mm4rCjDllxXCeMGHxlcjTJNaVBw4nVe/Kr
	7ZN1C3jQR2xl0SDddoJghmOH3n8TEO+7L3v6CpwSL8bDAJAGaWRdP1sFS8H0BzYclUyAir8RjPT
	N8HcK5ngBmzQKC2ySO9RDWilFSMq4V4SFAcEI8Q5CNauAbNcBvINU3YnfOdgCaAnyQ5CB8ywgG3
	lIdDCrkRzJJGjGt6WXSb6A61OiK6Ee9xCUjiIBGiw1UN/QUD89CZT+IQJ2rOIq9CkAkadIz/tiR
	TxXuUT9hOpi1ITsPOytGYmJDqeAsc/xDvLk5khJ35xCD0NH67um/rldMFH2vAjgbaUxohOBFUu7
	7FbnyWKT4D6R1BgkB3kIaTNo8+NctgDA=
X-Received: by 2002:a17:907:72cf:b0:c15:abe2:e1df with SMTP id a640c23a62f3a-c1f1f07e1d6mr239191166b.43.1785104381647;
        Sun, 26 Jul 2026 15:19:41 -0700 (PDT)
Received: from Desktop (p54affe4b.dip0.t-ipconnect.de. [84.175.254.75])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a76fecsm561599466b.8.2026.07.26.15.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 15:19:41 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Subject: [PATCH ath-next v2 0/2] wifi: ath11k: fix SoC reboot on firmware crash on AHB
Date: Mon, 27 Jul 2026 00:19:06 +0200
Message-ID: <20260726221908.104873-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On IPQ8074 every firmware assert takes the whole SoC down. The DP NAPI
keeps polling while ath11k_core_reconfigure_on_crash() frees the data
path underneath it, and dereferences a ring the teardown has already
cleared.

The interrupts used to be disabled at the top of that function.
commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
moved the disable into ath11k_core_reset(), which AHB parts never reach
on a real firmware crash: reset_work is queued only from mhi.c and from
the debugfs hw-restart handler. Patch 2 puts the disable back on the
crash path. Patch 1 is a prerequisite - the CE half of the quiesce is a
no-op on AHB today because the bus never implemented the hif ops.

Reproduced and fixed on a Xiaomi AX3600 (IPQ8074 hw2.0), with no
out-of-tree modules loaded, using the debugfs simulate_fw_crash
'assert' trigger:

  before: 2/2 asserts panic in ath11k_dp_rx_process_mon_status() and
          reboot the SoC
  after:  3/3 asserts recover, 5 firmware boots across a single 397 s
          uptime, no panics, both radios stay up

Note the debugfs 'hw-restart' trigger does not reproduce this, since it
goes through ath11k_core_reset() - the one path that still disables the
interrupts. Only a real firmware assert does.

Patch 1 is by inspection: it makes ath11k_hif_ce_irq_disable() take
effect on AHB, which also fixes the existing call in
ath11k_core_reset(). I have not managed to trigger a CE-side crash on
its own, so if you would rather see that split out or dropped, say so.

Changes in v2 (no functional change, review comments from Jeff on 2/2):
- separate the ath-specific Tested-on tag from the upstream tags with a
  blank line
- use the standard kernel block comment style, with /* on its own line

v1: https://lore.kernel.org/ath11k/20260725141757.1316877-1-julius@bairaktaris.de/

Julius Bairaktaris (2):
  wifi: ath11k: implement CE interrupt enable/disable for AHB
  wifi: ath11k: disable interrupts during firmware crash recovery

 drivers/net/wireless/ath/ath11k/ahb.c  |  9 ++++++++-
 drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.53.0

