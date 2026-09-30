Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0553B3C1A
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754631; cv=none; b=IkQ09YyGo32Juza03lI66ePV0GOsWj8Hf/gnxavhKXObIYAZ7C37mNyvHythvWbvMiVx1fNNPzO2k3tWFA4ElztoktV6qiz0NAdHxX1Yo8wwkKKPaofe7beBx5knaFne/iNvOOtBB+cFggcyE5VaHvU4B281ENo4ziECgK7K/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754631; c=relaxed/simple;
	bh=Yxe08JX9ptGHB2xEwLJ59u0kf55ZJvvYUHQYAEKA/M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=koEr0oOZVrAoCWsDifMU1CRrCEilbJYpfir32jLkoXEZnmYzmJYVwT4AR06ILn33dUQ6D9CqHmD9tyffVxgSNVLkDyvOFM3HFU78IRRZxLan911oS6u4NtNlTkOpyc0L0rPiVs7YpbTDEdkn6HZnUTAxTdWd3DA7ZfrL0bquqwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DzguySDs; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DzguySDs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754628; x=1822290628;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yxe08JX9ptGHB2xEwLJ59u0kf55ZJvvYUHQYAEKA/M0=;
  b=DzguySDsDCn5WUbycTxcHWBuifP2VvCnjBA7Xtz9tnAsgh7+VyrjzOv4
   ARcfjQIFunNtwapoM/D0vdWJjAQfV60aSCNdsOwHZb/rniZ+a7kEBRLNF
   7ni2tu+xDSJ3kDb4OGft+o4SDEH2se4swM3j3pcKjFSY3daVo8rMmyieW
   MHD1+Vty6M0mL20gJ3MOi0qvuw87Fm10NOfjW/MnxHsaeqyVMm3UpH+2h
   9BlgaxVEIM0qCrf09CP1u6CJaTZ9IoJuQb6GSnO2qU7/SuxOMjkxNTl5E
   ox0A8JE1twWV/7BO3bFfPRoaibMsT6kZisO+eIG1miwdxnDDgLVR9tlvj
   g==;
X-CSE-ConnectionGUID: za8f6y+aQ9iudTU5UOf8mg==
X-CSE-MsgGUID: mvyM0JGQS0Wk+Yz4n+K1rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296494"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296494"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:50:27 -0700
X-CSE-ConnectionGUID: 2kpZpJGmQuWGjLoTJGMcQA==
X-CSE-MsgGUID: Hk8b+w9tS5+2tQoGEU+0ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278961358"
Received: from weba0534.iind.intel.com ([10.66.226.131])
  by orviesa004.jf.intel.com with ESMTP; 30 Sep 2026 00:50:26 -0700
From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: kiran.k@intel.com,
	chethan.tumkur.narayan@intel.com,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Subject: [PATCH v1 0/1] rfkill: expose hardware-only block state
Date: Wed, 30 Sep 2026 13:12:06 +0530
Message-ID: <cover.1790752797.git.aluvala.sai.teja@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


This series adds a public rfkill helper for querying the hardware-only
block state.

The existing rfkill_blocked() helper reports the effective state, which
is set when either hardware or software rfkill is active. Callers that
need to distinguish those cases currently cannot do so because struct
rfkill is opaque.

Add rfkill_hard_blocked(), protected by the rfkill lock and available
with a CONFIG_RFKILL-disabled stub. The helper is used by a follow-up
Bluetooth debugfs test hook, which must verify hardware rfkill state
without confusing it with a software block.

The follow-up Bluetooth series will be submitted separately to
bluetooth-next and depends on this patch.

The patch has been prepared against wireless-next/main.

Changes in v1:
  - Initial version.

Sai Teja Aluvala (1):
  rfkill: add rfkill_hard_blocked() helper

 include/linux/rfkill.h | 12 ++++++++++++
 net/rfkill/core.c      | 13 +++++++++++++
 2 files changed, 25 insertions(+)


base-commit: 21b4248bfa0f410fa22202fc2c82f4808d672cda
-- 
2.53.0

