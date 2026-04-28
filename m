Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF673D8115
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777367363; cv=none; b=OSnX9iKwtFEO7Q3KFTxWGwXOX47m34N8Zzf/wh73B+bHESLUUHt0qH1OPkcUCaRYiRl12G96MqNgrbSD/plKLs7SZyjNtM5UyK2nRvE+fsQJLb/6CI7marzGZxii/pgyao0x8wnwYyPxQyDUqU9L9b1skBMgrriUGzM4UXjzL54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777367363; c=relaxed/simple;
	bh=oysUeDghJJsFozQNxP4LKqrAWfjWpmMcvY9TYUtc5O8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Q1eJ47d1ot9zADELz8jZc60cG1eUYuL4IzBVEqUOv0zB/Iz4i0JBHdlCVGpBpu5ALFNGwW6As9Q0tweeQMsWqX5MzXngpXVkJiScvlQjWM8DOmN5To5XshmGBky4+ePSXWgn+wuOX+g7bfibVo8IU2o0Q6eIlKL/KNTN1j+Yq4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MpSDln6Q; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MpSDln6Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=oysUeDghJJsFozQNxP4LKqrAWfjWpmMcvY9TYUtc5O8=; t=1777367361; x=1778576961; 
	b=MpSDln6Q1WRF/Nq1miVVpXP6u5KQ/rzyoGVDCbDuKLKMpZ+nb5JU4XvpFwM/TXB4InTTG+UVVzM
	mV6BpwDCFF2MwFHMRdUF8ZrF3hLQ/m1vju4FKy9vXJAvMV1K1rykizQt5cvaYzfbl+uf6oP/9JjNc
	SM+QOYEQFbLVFxT0h/SF1FZtVKYBBxx5F1WzyeYnJST97IJ2gcsSXTQBNvKqHdoaZ+FItMGX6Rfd4
	eM6t+d9UOHgbSXYEVfJigo7Qm/ILHP1sLE76VvLO3EgNqEzZAjlSv5GojEZ6s8L1HEDDPqZXUn1nU
	s7E/8xUayAf49351sMwtjdUsokIkASzLIgSA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeRS-0000000HGH2-2M2a
	for linux-wireless@vger.kernel.org;
	Tue, 28 Apr 2026 11:09:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/5] wifi: UHR extended MLD capa/ops handling
Date: Tue, 28 Apr 2026 11:06:55 +0200
Message-ID: <20260428090915.54717-7-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds handling for newly defined extended MLD capabilities
and operations from UHR.

johannes

