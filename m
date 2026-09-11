Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4A2580F2
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 01:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789091239; cv=none; b=DHQX8/UQedVlgH4XQ2/jfNwX3zcmiLBAPegkKeVQGBtVcVGzh9hbUp0MBVeGe7KDNt/1wMpTRyk8T9aBoylEBZzMq44igrYm/vxDUdMN1dfMB50ctDApQITkWLdzF5oFFCZ+hzl85KetzhwgY4AnlfzLFgXAhopstnMPo2j8D+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789091239; c=relaxed/simple;
	bh=amircKFsQSVMD+/rRrvYgzyM8Q4jO7GtQCebWYtVYtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R4X47VFPuUetyG/xqxcMjrn3dhkgSDBKDXKTitfJrv3u1V9lxDuJ6sqpa3KARVPOTCb4fBWwwClFNEjThe+2/4kIc4uxnlI8TK6wdi7CzrOl3pwe5Q8Kn9Ice378Tr2UhfdPZ1O0AzR/jV70WJ9DSH3vZvW+rnyTS7+Q6o/Cu48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bqn0H4nH; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bqn0H4nH"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2940d16190so66215166b.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 18:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789091233; x=1789696033; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=P/JdhZuJmGxbdPBATNQfsl32tQ2hN7o8XLbvAZezdWc=;
        b=Bqn0H4nHXydJ3mT6sbJfQvVPh5cJIAHTozsX/i7ktuGnieA9QereZsXcbEGLeVbrfl
         KZFOT80L/aVVMwIc/Jic4tNEQ4h89nSLTE88y0MDGq1tbmnHHmHzltNO5faU/TNu+Q1b
         oVIw7nhicMcRHYl3pEQ9PEevKnPAYVSAyhd6cyOsy17kJy4mzcvOYdSggjIxAql+pbRv
         7byNUKnwoA4YFPHpfti5rx9L8BurJoWjmShQGmwEqHrQKAdfp5+QsNpkIPVei3CdxXPl
         phXIX+N048RPG7oX4Q+7w+MDNbsOdU5PcsWo1KMpn5x7F0n8UHyBBrXlBliMO6cblSNI
         AeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789091233; x=1789696033;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P/JdhZuJmGxbdPBATNQfsl32tQ2hN7o8XLbvAZezdWc=;
        b=Dy0QI+DHZ0zRDgDxac1YDG/1jmXXuvrKT1GOMJ+EkX7MMyaJPS+Tc6M2cPpFuE43iO
         8Vbg9b5moQuPP32583fulnlvQoUmfpSmTHpOCs10rO3vKLe1sZz6UIS3zJlh6fs8gaz4
         X7C1FLcKgETNrS3QcvYtsw7+kpwOICbpP2txse0Md/THIaUc6Iu4pF9B2790pMtleyaq
         xCCU+88QbWUgXG3Ef2q3vKodr6DYj/moAPvmIvlwE5l8AxSa2qHXNlbu55Ul5JanPYIJ
         1NUPCb9QJZM86kFIg9e3EBl2kLxGu4ABuDuShAUTMJf1LtzS/EuZ4Rvn24b3bBExDnsX
         FqiA==
X-Gm-Message-State: AFuF++k7fbLBzTWxe2Nf6bh1Ue4LL6tnJHBHHJsfnp5YwjraqgrAzjMf
	Q4vWC/1SjIBJBC9BvXWPAihWbYkgMfTVMRnmGnp7/5CglOGSr/A/1Jk=
X-Gm-Gg: AYBFou2iAH4P7JNRPAzcSHAakldWqDtddGFtYiaYz3B/qlbs4mZHAONyoFbtyQToGSx
	sT1xxiMisP775NLmBDKbe6qzV1PdVrlijlczuVCEHsq1U9I9NYOWDSpl9fl2yQFZ+YMdLU/vO1w
	Pzhga5qx6nUUPT3VrMkKMh3MsYqxeRnEZlZSnYe7PtHS0e/gCoZTdR3Jif+LlpmdNFovwomkpnJ
	xxvjRCgqqxrSaYjybWYsUtHpOzeUx/Xv/isSEBTKLIJbeAlXGhvGzQ4d7D/HQy8sfazExXBm/Dy
	pKvk6mDNnpKdbg50G3uJaxDIMnPkGVY3OJ//o+gAEcu+jqNTHmWUMpv0cf/zbcg4z9Llt02bMIp
	G3AG52az110ztZG0k+QvlR10fX6ar2dBRRO8fSfZJiQWbnHGeA3+rKxCJiZPprXDaI+zIH1RpFL
	IyPRSn5TXdj99JtiFwfIznM+husXACh4HBxJSM7xixdS/eSyhhcrmjSc2lbcfv9y6Y3a01gVONg
	2kdMx5XvQsVyfNT2hbJCpNxREWX6S0te0iMVaLfGAHwa0m4ZWcK5/qGvSDmIUcHJVGfKUmiSohs
	Qlc/RrmPC38UVGA=
X-Received: by 2002:a17:907:3cc3:b0:c12:e178:9e68 with SMTP id a640c23a62f3a-c2966668eb3mr59141366b.19.1789091232657;
        Thu, 10 Sep 2026 18:47:12 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966021ae8sm28097866b.22.2026.09.10.18.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 18:47:11 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] wifi: ath9k: fix the RX filter handling around spectral scans
Date: Fri, 11 Sep 2026 04:46:51 +0300
Message-ID: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patch 1 is v2
(https://lore.kernel.org/linux-wireless/20260904181709.788886-1-nerijus.bendziunas@gmail.com/)
with a shorter comment and message and the Assisted-by tag in the
documented form. Patch 2 is new and needs the helper from patch 1.

Tested on an AR9271 (ath9k_htc) together with the pending spectral
stats fix; ath9k is build-tested.

Nerijus Bendžiūnas (2):
  wifi: ath9k: stop a failed register read from opening the RX filter
  wifi: ath9k: clear the PHY error filter when a spectral scan is
    disabled

 .../net/wireless/ath/ath9k/common-spectral.c  | 13 ++++--
 drivers/net/wireless/ath/ath9k/hw.c           | 46 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |  2 +
 3 files changed, 56 insertions(+), 5 deletions(-)


base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c
-- 
2.55.0

