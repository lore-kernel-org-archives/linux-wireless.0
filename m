Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639777;
	b=epetOtZH33HReLIo1CkcPsluWq3Ww1Z2EYsm85Tf1Bxqgh37ynz9WvAh95Gk9YwVCHwQ
	 XT04gLJpfvDmlcXMxLx6BpBorEFysVeJoazRD7qOkKwo2xK5eydBzFbBoPRO2QHT7r3zs
	 CcaK7eIYhpU1LozQ7qG3uXDXXQKu76e0PWxlM1lx/DqYm1piEfA0qpODjVf3iCA5Tv0ZX
	 fIqNlnJa+LIMs+VSGFc648hA7e5MssbNROm1yJrIAGjRG7y5gMb6AT0jt/Txx9XkYqWRg
	 V1IudnU4HW+AjlwZZOlNzuO9LfUw8wbIWwfUfOxS9dzLbhc5F0eYmyi4vPskc3Iv4lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=A9NhjEiTs8MY8y/q7o/Otn/Omwz5Gf796OYmmromK3g=;
	b=ouVggiG113GMFAOEpgyUOKqWuO231NLjCBGJ0lsJawK096TV8QSTd7lZZWuWehbBn9h1
	 UbU8JTaYZCGOcn3YSTcG+iyoaPedY8ddUJx2bNXxAyXUDYvIvCodQyg9oH6N/x97DjXpU
	 TrbLcjjoTUs4w3pEFgWVQ7nRjJJzMmMkZWHS7uxTdq3n+m/HpZmlvEpHgY/quoRQAdyJs
	 BAf1+kNsuOf+Zvk/SKY0rfRj0BEjj560tcP67SuiPEeyZ2QCfpe3ei/RfbZLBMuFhAkV4
	 qcTVmt7P8gZTsrDImBi7LCESe5MKF1WbsH2Gm3KQrcpkgj+lxNvldWL3TJwB8MT14qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Lha3S2ld;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9A6606A932
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 17:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A9A6606A932
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Lha3S2ld
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2640181f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 09:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793639775; x=1794244575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A9NhjEiTs8MY8y/q7o/Otn/Omwz5Gf796OYmmromK3g=;
        b=Lha3S2ldXQeXGGzuOaVI2SSRdupbvuUhMMMZqPcrzn0TEL+roGMSoQmZJGt7kvbldn
         PtzhzYLQM8YHNLLonUCSyFEjCv6T69UDOcXWim4i/qoJ8HD49ZRYMlg+XZi/Yjku3CXK
         etlFsM40qo96ihPVYzEkTsBTcOk7+VAbTCDL8KlruJmfK7cW5Sj55q26jIN0TbIywuPh
         vPRPGqnYYVftcpuSU7V9sopSHJKVxb3oen3SziTWMBPngtAI7fdLQn10gpZu3LWzV31J
         0fI7n1uzHxXqsUE4s/IB4nF665lTVwCRQcNxLTnGNDPEVOA2Kr4mE69VhAM8/K4+1Eey
         5Rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793639775; x=1794244575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A9NhjEiTs8MY8y/q7o/Otn/Omwz5Gf796OYmmromK3g=;
        b=YDwUMYcd0KD219GhiJsm2DAeVtJ9eWF/0Ku8MX7CNtO/y+F47qKefQD3ESejG859Rk
         VxeNCXeHMiQeHqvpf8wEIsGc/SJwUtKSoVUNo78CrxowysEoHGWszpAdKKgrAKtndNUQ
         FUtuO1V8t3HjxOWDMwqzWExG4ApIH+mbPvJWBzd0GfZHQJX8YPwvTxh7hASCkO5qyB2T
         TvKjShlEwYeDdPVQwUeXIsvKxAvSQ6+u9IzLsQBzmfiScOuc0rleQIHZ+lymE2u/j4bI
         r+CL4vzlpecllIZ9hFIguXLel1NvkXa1QXGvD1rt+0H3sCmxlG7pwb9H2j39JJbdTJPr
         ldHg==
