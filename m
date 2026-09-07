Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFD38F636
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 06:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761664; cv=none; b=kGH7kiC9o59yPG/GacGMzG52Xzz3YSixwKAPObbqBxm6fwTTjZa7Z17vmVvarV3oAj0oawW94Kt70KBohJDufDJ5D3mCRX2lnubvDd+eH05c8/+tqzX6nET2LaoJ8Y2vtzRs6pwOCxfvk42KKU7qXVmEfDD3iQ7wtlvfwb8SLBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761664; c=relaxed/simple;
	bh=sOd2VLBO7SnuNRsA3ZiaaNKPFxM9yphhqsyMTulLcH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GmQjhCQKeAtUXMpTuxvq0Nx5DpEwoMHsSC0aiXEXiscSJ3tZ9whU27/03FLUQcU3tTFZfCJS5X3THZiQCzwy4so6j7c8mPVUW+BkV6sNgs3XIVOB+JOa/aNKV94c8JY28xEJdhNlD0jn76KvifW816CZDWHlrkro521nbQ8tVw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sF3Dudic; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sF3Dudic"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1b838f9b6so3447931a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 23:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788761662; x=1789366462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cToOiSNt/mpzlRPqbeCUKa9ofVZrQ/7IjRG4NV0V63U=;
        b=sF3Dudic2ZhBrpu+6yPMx9drdUK5n9hDr7Lm1dUEp6J3+Gsdr27Te2Bo9s+RyRQdL9
         lcsjE/0bOPfzyEM0mYrK1mpccNcovIDZxvKWSBrB0tcP0h10t+6CMAsQTcwjsgVLVoC+
         Az4E9XAsc5PnKX2NZuPTNROBbnT2PdHc9mBqo/T3nEWFur14QR4RnwTcGIrwQ2JqpHEc
         xmVFHNmbGY40vzeMDsQQNbidt7XvQ995jChMziORTRz0CqpwPDDKcGx2oVLtaJKB9d05
         YH4Wiie1inWihIbSa4dYRajLR5gYgdFMlmEKaRNBjJwLoGsopMolOSJYOzZdx7IEq5Qg
         h+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788761662; x=1789366462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cToOiSNt/mpzlRPqbeCUKa9ofVZrQ/7IjRG4NV0V63U=;
        b=OpsQVqtJD623smdrEr1/buMyw/1P9ljWwslRFBJnSfuGejOD1doxULjo1bXDz247hh
         P1v9vD+bbWd5W3DdajsR1ck2FsLBRyQXzNwKG2Pm3i1ywIGdZDaAOo7R0eHrLfkOZWPp
         cBb1uO3MOAkUFkz4LCcCT2TgXT9fBlREmistSsc+WgWqWHymGxits/Pw0FnFrxPyTkeZ
         UQ2ei8MvRU+A2cx1iNN256YMK2TmJz/VY/gOTMPRyVYEkGBcQuV7KF+fWBzmoHVq+SHk
         jG+JX2jLzgyty+rV7/aSY2TEQP8+lTKIApJJktIv60TEOdPKIobuj7HlZllIlT5aJOz2
         di3g==
X-Gm-Message-State: AFuF++nPnA2EzPG6R+zRAaaGIdlrSXeG8MbdsXI+TTjmi2MStg6O5W5K
	JrxR/12mlKd+ZYLuP5G4Qq5FFKns/sQFwFoQ8wVJ1SIxI5J4HEoXsTs2
X-Gm-Gg: AYBFou0BP82PmOyrkDnf+F/IGjdEoAFN/REND/to3i8QoX+fAKsjUHZic04vB54gxDD
	qAWbXVYywPRfO9uP8agknYWEenFUdPiqAeClVzKVw1gWQWoEwSgOLSiZ9OXzGoLfrOpE+eTUt5e
	givi9TaHGXbPRc8OAbNwFSzPeQ54+NhSDEeuYT0umYG/qo4SBW91hQ1EoWhn0+ghzGAQjl0E2nm
	DiHNjsmKUelr5fy8EsP4nw6k/RJR3BX+b01lqic6kN9InHucl7ZjhI358mB9LfMPUSDVBV/HDwR
	/vonbdJVk1lfGekxKR3Oc+ppI95HT39vlgmrI9camRDl1i56+7gvSUW8GRqk+rnkzj3bRcBmmwC
	sCxPY3A0hZqHh5ETiYUwU2qahHkcBgCsVwLt5d6+aq19l4Q+PSTh1cCD9viYJC/q+3O2r3Vp5oF
	NzvxllJyrDZeOIyl8NR7HQsJIN/O0me7TwboQk/SWBCsB77DEblkY+j4fglFqVjLqHbJ965jMW3
	CmsV5MI1jYKTQ==
X-Received: by 2002:a05:6a20:9f86:b0:3d0:cc29:ff64 with SMTP id adf61e73a8af0-3da39ff00c1mr34472283637.15.1788761662040;
        Sun, 06 Sep 2026 23:14:22 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14340a69666sm4651595c88.9.2026.09.06.23.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:14:21 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: fix typos and repeated words in comments
Date: Mon,  7 Sep 2026 11:44:15 +0530
Message-ID: <20260907061417.33729-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This corrects 2 misspellings and repeated words in comments.  Each is a
separate patch so that any one of them can be dropped without touching
the rest.

Nothing outside comments changes.  Every touched C file was checked by
dropping its comments, replacing each string literal with a placeholder
and collapsing whitespace; what remained was identical before and after,
so the compiled code cannot differ.

The mistakes were found with scripts/checkpatch.pl against the list in
scripts/spelling.txt.  The scanning, the edits and the changelogs were
produced with Cursor running the claude-opus-5 model, from a request to
find and fix spelling mistakes across the tree, and every correction was
then re-checked by the comparison described above.  Words that name an
identifier were left alone deliberately, even when they read as typos,
because correcting the prose would make the comment disagree with the
code it describes.

Tested by building x86_64 defconfig at v7.3-rc1-269-gbc35965f6940, which
is clean.  Nothing else was built, so any patch touching code that
x86_64 defconfig does not compile has been read but not compiled.

Hemanth Selam (2):
  net: mac80211: fix typos in comments
  net: fix repeated word 'used' in comment

 include/net/mac80211.h                 | 2 +-
 include/uapi/linux/nl80211-vnd-intel.h | 2 +-
 include/uapi/linux/wireless.h          | 6 +++---
 net/mac80211/cfg.c                     | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.48.1

