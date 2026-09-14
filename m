Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8092E7394;
	Mon, 14 Sep 2026 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789350432; cv=none; b=VnQa/ZKCfk6HU0eCPmDrHI0K7dpdJAzF9oyq34oPtzKjzyZttp7CdVH4ZcrETJiPXCg5UPxA33HKiLSuJuRDKXEj/zsQ7SpfuJ7OzTkdHxrAArsv8C8t1dst8DtMnzzSjnWYCwbeDtRGk+9Cw1dJN2HarJngYo2Yd8Ln+z9Sy9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789350432; c=relaxed/simple;
	bh=xAHp48baWR5R1QOKt1jjC4cltuY1LKBmTsnd+LBiivM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDKfBhBroHR5M9lNGDqiOyb4F6nz/Cgn090Shreu3DlZeFyEg5N3rdhX4TlAfZVVj7lkY9vWoyVdlxMQex8zkh5RLXWNlPw0gUciydyBDJL4vPAQPKtrs28YwBxJ1NSetLXiuKRSJuDmF5teGWvOFv2Nbpjcp0JZWQIAHMHjJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQQBzzh+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQQBzzh+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789350431; x=1820886431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xAHp48baWR5R1QOKt1jjC4cltuY1LKBmTsnd+LBiivM=;
  b=NQQBzzh+b5FrNostISB2CeGIq9vzXNF1SGINifecPhPI26C/kzcuSIQz
   EqrVkdlfJLq7ivYFpsggscPmCwIEFkDLVzMl8jei8zeqAJ4vbrtrKLNdK
   7snNl0SvH/YELQFAUtewKFRck6Qv0kUvuRCcQPoJDAaNEez8IJ/5HuFhu
   DP0L4g7ZZxIL1ToOPUBM6wdKznYDKK3a//FGzGcYVCVHkuRXIW7pTa4jW
   Ky0EerYCWPzRUrDpRJ6V43xaKJQ1uwkHnvBwWkXmSutT66Dc+CLwJ3afz
   lVSISb4V4oMLIDpe0KOdBYFWoY5uHBYTeRj7bCsUmB6YjoIssIb0OfNj8
   A==;
X-CSE-ConnectionGUID: PgXjv7GHQIWL5BNgJno92g==
X-CSE-MsgGUID: TYOInoFmTDOvvoeJKR5dpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="100034275"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="100034275"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 18:47:11 -0700
X-CSE-ConnectionGUID: SAuVXkO7S0iffVrMqkiS6Q==
X-CSE-MsgGUID: 7HdWhPrXTDef5ckQBTqegg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="913231"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 18:47:06 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit
Date: Mon, 14 Sep 2026 09:46:57 +0800
Message-ID: <20260914014657.633599-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com>
References: <acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 10 Sep 2026 09:23:00 +0800, Junjie Cao wrote:
> No MT7922 here; the Zenbook reporter has offered to test.

Tested on the Zenbook 14 UM3406HA, 7.2.4 plus this patch: channel
42 tmac 3 -> 27 on OFDM/HT/VHT/HE, iw 0.00 -> 14.00 dBm, matching
MD11 = 0x1b in its MTDS.
https://bugzilla.redhat.com/show_bug.cgi?id=2515420#c20

Tested-by: Fabien LAGARDE <fabienlagarde16@gmail.com>
