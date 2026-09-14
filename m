Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F913477E58
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397708; cv=none; b=Uutd1jpB9CHyc/UUwXlWg/KjAdvdaJZ4F2OZXwB7L5P6dMD+1jC6nTyuZpm5PS9CtNS9Z16yeLGBl3Ad0nUNUBCqKHCDxWSFWZQfj2NVqfwx76uus4UBXnke8AOCrJIKukIbicJwDDgCPMjuupiP4dQe8mByUYdsO7ik3lHdHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397708; c=relaxed/simple;
	bh=5N31Bn+fMZxVCyI4v/P4OWSLDjqclKHgBXc2TzlRNtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XQiXpcYp5dOf4h6nZrDFgX1o5atVMqQGGS7bw1nb1o6IJ0dqMjSNclKcBd1m5K+zze+o2takxX0hk7H5C5fmRyC50lDaqP1jZlXWaJk+iZzh+aU9TMBUJc5B+0ZirHAuxiZNAuwFKLmdfJSD6ikqv0dZals9skvO8+6eRz/WIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sUGpDUKY; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sUGpDUKY"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so1489500a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789397706; x=1790002506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QFieKNss0oxmMeY7RkxeoYk4NgyWyR9vOSnVYMRho1A=;
        b=sUGpDUKYe9z2EVylWHN9io5C2Vn3Srzq1acB0DXECpYtbVVaIyhXhpgnsrqHYDjXvT
         oOp0pD8b/va3I1LWzl31WBk8D5aRGLPRKyKTHh5NcVDT879hg1VtPZYwxF9BMOXn+mRu
         b3J5ZPC5NFohM8tFq1zV1CFjzJywdQXJHvBJd89HtOWYzMOHTw5ClL1Zi0MEObUrlUwq
         eSs3LUbNu5C6KJ9uCbTr+jspTMHAl/J9gfGh73qo0Rz/gSu5vfZF70amapRRk2TdDf70
         sCUTys/Zep/lNxPWC8ZFHafsvt10VGu08ATp4zv1obXEKBQjpkbUd3vlCQhHKLMnU+2L
         J9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397706; x=1790002506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QFieKNss0oxmMeY7RkxeoYk4NgyWyR9vOSnVYMRho1A=;
        b=iqsrF3LhbwIt1mCZ6zY/pRAUwMvP6Ik6MwTyvCqe3PtoVJCXWwQLJPDPx/SEp9N4Dy
         pEGRAhMyJS4wmmg9dzqVZFkxRB/AxYty3KB4HS+OzltGqr541ZT4N/AwZ7pH1hTkZ7/l
         1jzJub5Ocez3rwSRAVK0K1ImSMg4yc/4CyGsW6ADxqIwXfwBpShWakroKTiizt3y7B/q
         dD2kpujxU3HQ9JIlBQMSTM1tAKKD/fjHCsQN5xsxKRwiLWRbB5nNOXI1QC7yVBM1RpqE
         +q85vF5VRXkeVMhGm+9Gc/s41PGVuTtyCRXnilfMSIvawcvAmLIkA0EYsg0dPZBt8xRI
         setQ==
X-Gm-Message-State: AFuF++lKMaV4iNC+RBYNrWrSt+aRsh/yjTwA7y5x6TWHG9gmea+ZS8P7
	QUWdmJkqva78bPlKXeV5iOtqomr8yeuKQySScsVFWBj4GzCbWxuqBRlGvOhzg2g7
X-Gm-Gg: AYBFou1x/8oo0DmbPZNkFZtbZo6+7KQRZstHi1dcsOSXbRVFyCbO4R/XKbw1nncG5dn
	McxDogzA0lS27QAa1XXQEg7TAIzFgIAtbqInqI9iWbiUELCZ3qx+BEcoj45exzE/H2RVA6//qjg
	QcOf690Z6QcVIaRiPv1eNuQLU5FEMbewI8dtSwsiVNJhrDB7ECky6TTEh7X20tTW1HwCy5SzSjN
	x29lFaY5+aYuweEE/5emqae6stjKfXKCTwcluSAkyU6g0MkAsg8bdgQIq77zwwiUdmHAuvF+Vqd
	no1xFYHIdNKLfiCxe8lk1qn1qffzYzoGX+H3pe+CxQGMDzPuTeMEpvdfiloGQrvbpaCL5EiGbGj
	VUEssTe92jBqm3IiNrHwAsL/n77/nXQbRaSPkTDsSE0rroLuuBG7yxgHtXdY8vO0MmvXkaXCyp2
	8QPXsw2jCXoJ9DgVmDSmkSXpTFI9CbLcvmnxsTICpnNaRzx7D4LVBsfiQcCNxONHkZq3Cw2InYV
	ujVgkasO82Xw+glnnbkTmpZav0/OOUcBmgjCjhm
X-Received: by 2002:a05:6a20:2443:b0:3c3:8c91:5da0 with SMTP id adf61e73a8af0-3db4061e3ddmr5845756637.15.1789397706065;
        Mon, 14 Sep 2026 07:55:06 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c615a65bsm5338805a12.3.2026.09.14.07.55.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 07:55:05 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] wifi: iwlwifi: fix RCU lifetime on setup failures
Date: Mon, 14 Sep 2026 22:54:30 +0800
Message-ID: <20260914145433.42830-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two key-add error paths remove packet-number state from RCU-protected
pointers and then free it immediately. Concurrent RX readers can still
hold the removed objects.

The MLD link-add error path has a related problem. It can free a link
without first removing a restart-time published pointer, or free it
immediately after unpublishing it on a later firmware failure.

Use the RCU-delayed freeing already used by the corresponding normal
removal paths, and make the link mapping cleanup common to every failed
link add. Keep the MVM and MLD fixes separate because their origins,
objects and maintained-line exposure differ.

Zhao Li (3):
  wifi: iwlwifi: mvm: defer freeing PTK PN state on key failure
  wifi: iwlwifi: mld: defer freeing PTK PN state on key failure
  wifi: iwlwifi: mld: unpublish links before freeing on add failure

 drivers/net/wireless/intel/iwlwifi/mld/link.c     | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

base-commit: 50d3d79dc0743b616afb00d01a626c76758721f7
-- 
2.55.0
