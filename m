Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B751B443E24
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514014; cv=none; b=Vs5f369oK3GwumJhYayvW+WsrBxbZJeT/NUVyVaoGBjNglwzODON0huUMgwtJ434MlkyD9v5X056tPuIk1UacONulisiQzOd+4dQA8CgZM4WpkOCGSKZEVwepADEH/PoxE5vb40+aIBSBjr8PH90wKXxKD/7efN2LUpZ+m738c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514014; c=relaxed/simple;
	bh=/N8ljrUbwx9dQ+KpsMf15ufKltiMDwixZdIQ7x2jW64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZrdByAGkfIXP8RB2anPsyZ0plfksEmCt8o6fjoj74OI/mHopiUK3VhO+YH25lOvsBDPj/Aha+IV5XhE/1oq2TkmipeKpS0/yS3OpGgjh01Cg6P1eCH0b6Ne6twg99r+K0joZJntF9A9n5b+AhKpDIYhClh8g+kp/xTRqW8NOzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nufx7XQC; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nufx7XQC"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cffd93cdedso992645ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514012; x=1786118812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9C9LjO0hSvCIo11gUDBsB2QDOOiAgSqeU46qfcd4pH0=;
        b=nufx7XQC9DItvcJ0+uVumWS1RTAU7i7MSzQP/QsFseCSK2KrnVD+tN5FmIXE5F8XqT
         lhi+S+Rh9Z+rSh/3VSnNyKHOXwx4N8BU1XyJNC+lFk93k20keUjl1Qx6Q4X6mIbbsrCw
         PYog2p44OriDeqh4MrJfGHBc1+8WVofYt7Yony46UEg4Co9zGohbTRLNM64RgrlScq/f
         S/mSPHYC6ztbiQHo7J1dAKQLoQtJnyxkr6eQAS+fuz7O/K27qe/9+HxYIs5FUacNtSDX
         1PnMUfL5GSnhHhebPmpSEB6eacn6qkidD9d/FNAN238Q5T+OM6ngppTsiYuf1F2X4o6k
         l9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514012; x=1786118812;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9C9LjO0hSvCIo11gUDBsB2QDOOiAgSqeU46qfcd4pH0=;
        b=XrG8HSqBCVLW7raJGQORmZjwsgp5hEzEEFzCnBgv/vNzaDQgu5KWH3GHOIllqCD+aV
         EUKEmTTk+ZkLFDji3wEp/UhmAJzMAHhH4ThKOPjHquFGFFSEf0LnzO1/WfaputhRMWT4
         1/SMj2HSAw3tIZs3CHpy1LxuyHaxvjgvdAGIoVkGyC9lqaMiXLpOdrSz5MyRVkP/Gfsu
         sBESJldlxgtrBQWiwjOvHF2hiIv5qWcZGvXvFs3/ZirnE5vy54LMENpvLrRCm6gw5yxd
         PCjLCnD4ckAVjHUWkQw1b9HA6+c2fKoq1n6Ph9gBLuTGHdOI2Jp/JhOKwP/neW7wm/FE
         veew==
X-Gm-Message-State: AOJu0YzyLLzz57lYH0v8eL9kZ1Z/DJWfotqu9qqfmqqFUz35edmV6eYn
	L0CusGCkygvuWWHPi81cr95BZVZykvkupDxYFoDe7og0zLg9RYXCNqcv
