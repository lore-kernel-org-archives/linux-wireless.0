Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332F02D738F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792119784; cv=none; b=l6KHhB5sJD9V9tnEnYA4jT4VqiTIeMOW2M/7/ggmQ/qFR4yfIMwW4IXexUxLtwsGjl2xGq0RSPgHdzS8z4Z2W9QsA7lFNvod411CUuOhGOae7kUcY1/fzYTc+M3hfjEh/cji7qoFve6Gcga0fLhyx3kcMoOhSiI3/sT8uSaxcXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792119784; c=relaxed/simple;
	bh=W/RnQwvCdJ0Ti8zFdI96RAOugrp6e59Hi8hIUNrvbcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKI+C3YMxpD+YjJko6AEKYPSN4Mwx3A+XOAK6mpERXKCLhjDDIKJCb4gHw9ZHUANmyov0DuMEnMBT4Qx2BkAxe2dpXTbFaIYktsZuKZeAuqdm0zMSZpXx2wg6JL5PoQPwW8gywh7tgtLVSYqdLn8yId08xnctvQeoquKqyQlnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=WM8jmAER; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="WM8jmAER"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-89e018e466eso994339b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792119780; x=1792724580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SphrYcHvxe/mXZHDKOmLcceivgr1r5c7dA7xi5/TFCY=;
        b=WM8jmAERD4REVm/RvcS/5DX8QJh0V2G+H/62z23i1R0+Szu0aa9wbFigK7OVNm4Nbl
         QDv3vSWtwMUkSIBUXvzgv4dvmqDLhlTTQ7bFyKUewY5AdQeUwWKqY5/1qoJZQv0jGuEH
         9SA9dg9/eiUyuhNA4N2P7XnTVytcz+QeC6eMwksLszBnUOsZlxCMW/rMdeQksJgJnI8S
         R72kL5eDNp7wb2EHXbv+enffTZP4uIZ+J6mJyWrpSNTHeqMIJ8CBlSO3d9EsqFjtRxes
         FySLFYaAKaNO1h3dWNpE0DpOL3Yz/VJabN7HvPBmPXfpkmHpr92ZtbCMlCuBGitjYYg1
         o5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119780; x=1792724580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SphrYcHvxe/mXZHDKOmLcceivgr1r5c7dA7xi5/TFCY=;
        b=rO/x1+WAxKADasXVHjGyCnFbdrrXa6V8jocTPpedYHiB5lJ3zexd6eCQn1aRqwLLhA
         liG4puibdT5tPs3yEzGAT6ObAPJGVq1KRjS+KQoYDm9VoVKyCsq1g/HEyW4JHFEED8Nk
         XEeWb8J7hBgUa00JaxRz5TOUhdG7MZ0giACVYEhdTU8mTTZKYAt3Zgw/+NjW/x3NtqrA
         38szeEpeAse3p8840lItJ8/ORbuLpiFA3X9rID41UwSi6SG3GXlL5w4PvepJk6mmLHtF
         OkKoBANFMP9hYJtMlVnnb4hfC7MA4ViafavcjXb6g4+h9F9TWpLJVC9qBLXuTgHPOrjM
         AYag==
X-Gm-Message-State: AFq9FYIHlUBaDgjUn+8TLI4TjZfJMM+NYxDPMpXnatmYpzyeIp6loeu7
	DbQfaEoTCJm3A2nrGn7QeVlJ7CILkYcT81SOfjiAeqgF1eIWWJjH+MORU6Z0MJfrgs8=
X-Gm-Gg: AYBFou1/4YUJCzfgMqGxxLziwv8lA8ohAqoHQRIS5A/nGCpNOcUq7eIVhSW3qlkKNuu
	K0Uqho8mpF7qPZRW7t/n1K2OyGt/vSN0hla0Wj2ybSLynAdxU21dqCLY09bAK/K1wA1VGBhyEFO
	2sFfp3fwZipnNBx5iHSs4yx11n8iH01+0LtIY8PJVMhOt9PlspPXuwaK+zCNAj7w+HoVknhRmDw
	/BzHChJCrNTYYsgO3cOpkHfLg4ASxhz/AjwLTgBczBvtdPKKjnPNsbKE3lLxb6VwY0BTSb23SG1
	ryKASgKtg+CXVM1GRruSe6cEJaTNn9SwGNn9QZx4FGsjnKEEdSA510FvDUw/p+hvszf+H2o8CfU
	p272Udqydqdx4T7vb8oWdLoBf/zQfMz8qrrJhB6LQs95GqQUG7iWHYfeYRL0rX83MoU28NIYd4u
	V9oS9d8yYcNj5SHghuIVH4DfFfcZqWpehOsKaHhFJoH80JYOBF9WaCbeH3dUBp5ktmar/2XGhAi
	mc++Hpo5le10dCq
X-Received: by 2002:a05:6a00:8019:b0:886:84c7:72b3 with SMTP id d2e1a72fcca58-897c78d79d0mr17473704b3a.26.1792119780244;
        Thu, 15 Oct 2026 20:03:00 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c8c490sm422493b3a.10.2026.10.15.20.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:02:59 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 0/2] wifi: nxpwifi: bound the 11AX_CFG response handler
Date: Fri, 16 Oct 2026 12:02:48 +0900
Message-ID: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
  <20261016014927.434473-1-yhlee@isslab.korea.ac.kr>

which should be dropped.  That patch is patch 2 here, unchanged.

Review of it pointed out that the handler also dereferences the command
buffer without checking it, which is a separate problem in the same
function, so v2 is two patches.

 1  nxpwifi_wait_queue_complete() detaches data_buf when a synchronous
    command is interrupted, because the caller may be about to release a
    stack-allocated buffer.  nxpwifi_process_cmdresp() hands the field to
    the response handler as it finds it, and this handler stores through
    it without looking, so a late response oopses.  Check it, the way the
    other response handlers here already do.
 2  the TLV walk takes its length from the response and bounds neither
    the walk nor the two copies, so a short response wraps the u16 length
    and an oversized header->len runs past both destinations.

The driver has not appeared in a released kernel, so neither patch has a
stable tag.

I have no IW61x hardware.  Patch 2 was exercised by injecting the lengths
through a KUnit harness on a KASAN kernel, which reaches past both
destinations without the patch and nothing with it, and still accepts a
TLV that fills them exactly.  Patch 1 is from the code: the detach, the
pass-through and the store are all in the tree, and the KUnit case for it
only confirms that the guard returns -EINVAL, since the unguarded store
takes the test kernel down.  Neither patch claims a reachable
out-of-bounds; the firmware's behaviour is not something the tree
answers.

v1 -> v2:
- new patch 1: reject a NULL command buffer before using it.
- patch 2 is v1 with no change, rebased onto patch 1.

Yehyeong Lee (2):
  wifi: nxpwifi: reject a NULL command buffer in the 11AX_CFG response
    handler
  wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response

 drivers/net/wireless/nxp/nxpwifi/11ax.c | 26 ++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)


base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0

