Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682343DA7D0
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809595; cv=none; b=H2lSd6kbqzvC5hVpPfnNuzeCfY2AaAhCt+pDOp42d/HpGurmfplt7e120WpAgLNdImXa/KX9RbMkdzmIG+gMbtEh+1apWWGzs7G4kUThsWTRIb8OyHCxQ3yoBhFMrQnHdr/ARA/L4xeIqiFM7tKj8Olvgh9ZwuZd59h7LDeOSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809595; c=relaxed/simple;
	bh=Ky24fkOlvpW/axx+hbhH/j7Am9aQbqxDDkSMG2lAlKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R8icAOLJgWie55HjRbQwBml2F14jzTGfxqxCCu8cPJvOgZV91aB+ZQRwlMSQOOX55NlhApdRgxapl7Y8cj0jNaAGrPPSwApQx3bv5ciNKlmylK0KzP2eN+3rrlwGQEmRnnT9uS3C4+a/8j9RkM8CytXHbvw9+GYLUqSdCU9LusY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kn6MRJRn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kn6MRJRn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so15793455e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791809592; x=1792414392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=//6PZzEPE4dWFH43EiRfnDXZN2OFddxQZ9MFM56YAAU=;
        b=Kn6MRJRnYcoe3cOsLAHWBaU7YokfIKgn1L36Uwyq/vkzKaTNc3SbSG9Cd0x7nV9FPe
         8ZXeBK24GqlpbJcYqhfSSdfk51LYHuzxoPiwNgzKFV9Z/K1gtsm2R06BbYGfvsMmxJxb
         WbPUifHOK9l6UIml8QI2nELyv0kl+34W5ZIa1zb1yw492E02IlxN/+X4WVZMyXx2T4cs
         NiDASvhJdFRH3R/aAuNtEjkyrU8pJGp5f7eSkJJE7O4Od6l8mR8kaEZWalTCTNb0Ql0+
         BEbbFrnQ+T7L6vZrqlAkwQHELGeu05ceqdM9807tpHQqZ/PyydN0PZikSErnnfGEdsdD
         e8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791809592; x=1792414392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=//6PZzEPE4dWFH43EiRfnDXZN2OFddxQZ9MFM56YAAU=;
        b=LDG+LA1kbNjbN+EMheIyyDzx5f7HpxzXRcPAkMw1NxH4bmxES3sJxYI7s4nNG8RF3D
         6daYc13Vrjlt1fg9qtGJa/AG/NL0w78hBp13zNKVI1z5p17XTzXQ6e+BniTAUdKiaUEh
         fC92VfaMn5r16/0NZcMMFgwf6VvINeXcDz02bAqR2w+3zIlTn0oYZzSSQGLyKzzSkVdH
         1rx/w5DUCrnsIRmTiiY3dOI3Yn68jlwQShNPecfjfsIj3zQPZVruFr2Ls2V+PwfKb/T4
         wrepUkn2gNCFX2PcaAVs7XVAra/gbHulRq5/JMl5J8nAyp/y63X4/6guSDKghpN+97Ut
         AvjA==
X-Forwarded-Encrypted: i=1; AKwUvBxI9eENO9X5SvW4kKSbigYB9+g1BcEWPbRSWB63XtipCwuheX09MqrccxhTHkwP32GvsPd2XIJ+5UTIN4+TWA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIXrGSBjO04xineDeuUOJOHHyhnM0nQ11m9pQh3xKaQ2tdnhSYa
	dS2We/duEK1yqOpsbvHZE9NurXMcwUXQS78a6Jz6XWu43ozeScCa73O1
X-Gm-Gg: AYBFou1mlVBtVjstW5ORKdSgpznaH+ucepopbI2dv2XuM3YIsqAqm9itr5XqZmoiLHH
	a5O1537VYr7ssFa7DpPAV6gDQi3T7prLcvYLHoyUNYlnuymL+W0e2wD6/0AkfX9MpjeVvU2Er46
	T2mhrJJ9e8lgVN77SoaNzf+oOirFjyTopa8VIgWkTBoYxlQO6xhD1TzCGZNe+VZYDdnma3K9Ztp
	R4yERdE94zrfgMN3pgIqq2moPEL3Hkew6I/3XAfSTpUjGMv7cqPkwjrruLuDHWFvej+sKKerBtK
	QJUPNxXQoIYcKN9kU22ru6dOAvY62DzI4TO2wYGsygneC8bC05jWl2nZM/hY3QgrGuUa4b0UOqR
	N+49bsEtqGlTD5OWsRmqTlbv+8d89SugVSDN2NnYFsqjb3yuweFs7x4vquf4XZFeZYmblTJv+1f
	AotObLxuH860N6Xd6w6dxwuWgqEyoqTd/VPMCAyWWkSOrvQaxIZ7eSnxPsFdtZJmb/FhPWERnvm
	We79krytrLXGQTcXDZldUauc34WvemQFgampCfnseDfD76N2yNriFDPRPf2Ra5oy6mUS+cw+w40
	IOIXucl+p7dNBGA2PYyRlxtSPGy+sv1g8G4lntx6cKnaSmlvHd2PVwcPYoscYzghAKAJOOPLpWC
	gBUEc07shUEreMXNXZ8zKPsXnqMOBCQ==
X-Received: by 2002:a05:600c:1d0b:b0:4a0:13ea:2ec3 with SMTP id 5b1f17b1804b1-4a18e4ddca6mr180915645e9.35.1791809591922;
        Mon, 12 Oct 2026 05:53:11 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-c000-0ddf-7da7-06ec-e37a-072d.ipv6.o2.cz. [2a00:1028:c000:ddf:7da7:6ec:e37a:72d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18e49792bsm460701895e9.4.2026.10.12.05.53.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:53:11 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Sean Wang <sean.wang@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Allan Wang <allan.wang@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: mt7925: status LED of USB adapters and linux-firmware
Date: Mon, 12 Oct 2026 14:53:10 +0200
Message-ID: <20261012125310.13917-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The status LED of MT7925 USB adapters stays off on Linux. I
investigated this with a NETGEAR A9000 (0846:9072), see [1].

MediaTek's Windows driver for the A9000 (mtkwecxu.sys 5.3.0.3230)
controls the LED using UNI command 0x2a, with GPIO 8 and a TLV (tag 1)
specifying the LED state (on/off). Sending the same command from mt76
works with the firmware from the Windows driver package
(MT7925_E1_ASIC_ROM_RAM_CE_2249_CCN10_USB, 20250424), but not with
linux-firmware builds (CE_2249_CCN16, tested with 20231227 and
20260813). The latter return status 0 but do not change the LED state.
All 16 MT7925 firmware releases currently in linux-firmware are CCN16
builds.

Could you clarify:

1. Can GPIO-based LED control be enabled in the linux-firmware build
   for MT7925 USB adapters?

2. If not, what is the intended way to control these LEDs on Linux?

3. Is GPIO 8 common to all MT7925 USB adapters, or is it
   board-specific?

I have a small mt76 patch that registers the LED for MT7925 USB devices
and sends this command. I will submit it once firmware support and GPIO
selection are clarified.

[1] https://github.com/morrownr/USB-WiFi/issues/731

Thanks,
Josef
