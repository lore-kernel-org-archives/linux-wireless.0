Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE8B4AB3BC
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791210935; cv=none; b=U9eFNVrdcZrh1pGFMoD16FB6uu7NSLQFK0wwzySdl5yMGLWm0xNoG7zE++hfWeraqDzJztE+/8HlP3MkxLfq+DgqRHaPVTUsYxtYaP1zZTuZiOaEfF6W/FgAUN7Z3vwNMMP2vcBt7kDXUt1vYT68rtMMntBo/gZaZnSL7hK8/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791210935; c=relaxed/simple;
	bh=7BzsIt0W0zlX4zWFBkLaGVeP2JETAjfMyZaGXrAqybM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jUjH4Wg+T86sSeuzNtzu7Fr1fRFaxnxdKbzdyRvhcq/iXgmg0AbiAcMYd2oXFOEb0Qm2tQlsU6IeVxs+rMuBOU5VdqWSocLbqhJGUtA2PiUPgaF+af/3M38crVxafirxjMQGtPr/FkEMvxZi+LkFyMLTmJpjtTPdXeBgvuwQo1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EdvvpnbA; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EdvvpnbA"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so17173575e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 07:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791210925; x=1791815725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d80qMXtt2qgyjUsH7NBGqXnx95+rJDKx3BYmmyNTE38=;
        b=EdvvpnbAqEkwkC28r/KxroXjYS05/XUMrpXV/5lbe00pAykDinB5QRsdC7RZl1z9U4
         QqakbelMxbQ8m+lmv+1odbB04qiCG+WJdSvDSQXjoDB5VIateAfkPR+284LjViQnt/s1
         uC0Bkwi/WrQgkBTKB2tbEXcq0fITbCdOC81sIEHu3AYrSZiKabhmsjYYR6wDFhOenJO2
         69KFEW/bVjKq+ipTQN5nCdZaSPy8mRqT2BlYTomP7VDpW1kDZLmXi1lgJAU+GxaNT3iL
         tvwsqWx+wtwxKFJLZoo39WemJXUpRnnxaTwnEQ7fnm94QfM6NS0ByNrrs/vhLIgfi+It
         yLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791210925; x=1791815725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d80qMXtt2qgyjUsH7NBGqXnx95+rJDKx3BYmmyNTE38=;
        b=Qadmk9z3WxNEwVy/Jq5nMrstyGNxp+XmWxkZCrnzzG+Hxr5Xz4DwUN7s40xPucX2rL
         4l9rLiiPPcinKiR3ET25U+EcH+H8yOaLtDZQzfJIJDzB1hW3tdiks1QUF7CPJ6SzEc0t
         NQk0NJP+o+bn7WQZeBKaGJxWwUVkh5dIklJZ/PIst6ACCm0RoAAT+SKgZQj5PRwdIwyo
         jLzJyFcHIujw6Sr69BWYEpHBG7jiFAD1R6669PcPB/GdoONR4hWdw1XalrubngDN1cdz
         BB4zj7pay1UeRBNoAJ8q5RRTCwfr93BfqDlldnvoPXsujK50+2bF4gNTtarvM578G5LM
         +J2g==
X-Forwarded-Encrypted: i=1; AKwUvBwbshh3FfTS+tHku8m5ni2qylAwfFZpcGHZcvtO4pag06//dVTJqsBaBAP6mIbbTnYzb45lt+kai+gpOO95aw==@vger.kernel.org
X-Gm-Message-State: AFuF++lekdQg3X3rwakuU/9G9wVrCQjrEShd/FAdC5kTjMSwmxl0OGL2
	9NOPKophBah/FDYg0GsetSrxiOTs1rh3IHRl/RyY6fCpAkOznXGnFGVd
X-Gm-Gg: AYBFou2WvncTDVHFLqxWtrDdV1ZHdpTa4tAjnSCnWg3iFwpt1GohNPiyj8Dz5zjWomj
	SVUY+26pc1densCbKfPjssA6YWVpke6q4E5V4ZqJoWzAoLi9pIgJ1H8fIuStRSsQDCxb4tfgWLL
	7AMM5N0Lx9gvop4RPo3dpcrYMBPz9SYrpCkWOyfSJUUVe/X3QAFH/Cm8yuOAwv6sdEi4UmWtbCF
	Kn699Pf/MDSrqtiyTzkNvKMRdQ9WaukieL/ptNpuPRwpe9xjH7V1mq5ICE1hQ46XTOtYhBStYLg
	ONMSFIvhjkKCBWvPD1uTL9ChdYK8SxSnrzA49B5QAGYTcOZm4uJVqTxVaPDOZVI4sjANSMprIWs
	5O7Y6ODznJ1Scqln5NrXZH3f0Kiq/eHpgwKe68cNrUmJZl6tQsFDlsRnsVkYqbxNDsy+0klmyI2
	BnoTG6BCby1IFUjj/gxb8FiITx9Dpodil/Xy5pYlmeuXffJKbibxsNw6DKzJg2bfinbe5UQvnli
	1S3
X-Received: by 2002:a05:600c:154b:b0:4a1:7108:c2b6 with SMTP id 5b1f17b1804b1-4a17108c4camr65216825e9.31.1791210925190;
        Mon, 05 Oct 2026 07:35:25 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027725c6asm396901835e9.8.2026.10.05.07.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 07:35:24 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Date: Mon,  5 Oct 2026 16:35:21 +0200
Message-ID: <20261005143523.130287-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

An rtw88 AP cannot change its channel: the driver does not announce
channel switch support, so hostapd's CHAN_SWITCH is refused and the
only way is to tear the AP down. The series fixes the beacon download
the reserved page build makes twice, then implements
channel_switch_beacon on top of the firmware's beacon page.

v3:
- 1/2: the beacon out-pointer is initialised in the caller (Luka)
- 2/2: the countdown work lives in the interface, remove_interface
  cancels it unconditionally, the queue wrapper and the comments are
  gone (Ping-Ke)
- 2/2: the TIM update and the PG backup on set_key skip the page
  download while a switch is announced; every beacon fetch advances
  the countdown (Luka)
- 2/2: the commit message names the refused hardware scan (Ping-Ke)
- the hardware scan path ran on an RTL8822CU, whose firmware has scan
  offload: a scan with the AP up keeps the beacon and the station, a
  scan during a countdown is refused

v2:
- 2/2: a hardware scan is refused while a switch is announced
- the rtw89 mention is gone from the cover

Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 93 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/fw.h       |  2 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 53 ++++++++++-
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 5 files changed, 138 insertions(+), 15 deletions(-)

-- 
2.55.0

