Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF2F5383D1
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790692895; cv=none; b=aPlk83kXIvbQUSHNvcOAuW8U+//jRTkqZtbR9osvUKKmcAVEMLHVJUFXlkQMXLMWYnQ++wLv24WXDgjH3HFYpSDw1BPRo82SuycK+YTN4cjy14ZKPm1E6Wh+SHqfjOKFEdWaGddb94fd9riOlOejglDMsnfQkT3LdQT3KpVagNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790692895; c=relaxed/simple;
	bh=i1oZBoPzBAV9fD+nq8Cl1Z2N1eJ8Inbjrh6gp3kU/ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oggbQyfdGluBeNOHSvJIOWyWc5PyDRPnmdijGgJQr7IUbj8Wew06LKC/sPPveMmPY07CaMRfb6Ng3b6MRQJOefHqIVue9YbAc/BUWsT5vh6nmNIUuTG3Z9rPMb5wN4el7XOXFVTeJ0e8yTvu3KO1OmtJp37RaDuu3LG11UeLToo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eO+tv4nY; arc=none smtp.client-ip=74.125.227.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eO+tv4nY"
Received: by mail-pj2-f38.google.com with SMTP id d9443c01a7336-2e2d58a3b05so2770435ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790692883; x=1791297683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AwBEOVFwujSDCuRHLPtAZT1+TW+zTg+/OKI7oy+GpAo=;
        b=eO+tv4nYBTDO+RZb6ZivCzxiclJYt6nLm/2XSf87LF3dU0DB8cfA/qMmsHsIAL9Ce7
         fxgDfq8aXdybkTL8UmMATmzcLa0loq43XHR1tLWJCmXC2vVwS3k84bo0+mHs2FLxPtkF
         wTQDcFgf4izMRfBun68uZP1QVxKIuz3MMAO6XHbTopH53liTCs0gdDfW9aR/sIOG7KTP
         3PCsybsXBWKIUVf9h5BpweJnwnVpgpfBYV8ajb0l3t+FZddB/EnV/C+fzkoV5CjBgAdr
         Mf1eBfHNFp3zfoVr2ZDFCH6JqGOt0fXhWoeQyuXAi10mgId9+lB74hpNevfSipKaMeLg
         lDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790692883; x=1791297683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AwBEOVFwujSDCuRHLPtAZT1+TW+zTg+/OKI7oy+GpAo=;
        b=cMI9K4l6qIgXwyspdLEhMDfo3lBgSlaQk/wzyQlzEaxSEuQdKmt3E4S5XK4OTNSJit
         2UHF8R/t0nU4Rm5MlFrDBvpf35qt9ThVjqnMoWH+PqwL1ihFFxJk5VXAGYokWiC0F1ju
         i900a9CIl1YfNa3mxVJpsHGjsKtylDjWZ9YuQJoIR4Y0vqoIGplNn7E2DaTUrVWfbhi6
         HbkJZw1n+MFYlPU+qjrkpyTqwoT4qbGWoklKyPDNXs1wWNZaZyJW7PvL8J4k8EmTZKRe
         srOvC6xe4PaPF5y9ta6rYzbmkrbIJJW33XRKLp053H/RUtYxZcFpZXimznZhRRyNO/Fj
         Xn5g==
X-Gm-Message-State: AFq9FYJvDTTynmHjYqrq7icPYCoXn9RVHs/cijxdemejYiUNu/0uhacC
	v1Z9+P1Gq0OjdTIbyzXmz9KUxewYaFB46SkLzFU2/e17UE07bIX5G7pkBiVdog==
