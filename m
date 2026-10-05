Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD963365A19
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 07:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791184935; cv=none; b=qTUBAkuHsvIH3eLO+Z2Xq0wU/ktTu18ws42RHAMpmgKaFL4Nx6dLMMMUWqKmpPqd/P0ypclHjAUdJ9o1TNR38CpbqsdomgMO72lQc+S6rAAGs1mgx+8vMgD2M8ajeEmr2QYC7ZKYxQZWgP9Gu9b2KE22M4MS82eA72GKt3DzqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791184935; c=relaxed/simple;
	bh=f9Ae0kSRR7PYMUThkHWYZ9GNyvCCn05bttXurW6/pwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IXy3SPzd2I0SBFcVjK3TfJyJNjnM5qgstjeB79ucnZQbj7XIsOA52un6WigZ1zCOx2HiFf8I7Fh4qu0eJXmbgfs/UsJ7tWG76OFtczw6EMp5kcer/gBUVld4/S8dH/CJGslf1gqe+PYQxv2l9hscU2L9LmLUKBsbnOvgPet4fw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLJV6CYZ; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLJV6CYZ"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c4f4daso1123144f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 00:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791184931; x=1791789731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dZj6Eci+NMqKG860mEExd65tievRgf9ZIO6Ixjz+rTA=;
        b=FLJV6CYZKp3VG0OP6ULg45G1gFjXY8ouneEFa2DkQ4Nk7YcYnffR/8oZqlAMqmzx0T
         m1WLNvmZZtxLlFgLj2Fo3PQVYK++mIAEVzGniLaBJkyeB5BMKqKQEKSow0rfHU3U184d
         iz4xKQYuG6fD9PY0u1GVOdlLTP25D14fAKwfxHpEuzsVTN6JwUTAPZrfBmjONbo/vov8
         6bAD3HC4sfzXBP252gUlE6yAT0w6ZSePnlQMPqkh7404U4Ngccv3/4uVe88OcG/qN85l
         Fo00Zu9KMyIoQCMtneHHiJHwjauFFs2kUOt60QBOktWg3GUA6QJxC1bfVwSRvITSOZvd
         wRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791184931; x=1791789731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dZj6Eci+NMqKG860mEExd65tievRgf9ZIO6Ixjz+rTA=;
        b=P/NbdCZJUz4RtsG0KU5JeejWsy0BaxwZosOxgc1tBSYeQePM2PF5hd2u6zQYAQcshv
         NuaQLHW+kiDBEuWSEQgfhOrUYx9otCBCFcpdLX8SMIy2uIcrUorFQtkU9oRseAYx9P7Z
         EjlrzDRsSo7dCR2DLjqOi1IFc+XuyHrZBzEU2IW+VqXVCubzpBf/upFVxTi19IMdaj0T
         zMWsUV3Fl7c72DPodJ1OjvjLJj8Cb9ZnYDy1R5EOqtG0EP3yCESNTFSr4SzVk4tGe7RS
         j8zj3WqKRiXwaFdwIEELxek/W1Jkt9RrgaO6WNSU4qQOSnkmV7/RdY9hZZWWiw5LO+EV
         dhdw==
X-Forwarded-Encrypted: i=1; AKwUvBzhFzgTYrakhpRlCe1xiVAP3wkQE6XTBFL1kRoFN6a80BxOqb6deM3Yyg80klYhetRk4bfsUSrCZrcgHBuShw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJlXq7tVOgRGugbEmP/I5BOztPE/aBYWTSQGhl4TlkPU3Y+dcIv
	2XkljlunPBl/cBNsNktSZBVkz16bVu8XPmYyZy4R9NMlzPP95vtj1Rdc
X-Gm-Gg: AYBFou0GDYhgnMmepDmddndB1iaYUyI/6a8+XqxA/f7tD/CWazjXMJ4gxlLTnLo0Zva
	R8Xtk7b8SaYPQdTD1z/ad4JgKc7bXKvLqaZk6bTyAFKm2euBZO/afK2SgS0dUgxSIMOSBkNLb3W
	mQfhDiKWxpfhWvCITOOuuTgZJElUIqALbOfFPy6ovLdVNghxwn6B2igcy50z1dkITA2tsrW6knk
	MORcIz5N4sUthQOwfkNX94M4VZqhR+wC00kIpDgygd+y6d4QV0J05yJyWuMCPsfUqq9fo8kd9+c
	JYBZtuoF2K3ywhsmkBKeMmekyWDUbLNp+Lh5Wsf8VAZCOzMpIZ0m0VRUx2LN5ZoHsaO/VNLq+kt
	svSWMu8aauFWLOa6Jqk/Bl/6YOHQ8dB7UP49gYYwXjrl9ZVaJQCuEe2RdCXcKTq/ALmPLZQVsw0
	RO2XtCTUOItSXRr5BLNv+bxKCx68M98S02z4UDrjEqaTQcGrp08ekvG3jPbA59IBUBkGu5+jJKm
	HOM
X-Received: by 2002:a05:6000:25e5:b0:488:6bcb:ec92 with SMTP id ffacd0b85a97d-48b1271cc86mr16432633f8f.17.1791184931267;
        Mon, 05 Oct 2026 00:22:11 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622affadsm1642847f8f.40.2026.10.05.00.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 00:22:10 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH ath-current 0/2] wifi: ath9k_htc: start ANI for an AP interface at the right time
Date: Mon,  5 Oct 2026 09:22:07 +0200
Message-ID: <20261005072209.4101009-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

ath9k_htc starts ANI for an AP interface in add_interface, before a
channel and the calibration data exist. When the bring-up stalls
between add_interface and the first channel configuration, the first
ANI tick dereferences a NULL ah->caldata and the device does not
recover. Patch 1 removes that start. Patch 2 starts ANI once the
interface beacons, which is where ath9k_htc_vif_reconfig() already
re-arms it after a channel change; without it ANI and the periodic
calibration never ran during a normal AP start.

Tested with AR9271 on 6.18.48 and on a 6.12 product kernel: the oops
reproduces on every start with a 500 ms delay after add_interface and
is gone with the series; an hour as an AP, station mode, a channel
switch, hostapd disable/enable and a restart are clean.

Mehmet Fide (2):
  wifi: ath9k_htc: do not start ANI before the first channel is set
  wifi: ath9k_htc: start ANI when an AP interface begins to beacon

 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.55.0

