Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621CE3E1713
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 03:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784692148; cv=none; b=QBla701uqxRopS3LR00ZgHX6j04sMFJrRcQ7z4zAER6mrkEHUYWjhylktkSSd0R8Yui3a4ixD8wLyH+EH371fLW0HKAb0PwATXWfEl7RozUU0I3hYodPsBz33Pu8UPsXfPNBQKDup4JGf0wzAbcKWfatwBeQyq1NByjDFPSC1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784692148; c=relaxed/simple;
	bh=RVxQ3F/qTzDDQHD8UOd6uM67S93A5t+zAFr+JyEcRGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBV+jyg3ObyTCbY95RO01eLLE1CQb6o5lxeRwMLFmh1mmwfPoEUQv9DfuXiRjO6Es4ON4F0Dz8wYgfs2B6vTZ32WD4zv2VtVI2Jypg7/8Dl3uPGB6+WSc5pcsXbmgFwyOCABfAsedQkVhnCePV5DdLj69iaLKaFeohqNGimYO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=kbn7CDyS; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="kbn7CDyS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1784692143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RVxQ3F/qTzDDQHD8UOd6uM67S93A5t+zAFr+JyEcRGg=;
	b=kbn7CDySlZGmGg90g5W0Xjkx5j7D/1Yaq3tvb60FRvTh4Ik2goEdCJZhbKE84YBtQYJbbk
	agBdKC0kZKDabkly/kbrXHR0b0KO6tEWgAlA/hTRtYpsWq4WrBJqRvnwMdrg3hHOD8f2pK
	HzmITIzvUp9tVGeRWowXH0CnsLyfNBFIdWU4cV2K3W+RerpFFi5jYtrfuaNzb9wCNvGj/0
	SU/0bPQFwHY7qPgyRzRfWBBwa0t3ZwxSrZG72Z6o5SU6JdESvia0jagkDuYUsUYqCQXUGF
	P2sqgeCbN5A0wwm8B+Htkyt4rCHgXbYDpzOq9G7rbcqVDymatjNiGNN9u1Xu9Q==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt792x: do not advertise active monitor
Date: Tue, 21 Jul 2026 20:48:52 -0700
Message-ID: <20260722034852.147003-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260722011302.113060-1-lucid_duck@justthetip.ca>
References: <20260722011302.113060-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Please drop this one. I would rather fix active monitor on mt792x than remove
the advertisement, and the two directions conflict. Sorry for the churn.
