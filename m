Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657434;
	b=ZQp2LNskVqrZTOQEBBYdDxeVPuzTyVQ/59GQYfJgMlUAZqo7xnFp29fQ49ptOst8jJQy
	 WtKQjI8/w2PwV2488s2gZsamqrDpff+B36EEiztgYIPW15yw9eRtPjoMzutu/ZfKQVcYq
	 PPDgZpaBXToVeLiEq79ZsAwF9SmMEtt+ft0QUL8CuGHnpAA3/PDITFzGBvDbgs617TYDG
	 2uTP2P0nG3i7podTqX67UvtVdkh4sIVZdq613+y+BTOXbfJ77rosaXOl2pcIvM1KV0olP
	 Ki0jqdjnz5d5CbUrkKR2UUy/8dcDtVop5UU3wKfApSyHlOsgN/4dd8V6vy3SaEprZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657434;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XjFsLRb/AT11DHI9rBnMOEHNC8LlqRL7A3ltuWp7lrQ=;
	b=KgrbztL206fcJakIJNNkjlx/Ps/sX5JXnLqqWm4ccYUZodum6bqHJD+iag75RzrEE0ZJ
	 ieP64nret9XxV3RxjILM8zYoMyW3wX/JJ6xuGNr0Lx8z7ZxUORNGEHg652yoDvtbn+Sb9
	 YauebC4Es4VK+e5k36BnoWSh2JMpKm10BLgBQh60X0DvzrOdhHklI8oO8VHdigJyVHuz9
	 34ZloblycWK1by1iaOr7tzF9jUtLh8Oyxs0uhALRrPfgquk7FIISO//HdZ2+hg5ojWgnv
	 T/cfONgHSMxasjRCMk2mVCerzR23TmzMQmzL3V2KTvQ7RaY0VanplTgDvLYOU8/sjcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Rd0nKnGy;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3B606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Rd0nKnGy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XjFsLRb/AT11DHI9rBnMOEHNC8LlqRL7A3ltuWp7lrQ=; t=1793657433; x=1794867033; 
	b=Rd0nKnGyP0WoxnFDRJw41CE4a8bFENy5xsotsUOlV8kfi+UOcO1/wRTFH0+sioLv5uOLgSkXkYi
	k9a8sUpT6XK51vJLQwu0e1oMhsC5rbxXPKpcHZZC3ppYSxFe/5C+zRHTwXtXvd2nc19kAnVJpp5Cq
	PvPjHwMZOW59e6M2lhXsKLhdzIkWtyrg46iwhY+b04eiWVeiTCxPM49AkkwVL/0hgoycSAoHTtRC0
	F3K/f8f/KWaolNmh5gWw6PTNZCGDlfvFxsZm537kLn2k05O1eUFKo/DGOczhZUgr64H+OslnxoNId
	WqfLBLOQWSz59Xle77Cn4tmdp36Dh3ITylFQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0EZ-000000022rO-14uP
	for linux-wireless@vger.kernel.org;
	Mon, 02 Nov 2026 23:10:31 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/8] wifi: mac80211: refactoring towards SMD transition
Date: Mon,  2 Nov 2026 23:08:20 +0100
Message-ID: <20261102221028.1124852-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So I realize this doesn't make a ton of sense as is, but
all the SMD transition patches don't really work in a single
series.

Mostly refactoring and parsing SMD elements, and the first-link
inheritance used for those frames. Patch 3 is because I'll be
putting the SMD transition code into a new file, it's a lot of
code.

johannes

