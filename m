Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398113;
	b=AWoSv1Xr69pwnq0N7rDE7BYobrWTvQULY3jHUb5ox+CnhDnRgFmX0jfKqT29p5v/GET0
	 ORJPJQ9icHhAz3WsmpXB3uK+ASvWE8/JNwnA7nPmuZGD66/XzfM93qgjyPqmCZKZ5SFyE
	 9Wy3v8AFcGKSDYZB1OY1PWR+vBXRXEb5wR1B2y6FgHjIYVyfrHx8+t3Jna/0yVQlS1rj2
	 ZjZZxOc/kyMka0WJiU7SP+cIEAQBwYuSW2XmJEWFQhAf/EQnzMgM63a1JgUtUCkonqGtC
	 JGDGHoEoMsyQDsMDk/xfY2ZWQdh98AeMpqsWZOwU5Iox6uy7cdbCFnqS/pw4OyjD0Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398113;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3PupxROefZP66Lbc6uSw6pabAOiXrtuAPfPVHNPe6jA=;
	b=gT17WcP0GnvB4h8OXuqfs9GG5VgjotF8r+yThRq5CHVdLOxF+ttVNwsL6EHzhY4/zDNQ
	 M3UMNH3bLgl2/Nsb8g1KrB+M5qTkE3Jxm0hagiVPmCx1W/FGKPKy1DIEKeRU5IgZ2xpRA
	 Iru37bjc0ML0GFF/EOo6OA7hWCJ1+iLtErMIgKcB/4Fqr+eTSMbMyio+JZBQEQeYQn7lx
	 BRPmNp3PtGO2HGXZvaEUgxPDNYZPvAkM6TQSTOfPNcMAc1WUCv7/Zt9CtO3K058pWvn5O
	 iM3fw7f0Js/6xuII/tl6iDyD7/WoWjkjSP0jJ79R8TEnr4M8rgbKMSULlvRtwh41iEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5ROq6Fo;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7844C606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7844C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5ROq6Fo
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so11693695e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793398112; x=1794002912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3PupxROefZP66Lbc6uSw6pabAOiXrtuAPfPVHNPe6jA=;
        b=L5ROq6FoGlq0fHySlhzwU6d4RO9R/lvJjXYtDrQ0QrsfGtYJpwjHBNiFyKLioh5fsd
         5xAxJl6zabb5Ss4kqp0z2tH5sddoM4CqcDOstWmLffmsBFFcwMFsQVmcOzfZ6jENPo12
         pd5UrGVf8Z+J8HAE4m0TucLSFCAXtyF3GvL/GHBT74UzxUsgyKsj5WzwtPTmDw1wjPcn
         G58+dDNgwkezAHUSgG5NMeXzGaUD/MtLE211Rwam2+JmpQM0T4hC8e/77yCex8PV0+nF
         mQYeFImsn8o5PIbb7Ovb1MwHzuU4aTmZbzJoYRz0JdyJZilwRzFJ64agkrYmRbOF3YTw
         OobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398112; x=1794002912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3PupxROefZP66Lbc6uSw6pabAOiXrtuAPfPVHNPe6jA=;
        b=27mhNbYTfVOriAFc9Tk0e860m90goVFEkxXqQ/+Rf9/9ZYwwL9VzO6QCINVVSXzYsb
         d3G6pm/T6RAUmky8iADMHSZimJihEn+0pxUADYlhvtD2hgMm6cwPLMg6fCYZSf8KB+xl
         8HBwZZ2YEC1ud5fF5GOLUjvjidNF7qs+/RhC9FGeeG5HtUFYvqQt2PeDfwprj6xDnt93
         xWLR8LsPz41NKeLFF7hn4sqm0bJPZtff3w0gVfrLLF1BxlmjspzcQnxiGgXSxA8hmXfl
         RVdPPnihr3EV7PnBixabiONZBDrqkS5WlgFUszTSKNhVc9FlAISUlE1EPx5dgPJgG4wS
         QB9A==
X-Gm-Message-State: AFq9FYIGJoiGjwGIIezexTT5ykKLT1CVheeSB0rkMT6nGV+PBmkSorM9
	CkQLEDbaIzN33WaJdXchtnD8vY/G/8GFO9fMkZGN8btALP3QLm5VsrqU0zDfxI5K
