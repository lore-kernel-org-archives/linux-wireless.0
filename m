Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8903D75B6
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548007; cv=none; b=HoacJ6ztkME3PqoQN921zVkuMiRTttzsoZXBgaHMjhSYP7EKwAC1kgdfm1WhjH6Hn7tkhzAW++VjXhV8ODsMqBxGWPYT6mT/g6E0DBBvHR8/lomI/5EtN2TtujGxz70MbXAD3FzlEbfbfEBZ5yTjyioETsTNaUmj91uYdPbZfhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548007; c=relaxed/simple;
	bh=jPuYKUqiXZA3XDL/vJLFUQ2NjUikK9ltmLAXB54YF20=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XuTC2LO1aW3Ei9zHwyhIvCKybjKzI8Ag0j0olhYyhnOC3fEMCrQRlTMWo6MfVJKQ7iAMoqeFvjgwBYJRjY3iniJe7EkgMcNp7PHEYWuHUG/YJQ5btr1+CF3gxlu9GYIS6dhIfJWbtGNp20LKDRKLxBuVTadh1z6QAkcHnJMtKTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JYmr0Bl1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JYmr0Bl1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=jPuYKUqiXZA3XDL/vJLFUQ2NjUikK9ltmLAXB54YF20=; t=1772548006; x=1773757606; 
	b=JYmr0Bl1zAcUtCvTBNPd3Mn72R1EM+2MB+3E2qjEyG/0eyQiMII93D0g/5yw39Cq4TZgkQPZd9X
	S1dEgza+pbSC9FjHvreGzwMDicAw5S+VQH9CJTMi25cm9kI8Csvtak4C/Yf26pXs5h3tQLueBHcAE
	b/YhNn3NXDtL1ASXy/XRv61TGaFdOEWIojrEIxsEHis6hr5c8pE51bcAeIDKaDRuL8W4cyiDF/3Gc
	6QwjzPyBPqKGNieEoiXnVC6PXvRIRwTnWlA0c+LtQx1l14AmsOT8ohibS8ViZZWuhJ/NZJ2IITSoN
	eigHvwjVcOXcdj+lsQzlym9Qxh0tWYr4KSpg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxQhv-000000079iZ-3yH2
	for linux-wireless@vger.kernel.org;
	Tue, 03 Mar 2026 15:26:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/3] wifi: cfg/mac: refactor for NPCA
Date: Tue,  3 Mar 2026 15:26:16 +0100
Message-ID: <20260303142641.273071-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just some refactor for the addition of NPCA.

johannes

