Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9CC3CEB92
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195758; cv=none; b=CzjOzI1/GzlJYBrz5rCgK7EBJhUE8kZ4d2Ge3CKcEA8BPcIsaKeudPdeRbpMTo77Be47rWdaPb24Kmk4jUKzHcfAkwiwKMS57YZpB7Ujs9NWbA8i2VeSz1GCFAJ9D66BNSZtFpxLTaeLyxnjYvA5ejixGLOPrulg04WbWFttGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195758; c=relaxed/simple;
	bh=fROvojZ8WZZgnM03aenneJo2WtSpTXlvLq+FyJM90+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b3uKtvz8EsHWeyvsEFo2kBXrKypAgI8OuXGtItDAOdSgVoqVmPfYQbZLhJ0Ve4eoc2SBS2vcICy2JFkg5TC2dpzAEHUd/HfqSl+2HaXpW9BbRZX0Ugb22zGZagM+sUKdCY5nX96jN26m0r82in8Pjggb8BXyBpwh15ZLu3zDRvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pbq8tlXH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pbq8tlXH"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cacb8416a1so30799105ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784195757; x=1784800557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OeogIcp11s2Wp0/T34Ule4iKioNf6KUE3cXyHhlFri0=;
        b=Pbq8tlXHKYULjaHzp31CmBoMOnnTuURCG0eddUddG+bnRPTUd5fV739eH436iN5sP0
         fx5WxpPQ3CnR8xLYMWSNlyhDs7WFDrAMHAAAdNV0tsRq3Mo5aei+UU0X6JThKBKx25Vj
         TBo6rVVpalmaWA3BmQ//BkuvHoCYv8qMCW36crDdAi2fnRMWejHwnfLoFEGM76YYfMFx
         7QpZAGmptIvL2Z0x3h0bUWxKv1cb1DATIJQ9/KHNqGzJzgOVa1AZqUNsLMw6OFnXzyi+
         nTN6wfO1eHAyMDFr+DWvwfcMhtU5E/3I2VLyIRfUcKypqHeC+AZ4e0O+rdZtudyO0JWk
         l2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784195757; x=1784800557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OeogIcp11s2Wp0/T34Ule4iKioNf6KUE3cXyHhlFri0=;
        b=paQ2t6dHnoVQexX2y/8DC/nkgIjDuAsmdVzhJfdEf6YGIbngUh3kUxlhfbFu/nLffp
         wwdDQE+UdIGqc6tu18qJws+LB57M9P8Fdfe794CnqLNeUPr9Q/eIdTGRE3tgleE1uNdx
         tHUK+iRercvk0aVxMNRcPU/Lg2rN3Z7QHD8aUt+W7lPLU03CgHBtAzpOVOjDoRo1Tklm
         oWTsmbZHMtwoBsoIPfQXQz5YBBLjDC5Kqiwu4NVUs90TEqn6P9JwgoasYZnIZhYHSag6
         TUXOMi5kdrxyPiLeDaB1Pinb505cynV+Arg1OuaOp6cKYVXSQjtPKUBvCYfzZmdud2F4
         AdQQ==
X-Gm-Message-State: AOJu0YwrkIyTZENEnw9aAFvhLoSZkt3vy5OOhfJ704oTn3vKnkZWAMQa
	jKSnCPPjD1q5W4i6rZXNf/C/ScUj5EirDqx+Oi2Iyol5zhWyubcXSE/dI2BxnpMc
X-Gm-Gg: AfdE7clBbBjWAUvljDEL1xqtbZxpgXQftMKkDv2MI//aNkINCvO2zm0ESawMZoLD0Bl
	S1hM09gg9EITP7A5ajQAXeT/1VRw1fHAQKOPg4PF7jv4jU+bHtU9RnyKxsH+xgf9RY56cmip8fh
	89iaOMwOkqVv+yYs1B5eSoiC4iD2dYzvA/nqfStKfeTvVQc7lhT+dmTBXKTz0EPhHKPyhZR2q/Z
	cFTEWHagmUjBomXjDRHULvf2o1fPh6rJYbmlvWpQ4qMzw60adDjgGlc5p7GFBOMqYwaNs6xbeEs
	gt/bwiqOTdXt7LgKJZBG5AaaSKGiB7q9kj9iSm2Lr9i6zGoqqVNLPS384IVPI5GUVyg0VncHiPG
	2b3eOdJ1zUBFRZlotOwvgW2Qu7qFpX9WseI13wF3GiN4Fp/WR5Hfsi5WKzxMidmgzpOrsFLCG0V
	ObiaFP1A9ydq5j/fEcMOS65v2Ca5lEHyJI2TlTHPj8yQN6nwkHchxm6AzINgn7e9oJkUdWeRM=
