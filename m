Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECF64D2ED8
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 09:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860320; cv=none; b=QONz3AoEzUJTcsRpKjZawpHx8ED5CFcD2fM4nOsLdqzp37OWNSLPYbTGBXSl+4r+jXM9hk4ETHQEtlBPAJ3NgzUPCUaWE53FGj22SGyoxMyqWwoQB+vs6ap3Ijrf6pW2zNxBTndBf0+fzFeYIB4TF7Md895OzjF47M7jSl7Canw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860320; c=relaxed/simple;
	bh=dw3ifo+Vs4AfVLuiQB5RFEfyx7qGf7x+AkemF937nMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=anV721k/X+cjCms6DYsK6ntcikS9YAclqFhkEqawEm58cOP5No64v6/cUVyKO60BcGm1daWP1jfFTv8ONdGk3pzKSWrlirSXcDxQiN3ggQf6/xYl/4a4VkobnuXub5CSlgyywfj3PEtDahHBydTtGRkIKvvJahQX/MfKBt//YbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFyPfgmE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFyPfgmE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d71ae3455aso69632015ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 02:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860318; x=1789465118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EfWoUvk4MqKppy1+qmN7/DqUC6o3V+gob+0zbDN5fk=;
        b=iFyPfgmEn8Bfhle34DDgvcXJjKfivpDvytMbwSbl6qgnpeWvJidhAY1/hS8D+ujv99
         MNqLX2dUZ/en62yOwHGWuu1swCLeSfmPiw48QUyx6cOvPyBwTNOwnG2ZcDZTkUYwitho
         jUWljuYXxHAmdCiDv16JlNE2c7L87D4MQKSMewRlOzS2HRWlWoZQavdgFBDiOo9faD+W
         9VjckdW131x2o/yctqtfV7/tu+R6TGFzTYGgF9qaa1P8EebYaeiV41i/stVQlHmL4+LL
         RkyfIcIlV5PlmUPkfA6xjmb0owOAU+N31NZsRdMxduRTyRgYYnyfx40CsYi/urc69AzJ
         xAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860318; x=1789465118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EfWoUvk4MqKppy1+qmN7/DqUC6o3V+gob+0zbDN5fk=;
        b=k4jPJuBb9eveAnN7m5TETJ2C2O0BAY9oh1GZcRoHjyTkUlrrPO4T8KQjPDt+efNLWD
         /ypMybX5npEM52RVeyLmgde72KsndQ2FgRwMO0Clr39UxhzGMPQaNIzjZIerrtiyPQXG
         DBJ0x3eu4WjGGw1OSg+F8cupx2jzQiP4ulrp8x6x4VH5yJrXKUy/rZLGUgVdtC+r+fSH
         GvVbPiJlvGaFI6Va/eCF/DrkvLtXW/tDLwue8GnLKRF8EtKfUS0d1LlWrNuQ7DmiJIc/
         SxsKWw5FAWl3pVQpFZXVV198uDSVOInqUBzjoZUCDM3MYKOdoJGSouoAV+1pfiQiHqhG
         8lpQ==
X-Gm-Message-State: AFuF++lXsjQ/h5rBzSFBn/GKqMCLAD1ovcedGMUw/x8cf3h+oDXPbLNX
	V7CmK149T4OZ+aq3xnPLL6z8poAZxfDuKU5zfnkVuIA1xmm3Zc+OQOQ7gvkijJgkCGA=
X-Gm-Gg: AYBFou3cj7Kw+Xj2hkhBIrN5ahlgwZtqp0L0yKBGUPTw56Xx7YQ4ks1BhrW0/XwXv5L
	nUoaVDHnTY8zulDr4lcfJaSlVkIQpDS+QkI2njh185OIS70Oc7rNo+ZOqhMvl/JxaRG6PNTIGmT
	dhLvNDe5I1b2O2W2jrHVLieboydVXVrdaHPN6msAcc+e0anVvQBjRCHoKiW5mRyJTKaJRXdV+fu
	k3M/OY+4WICLEY5WVcHM3XNK2OLq+Kxbc7fD6eMDfuAKohd7GGH6BBeHY+afkdlErWU6Q/a0whS
	Mo2t9q56i2Bmxnku+szO1wTU8XFLjZQRY2UI5WVH4dBd3ZjKx6OHtI480mUjGi0GG5hyTZ027J/
	WVjDkGF+nx0FtheHjUj7pNsZ7D601nCfvS0evmGdrEpRSRVET7rMN/8HEfiE5pfCtcpGQCPzjZl
	Z+KF0EQ6MBUuE4KMu+yRJ4g3syvijpRYTewPCUKUtYx/BwEC47R0ST+7O5kMUO5+E/AqLMwOenW
	xZvCDtNYUOoUMStM7U6/VsZUhASA3SY7pJgZcRe4GHCA0xcGzKpQQAhrwjx9MfMLe5xDg3TwCpE
	5g==
X-Received: by 2002:a17:903:2b0d:b0:2d9:1dee:43db with SMTP id d9443c01a7336-2db1284b6dfmr404892985ad.15.1788860318084;
        Tue, 08 Sep 2026 02:38:38 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9f9sm54848085ad.32.2026.09.08.02.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:38:37 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-mmc@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next 0/4] wifi: nxpwifi: add support for SDIO IW610
Date: Tue,  8 Sep 2026 17:37:54 +0800
Message-Id: <20260908093758.596444-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

This series adds support for the NXP SDIO IW610 to the nxpwifi driver.

IW610 uses different SDIO device IDs and a different firmware image
from the existing IW61x devices. It shares the same SDIO register
layout, so most of the existing SDIO support can be reused.

The first two patches update the MMC subsystem. They add the SDIO IDs
needed by IW610 and apply the required
MMC_QUIRK_BLKSZ_FOR_BYTE_MODE quirk. The last two patches add SDIO
IW610 support to nxpwifi and limit channel width requests based on
firmware capabilities.

Ulf, could you please Ack patches 1 and 2? 

  [1/4] mmc: sdio: add NXP IW610 device ID
        Add SDIO device ID 0x0215 for IW610.

  [2/4] mmc: core: add IW610 base ID and block-size quirk
        Add base card ID 0x0214 and apply
        MMC_QUIRK_BLKSZ_FOR_BYTE_MODE.

  [3/4] wifi: nxpwifi: add support for SDIO IW610
        Add the IW610 device descriptor and firmware name.

  [4/4] wifi: nxpwifi: restrict channel width on 20 MHz-only hardware
        Do not request 40 MHz or 80 MHz operation when the firmware
        does not support it.

Tested on:
  - NXP i.MX93 EVK running the NXP BSP kernel
  - Lenovo ThinkPad T430 running current wireless-next

Jeff Chen (4):
  mmc: sdio: add NXP IW610 device ID
  mmc: core: add NXP IW610 base ID and block size quirk
  wifi: nxpwifi: Add support for SDIO-based IW610
  wifi: nxpwifi: Limit channel width based on firmware capability

 drivers/mmc/core/quirks.h               |  3 +++
 drivers/net/wireless/nxp/nxpwifi/11n.c  |  4 +++-
 drivers/net/wireless/nxp/nxpwifi/fw.h   |  2 ++
 drivers/net/wireless/nxp/nxpwifi/sdio.c | 16 ++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h |  1 +
 include/linux/mmc/sdio_ids.h            |  2 ++
 6 files changed, 27 insertions(+), 1 deletion(-)


base-commit: 1b60ed34f712e9f606d80951f1586f4274ebadf1
-- 
2.34.1