X-Gm-Gg: AYBFou3hj4IhowxRIg3SWF62tMZaSOctJp2XWDnJXrBS2nMbs9WELT4aVNJCJXiIrI7
	JsUfGu7n3vvA01MwjGkNwMhu6zanawnCmPnKlmO21C+j4FCOkoO1pH41B96oxB3mJMBiogcrCkI
	pbzzxZiTv1JsM9mhrGkCmC2ggcWXqiRva7+zd+7ehpT2iwZn6IvBdooYov6Obswrgik8sq3/1da
	oJHoO18/6tkqlhE4m+ZCbDU2xIQCAN4ntr1a4bXfwvyNGAIb8J9avZYf+SEM3MKmpLaHjy2z2hO
	y3lU15M9lR2+68hasWidFR5Yqo9lvxdyGU/+wQ+6tF/2peqRW+ePS827VpaYq5RQ1AeJ+Wa/I4i
	e77PZvARADDDN0fp/fLbXKQfeG50Cg2JDt+qDXN22gTMLLoWyklKOlA+a+JGYdlkn5OZ2Pz97u8
	Bya+5gyCkZSo1lDpFHX4/wvES+AZk7mo8KAaYA5thmC4m5ohaOOISh0TovogJRNveaCHW4v988a
	5cytTPwvSkJiIYJT4u+J5E=
X-Received: by 2002:a17:902:ce0f:b0:2e2:c79e:5448 with SMTP id d9443c01a7336-2e2c79e5617mr22185485ad.7.1790692883033;
        Tue, 29 Sep 2026 07:41:23 -0700 (PDT)
Received: from NXL73750.nxp.com ([208.127.158.149])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dfafe765cdsm40198035ad.33.2026.09.29.07.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:41:22 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.netp
Subject: pull-request: nxpwifi-next-20260929-v2
Date: Tue, 29 Sep 2026 22:41:18 +0800
Message-ID: <20260929144118.743-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

v2 only adds the missing committer Signed-off-by reported by Patchwork.
No other changes since v1. Please pull the following nxpwifi updates for
Linux v7.4.

Thanks,
Jeff


The following changes since commit 21b4248bfa0f410fa22202fc2c82f4808d672cda:

  Merge tag 'ath-next-20260927' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-09-28 11:49:26 +0200)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-next-20260929-v2

for you to fetch changes up to 38eaf7cd6b3ca4f4fa2a086096558b701dd919c3:

  wifi: nxpwifi: bound debug info output (2026-09-29 21:47:39 +0800)

----------------------------------------------------------------
nxpwifi patches for Linux v7.4 (PR #1)
- Add IW610 SDIO support
- Fix error handling issues
- Add bounds checking for debugfs output
- Validate variable-length IE parsing

----------------------------------------------------------------
Aamir Ahmed (1):
      wifi: nxpwifi: validate variable IE lengths in beacon parser

Heyang Tan (2):
      wifi: nxpwifi: bound histogram debugfs output
      wifi: nxpwifi: bound debug info output

Jeff Chen (6):
      mmc: sdio: add NXP IW610 device ID
      mmc: core: add NXP IW610 base ID and block size quirk
      wifi: nxpwifi: Add support for SDIO-based IW610
      wifi: nxpwifi: Limit channel width based on firmware capability
      wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
      wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()

 drivers/mmc/core/quirks.h                   |  3 ++
 drivers/net/wireless/nxp/nxpwifi/11ax.c     |  2 ++
 drivers/net/wireless/nxp/nxpwifi/11n.c      |  4 ++-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |  6 ++--
 drivers/net/wireless/nxp/nxpwifi/debugfs.c  | 31 ++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/fw.h       |  2 ++
 drivers/net/wireless/nxp/nxpwifi/main.c     | 15 ++++++++--
 drivers/net/wireless/nxp/nxpwifi/scan.c     | 18 ++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.c     | 16 +++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h     |  1 +
 drivers/net/wireless/nxp/nxpwifi/util.c     | 43 +++++++++++++++++------------
 drivers/net/wireless/nxp/nxpwifi/util.h     |  1 +
 include/linux/mmc/sdio_ids.h                |  2 ++
 13 files changed, 105 insertions(+), 39 deletions(-)