X-Received: by 2002:a17:903:41ca:b0:2ca:cde5:29c4 with SMTP id d9443c01a7336-2ce9f4d2db8mr210930985ad.47.1784195756556;
        Thu, 16 Jul 2026 02:55:56 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.. (61-228-224-226.dynamic-ip.hinet.net. [61.228.224.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf100e44d6sm17495705ad.2.2026.07.16.02.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 02:55:55 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	ulfh@kernel.org,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	wyatt.hsu@nxp.com,
	s.hauer@pengutronix.de,
	jeff.chen_1@nxp.com
Subject: pull-request: nxpwifi-2026-07-15
Date: Thu, 16 Jul 2026 17:55:52 +0800
Message-Id: <20260716095552.25995-1-jeff.chen_1@nxp.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

This pull request replaces the previous nxpwifi-2026-06-12 pull request,
which was dropped following allyesconfig build failures observed in
linux-next.

The symbol collisions between nxpwifi and mwifiex have now been fixed
and the driver has been verified with allyesconfig builds.


The following changes since commit ac798f757d6475dc6fee2ec899980d6740714596:

  wifi: mac80211: Route (Re)association req/response to per-STA queue (2026-07-07 10:16:31 +0200)

are available in the Git repository at:

  https://github.com/jeffchen71/nxpwifi/ tags/nxpwifi-2026-07-15

for you to fetch changes up to 73b01e57ed3e3d6102c0cbcb21f62086c5429437:

  wifi: nxp: add nxpwifi driver for IW61x (2026-07-15 20:52:52 +0800)

----------------------------------------------------------------
wifi: nxp: patches for wireless-next

In nxpwifi, introduce initial driver support for NXP IW61x Wi-Fi chipsets.
The driver supports 802.11ac/ax, SDIO interface, Station and uAP modes.

----------------------------------------------------------------
Jeff Chen (2):
      mmc: core: add NXP IW61x base ID and block size quirk
      wifi: nxp: add nxpwifi driver for IW61x

 MAINTAINERS                                      |    7 +
 drivers/mmc/core/quirks.h                        |    3 +
 drivers/net/wireless/Kconfig                     |    1 +
 drivers/net/wireless/Makefile                    |    1 +
 drivers/net/wireless/nxp/Kconfig                 |   17 +
 drivers/net/wireless/nxp/Makefile                |    3 +
 drivers/net/wireless/nxp/nxpwifi/11ac.c          |  280 ++
 drivers/net/wireless/nxp/nxpwifi/11ac.h          |   33 +
 drivers/net/wireless/nxp/nxpwifi/11ax.c          |  594 ++++
 drivers/net/wireless/nxp/nxpwifi/11ax.h          |   73 +
 drivers/net/wireless/nxp/nxpwifi/11h.c           |  339 ++
 drivers/net/wireless/nxp/nxpwifi/11n.c           |  837 +++++
 drivers/net/wireless/nxp/nxpwifi/11n.h           |  158 +
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c      |  251 ++
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.h      |   21 +
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c |  826 +++++
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.h |   71 +
 drivers/net/wireless/nxp/nxpwifi/Kconfig         |   22 +
 drivers/net/wireless/nxp/nxpwifi/Makefile        |   39 +
 drivers/net/wireless/nxp/nxpwifi/cfg.h           | 1019 ++++++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c      | 3931 ++++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.h      |   18 +
 drivers/net/wireless/nxp/nxpwifi/cfp.c           |  478 +++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c        | 1310 +++++++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.h        |  122 +
 drivers/net/wireless/nxp/nxpwifi/debugfs.c       | 1094 ++++++
 drivers/net/wireless/nxp/nxpwifi/ethtool.c       |   58 +
 drivers/net/wireless/nxp/nxpwifi/fw.h            | 2475 ++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/ie.c            |  480 +++
 drivers/net/wireless/nxp/nxpwifi/init.c          |  607 ++++
 drivers/net/wireless/nxp/nxpwifi/join.c          |  787 +++++
 drivers/net/wireless/nxp/nxpwifi/main.c          | 1673 +++++++++
 drivers/net/wireless/nxp/nxpwifi/main.h          | 1429 ++++++++
 drivers/net/wireless/nxp/nxpwifi/scan.c          | 2695 +++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.c          | 2327 +++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h          |  340 ++
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c       | 1165 +++++++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c       | 3383 +++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sta_event.c     |  862 +++++
 drivers/net/wireless/nxp/nxpwifi/sta_rx.c        |  242 ++
 drivers/net/wireless/nxp/nxpwifi/sta_tx.c        |  190 ++
 drivers/net/wireless/nxp/nxpwifi/txrx.c          |  352 ++
 drivers/net/wireless/nxp/nxpwifi/uap_cmd.c       | 1256 +++++++
 drivers/net/wireless/nxp/nxpwifi/uap_event.c     |  488 +++
 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c      |  478 +++
 drivers/net/wireless/nxp/nxpwifi/util.c          | 1381 ++++++++
 drivers/net/wireless/nxp/nxpwifi/util.h          |  155 +
 drivers/net/wireless/nxp/nxpwifi/wmm.c           | 1318 ++++++++
 drivers/net/wireless/nxp/nxpwifi/wmm.h           |   77 +
 include/linux/mmc/sdio_ids.h                     |    1 +
 50 files changed, 35767 insertions(+)
 create mode 100644 drivers/net/wireless/nxp/Kconfig
 create mode 100644 drivers/net/wireless/nxp/Makefile
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ac.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ac.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ax.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ax.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11h.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_aggr.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/Kconfig
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/Makefile
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg80211.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg80211.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfp.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cmdevt.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cmdevt.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/debugfs.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/ethtool.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/fw.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/ie.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/init.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/join.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/main.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/main.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/scan.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sdio.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sdio.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_event.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_rx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_tx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/txrx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_cmd.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_event.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/util.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/util.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/wmm.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/wmm.h