X-Gm-Gg: AR+sD11gA1gM7SE25VPDOymZDIoI+WznpjKSdsEqmqUocdZfKTyFbn2QSAoJlId62ce
	sGeSv1yBHK+2RUExNDjqCmqAfQ3NibQrcJz82X84mBLORpdGO2SZAuucPoKhfR1mSLEYU5jv6Rn
	zk8J/+7Bf/4ys20ie2MB8CVWxTkprpde26WomledqGUEd4Mrr8cL5dDXnVf5yUsv4SKlQ8gc7Fi
	fp9PGWotO7ynqMZIAWkcy7gojJQyy/ToO1iFiRfdY5CO3IX0Hog6XUul0NSauTR3lw/muu3Oad1
	gEW9iaDNPGQY2EtHbLRA6Yu5xeddcFt8yNkTLwclZmap8BoUmZ4dmIEVeCZ0cuf60veTK+BT/OD
	UApnE200lh7rGJTTohEG+IcUOdp6cFkawYS0Pee2b4XuLAN9WZHeE1GQb6RSgJoTlB7Vz7aM8vp
	KoRkxCp5lP1aPsfxiBUwjLb+3my41WJNdk9620ii+MhXSHofXd/7z+93Y9RYgt5m7tqZlExve1v
	sOdIwR9
X-Received: by 2002:a17:903:46cf:b0:2ca:ecf6:9115 with SMTP id d9443c01a7336-2d0523bcf3amr7876085ad.2.1785514011865;
        Fri, 31 Jul 2026 09:06:51 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:06:51 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 0/8] wifi: brcm80211: performance and stability fixes
Date: Fri, 31 Jul 2026 16:06:17 +0000
Message-ID: <20260731160646.3812-1-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series fixes several performance bottlenecks and correctness
issues in both brcmfmac (PCIe/SDIO) and brcmsmac drivers.

Changes since v3:
 - cfg80211.c: Removed spurious double blank line flagged by
   checkpatch --strict.
 - All commit messages rewritten to follow kernel standards:
   explain the problem symptom first, then the solution, add
   Fixes: tags where applicable, wrap lines at 72 chars.
 - pcie.c: Added Fixes: tag referencing the original PCIe commit.

Changes since v2:
 - core.c: Add skb_cow_head() before skb_push() to prevent a
   kernel panic when skb arrives with zero headroom.
 - cfg80211.c: Fix PMKID V2 shadow counter corruption bug.

Changes since v1:
 - Correct author and Signed-off-by to chanelshivesh@gmail.com.

Patch overview:
 1/8 flowring: Replace O(N) blocked-ring scan with atomic counter.
 2/8 sdio: Coalesce N+1 sdio_claim_host() pairs in rxglom path.
 3/8 core: Fix skb_push() panic; populate radiotap RSSI field.
 4/8 cfg80211: Implement PMKID_V2; fix shadow counter overwrite;
     replace mdelay() with usleep_range().
 5/8 msgbuf: Fix silent TX stall; increase NR_TX_PKTIDS to 4096.
 6/8 pcie: Replace msleep() with usleep_range() + backoff.
 7/8 fwsignal: Document safe no-op for duplicate MAC handle ADD.
 8/8 brcmsmac/ampdu: Reference IEEE 802.11n TID requirement.

Shivesh (8):
  wifi: brcmfmac: flowring: replace O(N) blocked-ring scan with atomic
    counter
  wifi: brcmfmac: sdio: coalesce sdio_claim_host calls in rxglom path
  wifi: brcmfmac: core: fix missing headroom check and populate radiotap
    RSSI
  wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix brcmf_delay
    busy-wait
  wifi: brcmfmac: msgbuf: fix TX stall and tune buffer/threshold
    constants
  wifi: brcmfmac: pcie: replace msleep polling with usleep_range and
    backoff
  wifi: brcmfmac: fwsignal: document safe no-op for duplicate MAC handle
    ADD
  wifi: brcmsmac: ampdu: document IEEE 802.11n TID requirement

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 122 ++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   4 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |  44 ++++---
 .../broadcom/brcm80211/brcmfmac/flowring.c    |  65 +++++++---
 .../broadcom/brcm80211/brcmfmac/flowring.h    |  18 +++
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      |  69 ++++++++--
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  66 ++++++++--
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  62 +++++----
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |  11 +-
 10 files changed, 374 insertions(+), 91 deletions(-)


base-commit: 5e0bcb4920bcb9e0ef6c03a91730fe45f643f3a4
-- 
2.53.0

