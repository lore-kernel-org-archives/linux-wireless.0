Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8683A5E8F
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 10:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678041; cv=none; b=d3ABT0vl8rSPYUNlTHabikzs1WoHSNqzM7WD2IjVd/B3n6yVlaBjW1o0L6LVcqZZ+Q2hbmMeJ5wJLhgDntyPbPOhblVOHQEOE2hXaNmA750S8OTFAaFAAMslhokW6Y/UlhW/P24lxX6C1MDhwzS8OMk+Cpf/hAQIJVjUGkALYww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678041; c=relaxed/simple;
	bh=htRw5A2eeaGRXSK16KrB4PjKAa+fV9li70NVXpHy+rY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ea6oL1r3c4vBD0aVbpWDi1WnLbefmByFdK/h6UVDq+Qts55qEyL5QlwChHMnZ8HpaGKDtRO90kiz1h6Q2feRow/8i6TgXSxHSAGa9d3TyqLbo3IHhZBVpveNw1uL8/XNOCg/0jQt26mdqWQBEAvkaWP4ca8PlKE3SdsYyHWN6ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eIRAmOmw; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eIRAmOmw"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747eb79f7so18035265ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 03:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790678022; x=1791282822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GY7WsbhkXUNPSDmmgEjwhydCnxQPCyGdB9edOz5MBww=;
        b=eIRAmOmwWLVPQF7skpwowsXxAE+An+3uAx+HySQGrDlrT86BvklpqYGlQi4A2XUvtd
         S+vzDaqkzhJYIRomKoqOy2zbx55vH3BzuPPHxurOQWCtXmZ4SYNTwzr72qnjlyuCnGz9
         RWgCIi30ucFGXhzQGrtKkCDa/CtANfAKJUQMHwjpEfFBzrEt6QtIPoOPeWV+1hPOmAdq
         AuQRKAQRI61MC3ASlMbFKg+tqsg2GP0dcpUs9pat26nC3DfdZa/nFeVQycE40di516l0
         nn5yX6m46XQQ2o6uCt2PYkzMsHMcybg1yRhhVUBNjTJd9+XKVJgM56ikJFXsfboOR06y
         5TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790678022; x=1791282822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GY7WsbhkXUNPSDmmgEjwhydCnxQPCyGdB9edOz5MBww=;
        b=QdelMA3bdgLnK1XEOSGGIfsBc+mrU2dDR3YWDB6rw+Ovr/T6Ipjk6DItiWFIy3earY
         y+BpH9D1BfGK3ThDiyPTqbdKR/4QDpKdgxhBNjYtMZYVWtO/vxmoqk4uNZQrPsqnJ6GT
         Wam7b4iELkoCh8gDO/W38u/bZqQ7Lcv9rIal+/Y4Hi1TRlPWVLFLc/JUXbUocfbFuBFR
         D+5t26FtSmMTSbuV4B2r/9yNppAZzUeF47dq4L1kqVQ0JhnIEuTzuPApHJGyx6zriVpj
         AR1qz9y6iiYXEmCY0eFTonNP9XjHuA6ZkQgt+E+iacKmlVDcBeFMwExJWXt6jFqtvZka
         pIng==
X-Gm-Message-State: AFq9FYIeW4NAW0OStI6dk+fJXQRY6ecQ4sqGYD7gxNTqv3uhEDsOvM8G
	cH2EwYEFfhmMkuchBkdu0ykWzkzhoGeGALO9AvGrYDiuGLwytblEYy/b6dV5kQ==
X-Gm-Gg: AYBFou0whryp5jRDD9NCS4LNaO0zRZSnnnmnV/FuGVRkr8+fcyxvi2zn+GiotoGRpxN
	w7srs75VYAUPSkd6dTe8IUbUWsKqbOwqVKwU962gIC9LjsXFyIDzd9QsV9CYG2LICxrAuy4imoV
	y7NPOyBvawyV1J+9ss9FEI/t5/VNIS/BY0z4PgrgW6/lky8hSXX4mzBA6qgLMejRByC+Ku9ExfK
	BCbfVdkQPWQy++Wub/aNIqLTLS2vFPsGObHUbs/64Ckx6Fb6lxWWPVmIYHZEa3poDltLErmScfV
	mmPHnYvS2HCN8uxCu+JNmr05HDqiw4HoVt9xOdf4JGVVOKcP/af01KGiCnGcc+a9xPO3vPcO8YV
	mxAVxOdbgVzGHW039ELtUTWG2UJlYL8vv0UE6F8/e78BwWXjsmHO4l4nBQB3uBVuR+zv0ik5XOq
	12hUj6oM7NZnfsVQKR4n9KfkTi9QO+QwIYtOsF3T1OURvmOKmwCxCcWb95KHIqL+1/rSzRqtXi+
	ZtlCyvAWv1G5JlfeyQe3D8IYGbHVgM33KNev5MybGkfEDhUpEcgbOr1D2nh0uY0DHvG/3H+iXJR
	3/OMJvBIZEa8uLw+mG0dtuLO
X-Received: by 2002:a17:903:2f50:b0:2dd:c0ff:e72a with SMTP id d9443c01a7336-2df7dff64ffmr118792995ad.60.1790678021515;
        Tue, 29 Sep 2026 03:33:41 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (61-228-208-95.dynamic-ip.hinet.net. [61.228.208.95])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2c9788aebsm6974445ad.52.2026.09.29.03.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 03:33:40 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-next-20260929
Date: Tue, 29 Sep 2026 18:33:31 +0800
Message-Id: <20260929103331.2797952-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

Please pull the following nxpwifi updates for Linux v7.4.

Thanks,
Jeff

The following changes since commit 21b4248bfa0f410fa22202fc2c82f4808d672cda:

  Merge tag 'ath-next-20260927' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-09-28 11:49:26 +0200)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-next-20260929

for you to fetch changes up to 8badd187550ad3e67313432df823467016a2f04f:

  wifi: nxpwifi: bound debug info output (2026-09-29 11:54:40 +0800)

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
