Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2553A8BA
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870526; cv=none; b=m/OuAtphrUz1UrdC4J0d7n1+Q+Nh8F+RKFvfbGaccDEON0wY2MWUZpl+ntjQk8148UIvD1zBKpdoryB/53xAqvGhG/dYpVzfatIoMh5pig2gxdd/rRjL3Cb+JQdYjHBlg6zk/bIrhgyA5fZhWZCeZJwBCBm/7MT9eTjv4FdjciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870526; c=relaxed/simple;
	bh=dOUo1WaQDJ8oXgC4DdqIrNboEmDvUDqiYPwrfwJM3jY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Qs+o6WlQB2TEWbeWn2Vja2J4rCjiF8svOJG1EgbOaX5D90qjKLBPicSg3N3jFBH9dDboZJ6SKyu6rBe7Ow6Cag1omhA7pSilXJ1F7Us7AibxZcIZ0ALeT38VylVloM//M/nckDXsW8rXoVxNTRXRbR54C6T5DOaGg854Yerwf2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iDAcr7rS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iDAcr7rS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=dOUo1WaQDJ8oXgC4DdqIrNboEmDvUDqiYPwrfwJM3jY=; t=1788870524; x=1790080124; 
	b=iDAcr7rS6cohCDKIFaclSHw65hUWTX+6WogVRDOsCiMMigxDF1C/hN87rSqq8SjfJ217JQZZ+gu
	bQioI+PGW5AYCSkUKBirfyBtOIz1DcOdbdOKh/rUI7CXpIcHTWYDJ+DQL/awN6P/Y/uqQQng1ffzo
	SkiPbkc4uu+Ndpica0hjI6ly29E9IBX85Pm8y5xrPkPDdu+0XUis7DfMnGUrUI7wiNYGaFlzrN2PV
	HpcV4/ejfEZoOVD1xxTFUDrf2tst5kkosVqqwY/RMrhRX/mA1xW/0CDPoReqpm5VDiTwtW60o74CJ
	iQBrxdmLo3Zg0mgLVxcR/rXn10EnIriflGeQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwL-0000000670J-29tv
	for linux-wireless@vger.kernel.org;
	Tue, 08 Sep 2026 14:28:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND wireless 00/10] mac80211 syzbot fixes - part 2
Date: Tue,  8 Sep 2026 14:28:11 +0200
Message-ID: <20260908122838.201719-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since I split the series badly, this didn't apply, so here's a resend
for the bots.

johannes

