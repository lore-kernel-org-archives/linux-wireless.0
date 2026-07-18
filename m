Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8E381B05
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784360443; cv=none; b=mh6IslB+5BqbX11FDQBIS3AARFln19UwOYt+YR5UTSOekLl4m98G4HhGAyP9yc59TNRIZQz6qH5t0ojjJimUrh58NqO+VEaWGVH7p/3XQmuukJZDK1OxGwFWAEnwQYlO6mMKS8+peJ9MY655fvEqG5uLMCZJm+Ch3Pqgk/js8Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784360443; c=relaxed/simple;
	bh=8x97xjwLxespb4H+FhB+Dvs3hO8uXE8rUqn6BLua+Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ocEp3hjNYhf53Y1FAitpSAalpBB+nEuileKCUXcYewUqfix6tdUYGJLJqSWSTp9S+iJWFB4yvGVMgxEpr98j5R+CtF7hC7uCCmxHpVWv0GGMxGUwiyBWS0uwnmNufbSn2k5E7wxU5p0CuRIX++56GVsz9IkTdwy5Gji5X7Fxd8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c71awKc9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c71awKc9"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso96434515ad.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 00:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784360441; x=1784965241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uaPspb0vOFkRyG1Ra2k3lDnMsVMESB6T2yn/LNmYQss=;
        b=c71awKc9UE55h5yYxKh6zPSA9Hw9EJLCLHmhwjxE8GYSy9UjqQKN7oEPQUQrngQCNx
         TVFJ8cmFqWLIvcULKc1TbG/ypspNHaq+21bjqhTiQrEqPUWBt6xtJTc2jXNVgWeacPg2
         MiuGk5qQhbUWDIhjTSD76Bwrbr7D0opxHFganWtlFolKaBtv8/30Cr6mPt4YJDcALrt6
         Mgu1U4s/dJVA/pRysl6LhHAlxA1tGecLQjExPPBuVk0LkRm2Tjf+NKpCkJEBLy7iEhmu
         Lf2+aCXM6ve72xfR9hh0RxeeKvVH+rIxStbDKM2TwAHLpzZli+n0T6uHODmSWWR9yXI3
         wDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784360441; x=1784965241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uaPspb0vOFkRyG1Ra2k3lDnMsVMESB6T2yn/LNmYQss=;
        b=hVPuOAFFwC9Xd9RowMWFvIR8WazoCKe0DPft7R74ekObQh7xWjNyqBJrD6Gol5co8I
         1p85754ILn+3KF2X0NzoD3xgUe0WfrnzRWPSIufSiNrAgSVxKyCEURWEaoBQYYdUmc45
         k/SU7M0ItAxyHWd0yOn/+Yk6ugKaD3Z7isc4IkNVY3LCasxIGGZjzBInHUgi9Yo5NSng
         ujI6Am9ttCbbc63iLLc2PHR62ezQfwU55xNozeWEWd242FWj3qwUBbAm9upf+0SxX8nS
         xoGVmvxvGmmEHz0ytUbNLu9SnJ7Vnq9tBmR4hxvmWehLj/MQtjFRXo97V8R65Ce+2sO7
         3V5g==
X-Forwarded-Encrypted: i=1; AHgh+RpAjfgaunImrHr8Fr8JdN2aeCVloKfNDM9lB9oNWo+SgoWP+7Nb+lKhv1mJYl2Z7K+tv0emAwQHJoqj8wD/rg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8K/yxWEPMLDRM2/+k8F7wr/WHeO+l0/1/WykQ1oiS468XdD7M
	2KRgz5EWLVkZOL6WsWt3SHfrSDDxzNt3SxsSX+wuOM7knns8yQA7o1Q7
X-Gm-Gg: AfdE7cnXOQ6beQ4i7NMBzvXtXAEqQloIGVyHiJCt4HSmaddgqLkeYK2/75Yuh73/QTk
	UDDlZSeE1hy9II2GCmWVFv1ff/M1lHuIBlDFbb0GpJHQSHGnI9QMLAQDk1oJHRe5uIte8Gl8HwS
	GUmUvYb5L4uegRYThy7AnawNkf4lYaOgxt2tk6HoZ82kh27htzhF2lMQQdD+9hxQtSeMusYz6u2
	1NLaoUut/EPIYOuUrsaC1P2dWeMRKtH8U9uwe7JDfL3AIT/YsirsUOieOBZ37M727gjvImhY/00
	BahQU5W0JbZYHGvO/8xU67MdFHWcCC75fRgQ6S99YlbQPr51a1ybfcswYsf6Vta+3QUbTF7pHLd
	G3pLcmTzJ2N4qq3LWFK2kAG11FgI8zDKidGgihskNJTvlhawd2KpbyXEt9Iw5oLX6e7s=
X-Received: by 2002:a17:903:1210:b0:2c9:d298:6c06 with SMTP id d9443c01a7336-2cf34a0a6c0mr62046285ad.25.1784360441199;
        Sat, 18 Jul 2026 00:40:41 -0700 (PDT)
Received: from lgs.. ([152.32.188.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346da07csm23399685ad.52.2026.07.18.00.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 00:40:40 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	Ganesh Sesetti <gseset@codeaurora.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath12k@lists.infradead.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v3 0/2] wifi: ath11k/ath12k: release QMI handles on late init failures
Date: Sat, 18 Jul 2026 15:40:24 +0800
Message-ID: <20260718074026.3085688-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes QMI handle leaks in the late initialization failure
paths of ath11k and ath12k.

Both drivers initialize the QMI handle before allocating the QMI event
workqueue and registering the service lookup. If either of these later
steps fails, the initialized QMI handle is not released.

Patch 1 fixes the leak in ath11k.

Patch 2 fixes the leak in ath12k and sets ab->qmi.ab only after QMI
service initialization completes successfully.

v3:
  - Split the ath11k and ath12k changes into separate patches, as
    requested by Jeff Johnson.

v2:
  - Set ath12k ab->qmi.ab only after QMI service initialization succeeds,
    as suggested by Baochen Qiang.
  - Fix the same late initialization QMI handle leak in ath11k, as
    suggested by Vasanthakumar Thiagarajan.
  - Drop the Reviewed-by tag due to the code changes.

Guangshuo Li (2):
  wifi: ath11k: release QMI handle on late init failures
  wifi: ath12k: release QMI handle on late init failures

 drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
 drivers/net/wireless/ath/ath12k/qmi.c | 13 ++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.43.0