X-Gm-Gg: AYBFou2fQVdEu6oRZeZRhYo9pPxg3WrTF9Wit2EN5MZWwO2WCvaltzTYHcreAwMupgg
	2lmOERrKw0wcyfZQczgmmHfC0rtqdnka2iy3XrcxehKceWWQXpDEKCUGm0VKVK6vp+lg9ME+mM/
	7lIIHsWpBZlsS3xAIYCurHqyNeqCEijuMOgiU3XvgLv0EegZAYAKyaqE3zivq9toKfKLXcjRqif
	5cjooASQ/aKeBorr2Yn8RR69stIi3cuFtsJJqFN5jmhioHMtyzkMVd7l5bJ2SNEGzC5R4qE4N5L
	FqG3r+/VxkutPwZ6qejYRMJ/EkcnO7vy4JBUHdcav653DUrwAk8cH+h8/lYxDfExcjGgd+h/fEo
	gd4ZjjjFcCQf15nRNoRtJ1f3Va+cNDe+WZsbYCX7AWtAlNdkbC/TJcyQ9siGAMiJIAsAUiUc9Fn
	2f9HBjRJjOUAx6jbZJejGc/+Dnhk/21X5PtD2fsQWOq+5JzY/oB02DJVkgmN7odjdIlO5+Df2qz
	9Ogg16y70x4NUfGJb9rExXNcpyLv9DTCh+9b0cF2z6q6eropD0CxYk43ilpui85nTIBwzHWgBWM
	XhzWwcV8slvMPKNq/YuOhCH7/b/a1yYNn/QRTbBYHkYEPZ9u9o0tOSxxuSe0MiwA3iW/qEMWuyO
	tmV8L855bhdouYQ0XOoYURXNgzUa2Ffq4QEoy1jSSuj71kICU6tlU7Jw/2Q==
X-Received: by 2002:a05:600c:6387:b0:4a2:150f:1605 with SMTP id 5b1f17b1804b1-4ac1904a81amr85938675e9.24.1793398111701;
        Fri, 30 Oct 2026 15:08:31 -0700 (PDT)
Received: from u1804.home.lan (152-43.dsl.iskon.hr. [89.164.152.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7706516sm56230305e9.0.2026.10.30.15.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:08:31 -0700 (PDT)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 0/3] wifi: ath12k: accept what newer QCN9274 firmware requests at boot
Date: Fri, 30 Oct 2026 23:08:21 +0100
Message-ID: <20261030220824.915760-1-gsustek@gmail.com>
X-Mailer: git-send-email 2.43.0
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

With QCN9274 firmware WLAN.WBE.1.6-01243 (the newest in
ath12k-firmware) the driver logs three warnings at every boot:

  ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported
  ath12k_wifi7_pci 0000:06:00.0: Invalid module id 2
  ath12k_wifi7_pci 0000:06:00.0: failed to parse tlv -22

The firmware is not at fault: it requests the AFC memory region
(QMI memory type 10) and advertises a direct buffer ring for CV
upload (module 2), both defined in Qualcomm's interface headers but
not yet known to the driver.

Patch 1 allocates the AFC region instead of answering with a NULL
address. Patch 2 makes the DMA ring capability parser skip unknown
module IDs instead of aborting the event, and fixes the zero-filled
entry a plain skip would leave. Patch 3 names modules 2 and 3.

The idea of patch 2 was posted earlier by Nazar Mokrynskyi:
https://lore.kernel.org/linux-wireless/20260505172415.566328-3-nazar@mokrynskyi.com/

Tested on a QCN9274 hw2.0 PCI board (single device, AP MLD on 5 GHz
and 2.4 GHz) with the series on top of v7.3.1: all three warnings are
gone, the device comes up with both links, and there is no firmware
crash, call trace or IOMMU fault.

Goran Sustek (3):
  wifi: ath12k: allocate the AFC memory region requested by firmware
  wifi: ath12k: skip unknown direct buffer ring module IDs
  wifi: ath12k: name direct buffer ring modules 2 and 3

 drivers/net/wireless/ath/ath12k/qmi.c |   17 +++++++++++++
 drivers/net/wireless/ath/ath12k/qmi.h |    3 ++
 drivers/net/wireless/ath/ath12k/wmi.c |   43 +++++++++++++++++++++------------
 drivers/net/wireless/ath/ath12k/wmi.h |    2 ++
 4 files changed, 50 insertions(+), 15 deletions(-)


base-commit: 7b14c8f4a9615579b09cbcdc4515b65ae6124753
--
2.47.0
