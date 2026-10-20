Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457436;
	b=2oGqbgFlbNDanJfXiC41H34YWn33VWAxGkS3/ltzzvwyoezKUBZddHh9jEfSbd6hIpKr
	 iy7Yad6nSXyW/s4zrIGyvfoe3PnMzHUbY44cGLWfyzztdt6XgREDpNBikPIpx6WO6mAJx
	 u93P3GC5YSRv0knyQTVhpWUmLm2nAFFVMmsHuPl8P3jC6FRFnHfbXGppc0Jvd9o8x60Pm
	 9G8c/9L6p4gKF3PD233XAU6VvRqW1r91wXWc1w5OxihuY5qyQsNzMJUFMzTb+EEu3eCkE
	 yqF47j0oRqzjvcIn2ME09yyURMLhPqHtV+S3AtT9ZdKfVzoVMGlVc2kPDwRigNXr/Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QBQ41uNUL7QeVuDF5bJBKPFqA1U4nX2UmaFaXr/UJ0I=;
	b=5f3qmpWWplQvsvdS7545/jndQFE6nbkpXd6YHoehwicqOJxzkE412h43lS+Dram7w7H1
	 /fD5c9Lks7U0ePVx8KOOQclrkjUUl+LGrDrkuXkjVOAG7cnwgVEjIPgjyTwCw4MxEib56
	 njxDcDaC6wBZDwEgEp693HIx8s+77YPF3zzRYMkh1HTbMxYuAE1H9NcxiWuGdgozlDezF
	 dj4/Daas6vm6x8vP/jhUOHj4FHJpuBriEe4/ctp1l6MxNpGPLOlHDuRN8vdM2l4o7lBH/
	 Ir1tWjvGtZTBBQdP6gzREt3AwPPpse6upUeVvaAGt58WvMdLdeIp9dGVZEtTP5FHuHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=xaOBRBmd;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75C606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E75C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=xaOBRBmd
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso793546a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792457435; x=1793062235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QBQ41uNUL7QeVuDF5bJBKPFqA1U4nX2UmaFaXr/UJ0I=;
        b=xaOBRBmdO+wJXqajcFST5GfWQLqomKnTphjim9GO9GQF4Ks/EKrhhqh7An2Yq0/RQz
         FtS4nXllTReUyPF/UC1+pmHJHMGbmeYDP8blzfke0wSKsRVXo2Q1ARq7RNS/hmYho3eo
         HyzFYdz4zxVtjbeTKWidx/X9DQOgBvkWHxSUNiMNveo6MCPR9cbdkScWGgZ/nXriLxaG
         HM8PaaRGLYQ9Bip/TAruc7dy6KSJeJiZivUV5dXhOqzcrCuw2TkPFpCgFlEcg2DxErHD
         Kq5tfRrDGsZWdMujRtJCm1Ro39gT07sSMfmBYrsKM9rbydoVAO9aRzqBy1SXb3thK8TC
         g6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792457435; x=1793062235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBQ41uNUL7QeVuDF5bJBKPFqA1U4nX2UmaFaXr/UJ0I=;
        b=QKpDbH7vRlZ6Xb10fI9aVpMT50vOOFNgqWDmeWhkM47wI2H2yMMlOFwKwN0/BFs5vO
         TRWllHiOZcjXLt+lkV95t4zeHJ1Fv0yGjWoiCn0F6KKN/VgpCYhI7psq9NjBJAC+UZvi
         8Kf9JQyPQHt7XOfSPCe7RC0e9OQy2ovGvCg/R9EfWmOjRn1TEYqtnCOMmdEZ3HxDseV8
         QCMoa8bTMOqgWsT6I0tXF6l4UOSx25AVIdI9VhMtKYjjkRZf0uPts1PQGRd2qCxBmr6k
         ynzqCc04/n+poTRTTYbH0oGe32K3CS8XOR2VG2+L49i+3ac1QgWQR5rAIx8zFCe47/t5
         sipQ==
X-Forwarded-Encrypted: i=1; AKwUvBxvV7qStrxD2px8L4JT3NLAbUPuH34SD26OPXu9zUNds7M6oA9mppUubXVrCK7IVwv1NhvWlIkSlBzMPUJ81w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKM5TUGjQ6I4k93kR8gjYtu6HGN43uTg8rUVAll8Rlqnpa1wa7E
	pU1em5JxHKIVcwQptWme1WGkT1Op1VleNA5gozbmMgRDNzMm7VEHSOESzIXaP4yIMAo=
