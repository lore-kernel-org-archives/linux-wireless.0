Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D224677B;
	Wed, 27 May 2026 03:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779854156; cv=none; b=fHMcU07eGYGVhDxnsGhPHxMaxUBR4HWXT+imEdbwwt2yY+F+shzRytzav4oC+THNTiLx8PJYpn0iSjQXgwOTSdFqI/9E+M5bzWAJlCciRukCWOVVQ5wII80QTdvuxhCpJprvpqom9v0OVqpuEGBGlsS3pJAZvf3Uj+kCgixGgTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779854156; c=relaxed/simple;
	bh=NSGUt19Oh3I/sxQLPBg67SQ1ekQb3lXS57l7omGjgfM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzNodySuMXpE90ULXeIY71HPZ7TiDNV6sdQscI6Nzw8cRcF09St8ZMHAIZWKyu4GKTHvujGnRLuee1yYC3W30tlD9S0xJ9sgBxaTF+GmpnGGfKIr4/2EWPDLf75fGarupWBTbJKpUeuw6/k2VdhlxFZBvGHvQZz1aopFla9+jbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FkTn5Aiw; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FkTn5Aiw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779854155; x=1811390155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NSGUt19Oh3I/sxQLPBg67SQ1ekQb3lXS57l7omGjgfM=;
  b=FkTn5AiwAcoHZgroUcQ6omKu/41PX5JHqqC8MSDT7+TAXaNDGnKxJJM+
   BYPwgmEFT623Le3wMoUsHfaEgKQ254a6QDxounEDRc1hRMvHoXXEH/qYa
   AoZa/S13QyBC4tihZYW/PIF00soy6bWlMNmf37Gke05HaT5E3q1J8j1/4
   wVBMutuUXOVSwgNXPtpFFI5k8RejxuI5vw8k4CA9IICPs8iD8Cb5MP+ng
   bB1pjNikR/yxQr3W/SaG84dAmE82q0rZjBDZOayp5gPHUcOpjSkvTLZGe
   kN4wD06//J3e/ArLBz54zfFwvNlwzKCUllgbwCEMM7frQrgGGyZg4djDa
   w==;
X-CSE-ConnectionGUID: xnxwD3tESyiYSzGXWnie1A==
X-CSE-MsgGUID: Wb6P6YM4R7qmjQq2/yUlXw==
X-IronPort-AV: E=Sophos;i="6.24,170,1774310400"; 
   d="scan'208";a="20533045"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 03:55:52 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:17930]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.206:2525] with esmtp (Farcaster)
 id 138d2833-e4a7-4721-ad89-22efbecfd132; Wed, 27 May 2026 03:55:51 +0000 (UTC)
X-Farcaster-Flow-ID: 138d2833-e4a7-4721-ad89-22efbecfd132
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 03:55:49 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 03:55:45 +0000
From: Arthur Kiyanovski <akiyano@amazon.com>
To: <tglx@kernel.org>
CC: <akiyano@amazon.com>, <anna-maria@linutronix.de>,
	<anthony.l.nguyen@intel.com>, <dwmw2@infradead.org>, <frederic@kernel.org>,
	<giometti@enneenne.com>, <jacob.e.keller@intel.com>,
	<johannes.berg@intel.com>, <jstultz@google.com>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-sound@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <maz@kernel.org>,
	<miriam.rachel.korenblit@intel.com>, <mlichvar@redhat.com>, <mst@redhat.com>,
	<netdev@vger.kernel.org>, <oliver.upton@linux.dev>, <oupton@kernel.org>,
	<peter.hilber@oss.qualcomm.com>, <richardcochran@gmail.com>,
	<saeedm@nvidia.com>, <sboyd@kernel.org>, <thomas.weissschuh@linutronix.de>,
	<tiwai@suse.com>, <vdonnefort@google.com>, <virtualization@lists.linux.dev>
Subject: Re: [PATCH 0/24] timekeeping/ptp: Expand snapshot functionality
Date: Wed, 27 May 2026 03:55:32 +0000
Message-ID: <20260527035533.13791-1-akiyano@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526165826.392227559@kernel.org>
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Tested with a locally rebased version of my PTP clock attributes series [1]
on top — verified ENA PHC and ptp_vmclock attrs ioctls on x86_64.

[1] https://lore.kernel.org/netdev/20260515164033.6403-1-akiyano@amazon.com/

Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
