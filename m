Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9EC2DE70D
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809794; cv=none; b=AztH974HCLV2nrJRoM02w3U/Q6YNmEmrybgFndV6qSYlXZQsV7K+G9qWB26I6gXZHBcBt2FS6EP6+fHAIqJyiX/T8BrePcfje1nEO+bTNP30GqQwna5W5uUK22Gl87Vwiv5dF7Qi1cayTyVBIzbDiDotIOz9nwKGi9KoBXQxJGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809794; c=relaxed/simple;
	bh=mjSz8gx4im4cS0b83+ozp/B4hjEMHlk6tiLilLEdudA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sdHtaHpoHFNqeRFA6njulhQNVlT8mVGjLxDDkcZ1yisxBxIS56Iayn5UE18IX1qB7lsmbyNbBVKUxzOMYMEmzP/JnZbIXeZhngS1UKh2hFYawy61RTHn5CCD25bE+bGLtR6tytdVtGwFIq8N3XhaV38hey9ok86QnZtJrpE8sBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=MMAcqzvW; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="MMAcqzvW"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1b838f9b6so1543430a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809793; x=1788414593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hPgl3K3du+RX3sZSizf0GpF+Jtsd8aF//r6aIr41Qt4=;
        b=MMAcqzvWbU050dbUHZRjeyYHLV/0voXR7dl8jai6hdldTuHYnhr0diMbAiVA7mBn+E
         3azfxBKVhc1wBbj09gf1gfJU1IhRNOmWLg9rLPGTVYsIO/9RvBSedDrus6cgCW6oJfpc
         AC4aRl1gSp0WwcFs923Vvjnm+ZCLLTgXIlUPGLGJ/pXzFmtk1XYzaS7tTnWcK1AEdRut
         vvjIUfHOAcnoaB+JHwT/Vj78H8WyiGlLy6XQ+Jn3dLoJwU1tdWuQt04U4BvBLwtJSxKR
         cdWKGyIQ6Q1lWdClZXngXWW3gXKmVH6bBot8K6fz65herr90mbXh/pOhBXqyttMdw4Jb
         fdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809793; x=1788414593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hPgl3K3du+RX3sZSizf0GpF+Jtsd8aF//r6aIr41Qt4=;
        b=swm3JjpVDnHwAbnhJ7L8yYtVGqofwstNg1UtRRdPjsxLRIqUcr2C+FRfsyWjZPbVcQ
         PVVlKuatyYwq7TROH+cJCZ0WV2Bc2j0B5WlfmkBMrNckY5lzi/ly+8mUxfcEdNdwGJPi
         F0QP6OGlMW8ioj+yg9pxL7gy45kvtx2v48N68w4giYcMY9TmAj0zm2u8GcaJ9X69XLf6
         itbw60uNXvKfSztAV9huayDy5M9Es/P2mJ+yKEVOLcCmJGL0iRCy8OVADm5n5RSDKAkN
         0TcagtdAz5suRY9obWRfgWMQr+ZpiwDpOtXRqWerxA+YQYK4ABoBfpHn1oB+q3cMV+AK
         Infw==
X-Gm-Message-State: AFuF++kLzsoloyiGNthu/Pnn97yFsDfttzSyhpGhJqYTZ4lYHXlmdP24
	NnOQr++Nx9fsx0GRmQDAZt00aMqvlBISoYyAXukFiucU+L5/Yztewr9sPbVTc3e3FSM=
X-Gm-Gg: AR+sD1342VxXRWw2bpN01Lu3vqmOjVjHS5w1Ufc2mAXtqngnA6Ub1OhWqQFMTl2vJp4
	hwnb0sIuVPNaOuc2MVUu6kcLXA93WzWaxnkkj3c0gxB2svpLB14gXrSGNpgtNDt3rQptdPU9B6e
	egvDT36oa0n5CMJ0ob1SL9VevDrTSFm0n3dcagTYlgjUkxpneqqZGfy3scTwceYxNRa+tUv3tl6
	llMSUi2amlqWYxIdW82LWnsl57x7nZfAXPzeZgJP3oKi8jiGt3WUQIrw/2m3mltG3mFqRKZ0xVN
	Fz3KMCCKc4Csh77aXE543QDIWw7VxsE5YLpyEqDzRsxR32Vo+ECtCDnyeEutuZK0S05TxvwMkU3
	pI9zFhia2pT7A9mtuLfU1Oy1OmFDmWDAsysAdv2QLq+opt2GQqHpTHam9rr3MQIDA0RtGKcPfI1
	hbyOhX/GWiNQoRGleSmDpp6/Hxln+85gdRGgh9Eexjw4BIZLWcsHszLI6WksgIsiKLYoxibgoM9
	VVY3auAJwUHnTRTnfyTj3LJbXSriDWjGggiLdSU/9jbbiF72z8+BpfrlbnzyPPiKu5X1Z/sj3uB
X-Received: by 2002:a05:6a20:6a09:b0:3cb:8810:631d with SMTP id adf61e73a8af0-3cf7596814emr22449440637.1.1787809792763;
        Wed, 26 Aug 2026 22:49:52 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:49:52 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 0/8] wifi: mm81x: mcast and tx bw improvements
Date: Thu, 27 Aug 2026 15:49:09 +1000
Message-ID: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some improvements to the multicast handling and tx bw selection.

lachlan

Lachlan Hodges (8):
  wifi: mm81x: move beacon work and init below the tx op
  wifi: mm81x: release buffered broadcast frames after DTIM
  wifi: mm81x: do not drop PS filtered frames in AP mode
  wifi: mm81x: implement .tx_frames_pending() mac op
  wifi: mm81x: factor out tx width selection
  wifi: mm81x: tx EAPOLs at primary width
  wifi: mm81x: clamp tx width to stas max supported width
  wifi: mm81x: tx multicast frames from AP at primary width

 drivers/net/wireless/morsemicro/mm81x/core.h |   7 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c  | 181 ++++++++++++-------
 drivers/net/wireless/morsemicro/mm81x/skbq.c |   7 +-
 3 files changed, 123 insertions(+), 72 deletions(-)

-- 
2.43.0

