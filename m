Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5142DCBEC
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789824392; cv=none; b=LDfPAiJqOC7rjVrc4k/k9CYLMQ4AyCjYcUN2DQrCx4/mrAYmN72Z3CUUuc4Rrz8mzVjOO+vZ7nrxkloRNCaCE7cMgccO7AsCtjSfIV6Qd5u6eN1x28Fg1wouQKM4cRm0GYZm+D4H3RecBLz78t11Wz3enWv1+S22cR8RGOrk+8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789824392; c=relaxed/simple;
	bh=qwQt/V/hMMCb4wzKRwfQ5OhcT6sFW5XKYhmFKV5oyX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yy4OV2BFUWTqkTI0SRKWBNN6KG85cJ3/c0wxrXUZ6ZC03MsDRlkmuitOPFYKoe8rkenjmHEBW93gZ+jPzlsPSbJXlw6CLsoocs7Nahb+U0k7XKWYgMIMgWGyvnauhlMxb/IeL+oKF3zy2jzyF1yUiDgSqLTZgfJbUdPMLJ/K1k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=L7ONp/LT; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="L7ONp/LT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qK
	BSIum5xdo1AmBm85ZIDrUpAOT6JwDfLLrkNUVsPSA=; b=L7ONp/LTwo84tx7fyu
	alkl9hs9jY95nxDsY5NqfozTkI8g0pIKCwKl+043SqeS50rlzWEJUJHopmqe7pC8
	rFlY+eV7qAG59eSUS+A0iJ+a3IGzVarrkpLyTimsfICoSt3brcIuvoD+KKQLSE/5
	oCWbLbfAuAS5i3aJX3uIyNPe4=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wA3HiJsja5qM9LBBQ--.1544S2;
	Sat, 19 Sep 2026 21:26:07 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: chunkeey@googlemail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] p54: validate firmware record lengths
Date: Sat, 19 Sep 2026 21:26:04 +0800
Message-ID: <20260919132604.1455-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3HiJsja5qM9LBBQ--.1544S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKryftr4fCFyrXr45ur4DJwb_yoWfArcEvw
	10gryUuFy8Aa9rGF48Kr4FvFy5uw17XF1rCryxX39rWr9xJwnxAFs7Aa1F9348ZF9xCFW5
	Ww1DXF4UZw1I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE4rWDUUUUU==
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4g-EbmqujW+YpAAA3d

Hi Christian,

A short follow-up with the additional firmware evidence:

- The historical daemonizer archive sample fw-softmac/2.13.1.0.arm is
  available locally. Its published MD5 is
  8ff41cff31c9323330d6170b54735477; local SHA-256 is
  190aa5174c6c08632bf0c452c95509f04ae93705efb7dd88444938fd871d2308.
- Its BR_CODE_DESCR record is 0xb 32-bit words, with rx_start=0x20200 and
  rx_end=0x27c60, so the 0xa minimum descriptor check remains compatible.
- I also generated a private truncated-descriptor fixture for parser-boundary
  testing (SHA-256
  8dc5f14057d46ae0a08f2406d0119991c645365d2dcf8c71c6f5de6fe0f8ad53).

The fixture is not an official linux-firmware image. I have not yet performed
kernel/KASAN execution with it or loaded it on real hardware, so this does not
claim a completed dynamic reproduction or a confirmed CVE.

Regards,
Heyang Tan