X-Gm-Gg: AYBFou1/3fw2l9tErf60uWzQWpJY4ZcQ4hJKfAmnY6igOyULkoO7JedkgncyVHudcRK
	kPrykpCpG/OQeXw9aiVY5eubzth+N2lKaRunec0A/g8AylZzCoerDgD1/qRcCohNOWk+kFki1oc
	D6amraiGvup6cYSY1Rcg3lZ511SX2kQgrh9ucL0Ob4yZH8DMQFwtv1xLF0Oy1g11Ow/W3Hqotyt
	1IZ4gr5STw1gKgBXkydaJ8FujIz884IChKJdn0qNw33YC7zIRINYPhjXqFrqBDKM5hNrgcRoRR0
	Ny0y7FFJOW2SQ4oQAoqy9rRb+Laco4JaRp7MCesevpuXToo3pYEcktUSxzciX4ngeLmdAFkTKNG
	h+yv/EJkVgKNio+uLv3kiJya2LqteGMwtKDsY5HYXcjbRmnw66ScWr5Ix5bQi3z+KqXIh71ysSn
	2ZBFSeJ9pKlwkDBtnLKXXJq14nBUqfj+hgV727rNJ4/EIqGYuQZ9/VfxStIl8UkSAmG2ec3Y/9k
	OJ/gQ==
X-Received: by 2002:a17:90a:dfc8:b0:3ad:6738:db14 with SMTP id 98e67ed59e1d1-3ad6738dc0amr599730a91.55.1792457435069;
        Mon, 19 Oct 2026 17:50:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3b16c2asm8520499a91.2.2026.10.19.17.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 17:50:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 0/3] wifi: nxpwifi: fix the 11AX_CFG response handler
Date: Tue, 20 Oct 2026 09:50:24 +0900
Message-ID: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH v3 0/3] wifi: nxpwifi: fix the 11AX_CFG response handler
  <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>

which should be dropped.  Apologies for the churn on v1 to v3; this one is
meant to be the last.

Three fixes in nxpwifi_ret_11ax_cfg() and, for patch 1, its two siblings.
The order matters.  On the base the extension ID is read one byte too far
in, so a correctly formatted capability TLV is never recognised and the
unguarded store patch 1 closes is never reached.  Patch 2 is what makes it
reachable, so patch 1 goes first.

The driver has not appeared in a released kernel, so no patch has a stable
tag.

Changes in v4
- patch 3 selects the destination buffer by band first and validates that
  one, instead of checking both unconditionally.
- the three commit messages are cut down to the issue, the path and the
  fix.

Still open, and not addressed here.  Patch 1 closes the window where the
response path reads curr_cmd->data_buf after nxpwifi_wait_queue_complete()
cleared it, but not the one where it read the field first and holds a
valid pointer in a local while the waiter returns and reuses the frame,
because nxpwifi_process_cmdresp() reads the field without
nxpwifi_cmd_lock and calls the handler outside it.  That is the lifetime
contract between a cancelled command and a late response rather than this
driver's 11ax code, mwifiex is in the same position, and I am not sending
a patch for it.

Testing.  I have no IW61x hardware.  A KUnit harness injects a fabricated
command response into nxpwifi_ret_11ax_cfg() on a KASAN kernel, 12 cases,
each in its own boot, with the TLVs in the wire format the send side of
this command produces; it says nothing about what the firmware emits.  The
base gives 6 ok and 6 not ok with 2 KASAN reports, the base plus patches 1
and 2 gives 6 ok and 6 not ok with 6 reports, and the full series gives 12
ok with none.

Yehyeong Lee (3):
  wifi: nxpwifi: guard the 11ax response handlers against a detached
    command buffer
  wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
  wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response

 drivers/net/wireless/nxp/nxpwifi/11ax.c | 67 ++++++++++++++++++-------
 1 file changed, 48 insertions(+), 19 deletions(-)


base-commit: 3d229ce89862b8e82d71a9e11d6f840ca272a6d6
-- 
2.43.0