X-Gm-Message-State: APuU4Z8zU/lkJUtfu7UZI3x31Skvk28MXNVmdRibMe9oKqpV5XhcQUaA
	6IPwgNVvDI7MkKzUdPMpHWZQKEEK1ec2zwvU7ivBunGvprsHtMIOBuXtleg3tvw3CRXqGg==
X-Gm-Gg: AYBFou36xFHcZQ31LJ8OlkcthGMxIGLb4+YaLVQxzQsI3IBh62Ll/xA6sLnoaXRIwgq
	5WQ6tNp+2HSbuEjT6unOfweAyd2w+S/62S6vWaQy09tBhUbk76LkxoRrIPG8UPD9blBml6gt9kp
	2rHZw0eaftj0lD/xMdJxzRQAYPZInlzey2PvR8B+OFLh8vTgwYdg8csU4X57sA20GJeEpxELu+X
	dFkyM/Z4nKm47LWkv7kYiKckpwposYo0t17lLtxyOvgVWcBZTgLh669tHv6ebaqRPla+Wr85GkI
	Boitr8s0nyd+/6Ac66abIOtJjEdn3s7eZ7XIZ08abslJw5CUl5L4cFQkMGgFaCsKqzA0P3KZanG
	Z2RG6qRB2HwEw1D7QUokm9JPVYgli9uMpYkJmm694A0u68+vVKsaCGMfGJ8t8AGntsOkCZ2I7ig
	hDvD7Y+Bv4A3mdt3UJ9cdts1AxNXm0hl/Olfn2697GXM0GLvPMXmYviuRzySNjtxJd7q2Ccesf6
	V/ug2zCCjrUuNyVojaz6L9taZuDWt2/awmMVEFepXRjBPyTBbhuxZyE9huJtHS65HReng4+z3aR
	+20gSTYiR7HDLMkCI3f8LaH+t+/yRxBpYIp8916un9IS8QpWvNQ7lx1FtcTT3GE=
X-Received: by 2002:a05:6000:719:b0:48d:fbf4:895d with SMTP id ffacd0b85a97d-48e6e2e7552mr23436272f8f.19.1793639775208;
        Mon, 02 Nov 2026 09:16:15 -0800 (PST)
Received: from debian (ip-78-137-176-146.broadband.digiweb.ie. [78.137.176.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm23598760f8f.6.2026.11.02.09.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:16:14 -0800 (PST)
From: Pablo Mazzini <pmazzini@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pablo Mazzini <pmazzini@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 0/4] wifi: cw1200: add XRadio XR819 support
Date: Mon,  2 Nov 2026 17:15:59 +0000
Message-ID: <20261102171603.368298-1-pmazzini@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The XRadio XR819 SDIO Wi-Fi chip, used on the PocketBook Verse and on
boards like the Orange Pi Zero, is a CW1x60 derivative. cw1200 drives
it with a bootloader stage and two firmware differences: channel switch
and join. Patch 2 moves the per-chip firmware into a table first.

Tested on a PocketBook Verse: scan, WPA2-PSK, DHCP and ping.

Pablo Mazzini (4):
  wifi: cw1200: don't update the beacon in station mode
  wifi: cw1200: describe the chips in a table
  wifi: cw1200: handle the XR819 channel switch and join
  wifi: cw1200: add XRadio XR819 support

 drivers/net/wireless/st/cw1200/Kconfig       |   3 +-
 drivers/net/wireless/st/cw1200/cw1200.h      |   3 +-
 drivers/net/wireless/st/cw1200/cw1200_sdio.c |  13 +-
 drivers/net/wireless/st/cw1200/fwio.c        | 121 +++++++++++++------
 drivers/net/wireless/st/cw1200/fwio.h        |  15 ++-
 drivers/net/wireless/st/cw1200/main.c        |   2 +-
 drivers/net/wireless/st/cw1200/sta.c         |  12 +-
 drivers/net/wireless/st/cw1200/wsm.c         |   3 +-
 include/linux/mmc/sdio_ids.h                 |   1 +
 9 files changed, 126 insertions(+), 47 deletions(-)


base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
-- 
2.52.0

