Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DFE451986
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774836; cv=none; b=uStL7kHggblgc8vR99eLo/xdNc+cqL7vo/pnuqHHLYRD983DI+RJugNOqGhuvvzEAZ5KcsXxUJSNiwL/W8HiSKvV39bDjHJE+rPGRggYrROhECn62/EDx0eDNGp6ChyUvPIHds3Hs1DZ+6ftRUHJ+Bl3KGgjyMEW2fVncf3iiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774836; c=relaxed/simple;
	bh=+lpKN+7kk0XQLmKmDa/X+MHwJM4Lprdnc/6O/rW48J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmTxpbKVkBvKqaMVm+Jqkx9bmU0hvLcwRRAFCnfW76YCAgCP3KkSbkBHfJ/xZA27ufIdxGsC6ZHCih0SQvfRpmktLUwEHf9MmVQgqYMpt43ekfr75ndSrmPXR/VVf8X5eUASTpytER2Xp420JBP193ADvQVv1jCsCxObaXV8OZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdTC6VC9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdTC6VC9"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d9b60c652aso39665135ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774835; x=1789379635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MI9c5a62kcyuONjdN9EmIeefQ4BKelQM55jDPn+nu9Y=;
        b=ZdTC6VC9kRA/Mpp45BkojuatmfS/JbOLWCFVDNAs9zkmcpppENvmx4kUfH29y4XmcL
         2P5C5Gb8WmbcVFPRYpi9c8W0iUygJKz8ENEOHBpaDaNuxkMpytjenCytnIGZcsGbuRdC
         ulSf2aET36+K6GCBhJYx1KywuEmA1xiEYU7OQtElUM3c5vg/ozjzYkUdGuWB/6uviEj0
         oKKLOxtkrQYS4esa2IMZPG0zy4zOr3IrF/WhpTrNQlOblkcsxPpxLqSHYSWnFXQD1+UT
         kXulsMjjGtrRHZOR6hDnVNdpXjxSSltT7GM9fyBp8ynt3FphVAakggF1awvJ7nWNXpbf
         mGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774835; x=1789379635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MI9c5a62kcyuONjdN9EmIeefQ4BKelQM55jDPn+nu9Y=;
        b=GlsJk/liaSIwOudsIFQHQf4JZuM+7xybzCXbVzoGpo4hD/TPaV5hbStTrQlSzzPQyO
         vlxDMbaVqyX8HZAMTzMY5tlEMGuiQ1jhpVle5RPlcFJM7uAU6j5szO6+rcVf+5ajZxOR
         OAUsleZ0zQbCUA2hWFdOFO58GOFPnamSjVPXsrUZvnD8KdvseEMH93YnjJEEaNCxfRRD
         r8Qg4k0wpmeVF8GKn6L1eRYFRhx0a0GcVxfJdamZSBB1X57u3eCcUgZ8da8CDwQjIp0r
         5YkVAREDl7+afnJhAVSh0tYxOhmqWZT+B596gqPOnGM9mYrBUPHSAoFCr+Lmt2xf+xON
         TNIw==
X-Gm-Message-State: AFuF++mF2SgKmWnZ23Cv46cYofgyMLeEU4RX1WldhdcosscvtmtHYDsw
	N4IMaf7+rBbY9XizRzakhyhMvIHO25PmzMUB/2N/36Wbt2mtmzblwt6n
X-Gm-Gg: AYBFou3a5uh00CtRYdvrDRKxMmaPb3cvxQPa+2ycVeRP/7pqsLb/FUY7It3pAb0GNiw
	ctDkxYHsKqbdGkoXaeGNVP7M4vnlMsZSdqf/5y1UtlGTLFqh6JplUfB5wFWzYQ5KP5XWCocBGk9
	SCUW7hGGhBuScj0M0XNMdQMikTAKhceSP82Nqtk8lAxg0MruwokyN+Uub4jQCEKCUlbpB8mjAhx
	E+6ni32EU/fc7C5E3X0gbYEkn6LOxysOPYxidob3iKlOM9qqEi1pm2ZYAG2TiHqA/TZ7w7D/pHQ
	DYrNTcp2DDaR68pqzAemVHLzz9j8B2jTTScIBjPCrlNu+wG8SNTAmE00DGy0g9sQv5UI4/Hk6YO
	Hs3H6m4n7sUx1qD9ofd/CR/GkycChCWHKjflAFFlF9HMNxEly8FbJH2Yy9DfdnTEBQ5YlW5/M1V
	xY2u6MJmyOvs0bHZGT6toSFUDW9bfgcR5pnyypC9mbTnlLzxlbIgN4gxCS9Ic0piZGk8PltItdu
	lyURzFQw4wpjg==
X-Received: by 2002:a17:90b:3a8e:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39b260d2eb3mr33006922a91.7.1788774834673;
        Mon, 07 Sep 2026 02:53:54 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm30377066eec.21.2026.09.07.02.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:53:54 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 1/4] wifi: nl80211: vendor-cmd: intel: fix typo "firwmare" in comment
Date: Mon,  7 Sep 2026 15:23:45 +0530
Message-ID: <20260907095348.26094-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907095348.26094-1-hemanth.selam@gmail.com>
References: <20260907095348.26094-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in comments, found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt. Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---

Notes:
    v2: designate the patch to wireless-next and use a subject prefix naming
    the component, as maintainer-netdev.rst asks; v1 went out with a bare
    [PATCH] and a "net:" prefix. Rebased onto wireless-next, diff unchanged.
    
    v1: https://lore.kernel.org/all/20260907061417.33729-1-hemanth.selam@gmail.com/

 include/uapi/linux/nl80211-vnd-intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211-vnd-intel.h b/include/uapi/linux/nl80211-vnd-intel.h
index 79ccc9401d50..602862503c2a 100644
--- a/include/uapi/linux/nl80211-vnd-intel.h
+++ b/include/uapi/linux/nl80211-vnd-intel.h
@@ -37,7 +37,7 @@
  *	8) The CSME firmware grants ownership
  *	9) iwlmei tells iwlwifi to lift the RFKILL
  *	10) RFKILL OFF is reported to user space
- *	11) The host boots the device, loads the firwmare, and connects to a
+ *	11) The host boots the device, loads the firmware, and connects to a
  *	    specific BSSID without scanning including IP as fast as it can
  *	12) The host reports to the CSME firmware that there is a connection
  *	13) The TCP connection is preserved and the host has connectivity
