Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91075463B8C
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754631; cv=none; b=UnJ8/pGNrv4wV534AhDDcBPJ0N6skGVNaYpjj1OvCd9t0XBo3Aya4RA5D4bLosceYaPLxPmeQaDibS69/aVLvaYwbgNP/TnyK5lqp/8EcmNfeHDWpPFaNRf5F1Snzrdb2kz7ZrxTD7CS+hmos5kDCWLxtfJSzdU5zbx1n7EvDkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754631; c=relaxed/simple;
	bh=vDby/m/EEjMDeptiVNNOT544ZpplCT9d9G9DGGJ1b+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHRKZ8DS6iPCG0YiKwnUSJG0eYbhbEXxHcZTQnIw0dHz+Qg+uk3Fcf8DnrPldZg9Sd/Cwe15w5FpVofdrBLvVAyjo9bboRMCbYO9QYt6L4NhanbuDYcHpauEdRvPpmsp/+EFgxJDZI5YZYOuGM5UHxEld6szSigzx6MsweNhAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EjWqrAn4; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EjWqrAn4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754630; x=1822290630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vDby/m/EEjMDeptiVNNOT544ZpplCT9d9G9DGGJ1b+k=;
  b=EjWqrAn4M4XvgbECawZt0M7J64XHVFIwrWYRK9i6ANu6UYeJ/P0KeBXJ
   +aHm2rRi9+lyHsp+5LbMakzlakooc2y/cswX/OkMCEc+oeZPOHhTbgOBX
   TflIEczi7bhORSo/9iLsu4NIst+6oE0E8+3m27tI4Ho85T+4T0tLGpTHO
   /dNq8wJCAEJFVQj0jxB6ljfKUBMMyYz0oVMmXIBfqlWzZ48QQGIT9b3TB
   nw7ohmJYcvtORTJMFcxsy5ijg13meHpzghDlygPw3CUK+SDGGubuXe+FE
   DurlMaafeesTBATurr+6srWTQwJD0kbhXM2OeBh9q6QezXk8h51K6GF2x
   Q==;
X-CSE-ConnectionGUID: gLqj9b8uRZ6es9WBNrOmoA==
X-CSE-MsgGUID: 6I973uc2Rv26iT5UVA4AvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296496"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296496"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:50:29 -0700
X-CSE-ConnectionGUID: My4dWSZ9SKqpF0HFY8KeFA==
X-CSE-MsgGUID: nE8aElr8SAm3xGd9ONMsIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278961365"
Received: from weba0534.iind.intel.com ([10.66.226.131])
  by orviesa004.jf.intel.com with ESMTP; 30 Sep 2026 00:50:27 -0700
From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: kiran.k@intel.com,
	chethan.tumkur.narayan@intel.com,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Subject: [PATCH v1 1/1] rfkill: add rfkill_hard_blocked() helper
Date: Wed, 30 Sep 2026 13:12:07 +0530
Message-ID: <3305da8e844c9d0a5de5848b596d16de8d462048.1790752797.git.aluvala.sai.teja@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790752797.git.aluvala.sai.teja@intel.com>
References: <cover.1790752797.git.aluvala.sai.teja@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rfkill_blocked() reports the effective block state, i.e. set when the
device is either hardware or software blocked, and rfkill_soft_blocked()
reports only the software state. There is no equivalent accessor for
the hardware-only state, and struct rfkill is opaque to drivers, so a
caller that needs to distinguish a hardware block from a software block
cannot do so.

Add rfkill_hard_blocked(), which reads RFKILL_BLOCK_HW under
rfkill->lock in the same way as rfkill_soft_blocked(), together with a
stub returning false when CONFIG_RFKILL is disabled.

The first user is the Bluetooth HCI debugfs force_hw_rfkill test hook,
which must report and compare against the hardware state only.

Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
---
 include/linux/rfkill.h | 12 ++++++++++++
 net/rfkill/core.c      | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index deea02a034c3..9877ed4ea6ab 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -231,6 +231,13 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw);
  */
 bool rfkill_blocked(struct rfkill *rfkill);
 
+/**
+ * rfkill_hard_blocked - Query hardware block state
+ *
+ * @rfkill: rfkill struct
+ */
+bool rfkill_hard_blocked(struct rfkill *rfkill);
+
 /**
  * rfkill_soft_blocked - Query soft rfkill block state
  *
@@ -310,6 +317,11 @@ static inline bool rfkill_blocked(struct rfkill *rfkill)
 	return false;
 }
 
+static inline bool rfkill_hard_blocked(struct rfkill *rfkill)
+{
+	return false;
+}
+
 static inline bool rfkill_soft_blocked(struct rfkill *rfkill)
 {
 	return false;
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 9e143c4bfe6a..684139591e9d 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -979,6 +979,19 @@ bool rfkill_blocked(struct rfkill *rfkill)
 }
 EXPORT_SYMBOL(rfkill_blocked);
 
+bool rfkill_hard_blocked(struct rfkill *rfkill)
+{
+	unsigned long flags;
+	u32 state;
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	state = rfkill->state;
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	return !!(state & RFKILL_BLOCK_HW);
+}
+EXPORT_SYMBOL(rfkill_hard_blocked);
+
 bool rfkill_soft_blocked(struct rfkill *rfkill)
 {
 	unsigned long flags;
-- 
2.53.0

