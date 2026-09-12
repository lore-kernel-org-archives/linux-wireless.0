Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE05B346A0B
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224258; cv=none; b=G04FAyASbnK2A0TojenRJLb+mb0kQ4kPagHpEFMnBFjWir6qdVUKjESJ1HbaB5sbqp3tPr0MFpmoKnJqm+3dFx0kSmtZwa8Hb4R0EYfxqytLjfPIknhZtx1/8U3TxF8B/q18sQpLWEOeRg/gzdDeGMvWK1eSGm3vPPW88/0fnuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224258; c=relaxed/simple;
	bh=TvuDncWOkSsmkppP6t2MIEp4IZ7VJYDyNUejDUwbID4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psiW8hXapOzJupqAXAGZkEPf1Ld91W7jErQ5tWe08MDGIunYs+9wRBT0p7Tpp9/lAqWApQK0kjsLIl7gBe+KolvVE54B+0+mSMAtL5Q4xvEfGoHjIIlNj+6Fx0W3td9qe6gLVEtgGaieQ828C7pDLLMKIPMWHnyitV8+tyfCfCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WoS8bk26; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WoS8bk26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789224256; x=1820760256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TvuDncWOkSsmkppP6t2MIEp4IZ7VJYDyNUejDUwbID4=;
  b=WoS8bk26IL80nKGfgfAKDSzDbAQOV3ExwpQhnNHF3Z0/GbiEp80hnS25
   flI4NcuVXjjmATzdm6hk8i+fE0oolUlYHs9UvGeOtBNyzOn1ERexGT2ju
   rLsrbU4c2i3VUTM7cPsLNT65rpkxdbcsgRUxcfOXtX2nPPV/KHDyrfv+y
   AicXJZD4wdaXRpdZZr1U8GRAiMSIu8M/3JMC12Gw0kEW5ihRkJvRi3xbE
   /4fIDs6rdUiM5kyEGc7sJ2+mqorAzZCRu2L4i+PoTleQeIHZ0u7OUgAC3
   HLfKS25Q0PuP1z4PbqYR2nIutKiVaMTu5ynQHNHSuhijOWs9unE3ONrAE
   w==;
X-CSE-ConnectionGUID: +/xe6aa3QseFXzSH7zY20A==
X-CSE-MsgGUID: M112x07TQgSB3jBowOIzEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11903"; a="92168855"
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="92168855"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 07:44:14 -0700
X-CSE-ConnectionGUID: yhdQpnzmSx6eKRe1yH4mqQ==
X-CSE-MsgGUID: w68aqB7jRnOIlsUTeBA3zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="268502127"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 07:44:13 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Sat, 12 Sep 2026 22:44:05 +0800
Message-ID: <20260912144405.573391-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260816174841.1918-1-acharyalaxman8848@gmail.com>
References: <20260816174841.1918-1-acharyalaxman8848@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Felix, can this go in for 7.3? 9417c5818a01 was queued for 7.2,
6.18, 6.12, 6.6 and 6.1 stable today without it; I have asked Greg
to drop it there until this lands.
