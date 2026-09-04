Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B260C4CB8BD
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533787; cv=none; b=uMcyeRijICqABBIIHVW3c+lrZCAsu5AFMAyGThnJhxMz/YC7ulVXiLUV6VQcVtwf9EjN2GVE52ZA8Qo8VBgbrV3oG21Og7xzlGPpM/Uni3vfvgcDohgg4Qe5B87xrcR+Tzm80SrhVARngnvgHwolnAja2hjaGdTBCqXy8l9oe6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533787; c=relaxed/simple;
	bh=uqS+extQPi+XlZdUA9aQztV0UYc4e4W+JKVnnx75vB4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Dp1K8c8mrsqIAVQ3VUHmk+37ROXmx+rDrnDuA9Yc2u7JJbKv9EFXsycT/yucJjrFZXbC2iuiBh6CEVwAb3eHi6O2tUbqqaZgQH+19Sm93AVjjYa0EJrsZ0H7XlC6doGv54/XFCTbzzD4+h1fFZkOKe2DvZ89FSNIn3BdKN6x0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aIeYEffs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aIeYEffs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=uqS+extQPi+XlZdUA9aQztV0UYc4e4W+JKVnnx75vB4=; t=1788533784; x=1789743384; 
	b=aIeYEffshImcrpHubYKJ1Ec8+V5kaSKtEDhTlFnWZUIZo6bdusugsn5aV+R//zpqw9cUxuHYI7E
	EYVjl3vCJBKwJCUlk5+AX2qMFVJEta2wFIYqnWwUApwIdap4okKY/1BZEwL7TSZHXuWXtJZ/ys+3m
	APD78yYf84DoaxgKIhCtQP9UAXYOYkpskAlvWKAyMOn+uvmbi2mhv/YlJ4wgeKvhBv2mmHUB7KsvW
	vgK+34X6dUn69Qw60IdXRnu7c+mT+GHDguYGCZSJ76PyoPoy5HJbegRwaBLXYZHcXmgNtxZ2S83re
	gxCXlTsKV27pcUbEGebvN02x12BF2VwmFkMQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL3-00000001SUL-0Kzr
	for linux-wireless@vger.kernel.org;
	Fri, 04 Sep 2026 16:56:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless 0/8] cfg80211 syzbot fixes
Date: Fri,  4 Sep 2026 16:55:00 +0200
Message-ID: <20260904145614.423902-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Maybe this was the plan all along with the enablement of
all the LLM stuff for syzbot? I created all of these
before my vacation, but only did the polishing (of which
a lot was needed) now.

johannes

