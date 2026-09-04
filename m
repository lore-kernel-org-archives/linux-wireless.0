Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7FE4CC26E
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533849; cv=none; b=pF4W7NL4KHkCJYpbV8KI0CprCcus0RgGkhq3ORUIOt9aklwjLpm+1AOzcefk3NMmlAhlKivH5qWK8qSrkPd4bhal8BJ5EoGTVsld8p6A9ZlkW86wOGJ7EYzS9PunR98e5MIoOhjBXbMaskvNGLmTKFnLsRF/u1qd4als/LxMKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533849; c=relaxed/simple;
	bh=llaILZLPxNRJQ0qXSSb1PvLuVeWzrsi6UI+efStMvmY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rmwc9gO2Bv3++tUDqUd68N5doWHWTbb3X4MV1qX6Uib43EEItYL6TbcPcWSAYMUBadr4B1Qija1MYj3xrqsVdajMXOdExaVo8mrr6L976GDGOyqyQlWdwov0RP5fyBKoMiYL/XJ5piX+S9fJTQCd8oB29a9ODZknVo9/vyZ15Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cUmrsgjN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cUmrsgjN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=llaILZLPxNRJQ0qXSSb1PvLuVeWzrsi6UI+efStMvmY=; t=1788533847; x=1789743447; 
	b=cUmrsgjNUN2RifZ11BmZ4Sdd/CPpCaK/qiJGA+bbnop2lKNIsZ8AxCASo6CfJCKZIpEv9wW5QtZ
	MmEoymgb21KxXY+DtmbOx71Knp8Rvr86NT+znegCMB8BhQCfyfduivTIO/DsH1jj0hM0/Dj6Abiml
	HjFBp+vi3gWO+DCZymPgB5E4T3MZBE9DDH0kvnky0sg+RbolI+M17PHh44loy6cQb5swfsjv9xWtU
	OPy0ME5bCU5X1b5rPXOxAnFrJ5DqoLcdy8JdDrm+Y1IicKFP/FDEdjIEyZ6Og3S5l6HZQ7meOFT4R
	snzhY5w+cfZkY58wuDSZ1G84iAyRsQilq/7Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VM4-00000001SWk-3Ldb
	for linux-wireless@vger.kernel.org;
	Fri, 04 Sep 2026 16:57:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless 00/10] mac80211 syzbot fixes - part 1
Date: Fri,  4 Sep 2026 16:57:04 +0200
Message-ID: <20260904145722.424159-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First set for mac80211.

johannes

