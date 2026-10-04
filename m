Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164C4A99C6
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150312; cv=none; b=t4WTfrZVCTKy5K1maB4s4Oq9fOOY9RT/LlZ7vf7/Eq1j0o199GIjEJkA0QpOvnd/YkiVRaDGYccP3Q6GJXwW4V7O4DbS4XFYJPJR0AogXgIOA5LUF+o2bfDcVRSKCCHX/pWcjCCDiS1i8CGCq3/9qd5AF0BrfqeADr7vwroYNek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150312; c=relaxed/simple;
	bh=ffK4sThrNLPFdcgc2k8oz4HoBGe3RSnzteG9+d9zbS8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UH4/I88oF7+j1dhATR5ArLhwk1tJB9NWpkOYvE7tVrFvdEOVe0iUyRYq9rMAjWRKDB7BBLUBuDXH5GhwICZfmU5r86MOAzTN/2rtclirMWCGhB1z+bD8dLBXUT2idNLepNQQg7bVmltRV2nZORKxQ1IZDSV2VuXh5ZopWguvzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RLX4E85Y; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RLX4E85Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=K4w4r2b07iTMMP5sqdoP7Ri/9lLsqYd7mzaOBJ9rMrg=; t=1791150310; x=1792359910; 
	b=RLX4E85YBj9iAjIPKokPwin9RPXiQmXPvq0M8I+2HRhHs1IsRCKzt3wPxnhFT5jhia1vx42rnEQ
	VgMnJDH2ivSAVD+ZKaHn5a0Zn5WEj+y8Bxt+zT5FPJay8TKJ2NP4OGLP6jLqeVLM/ZsSN+UUA8WyA
	k3lztzTkyiVsW5Af6BPnuW2NGKdqyjCQ6N0Bmy72uECgc/nY875W+zLXF8YAxqrakZBmBBmWAvz4A
	akLamh4s+9h1fhHK9EzIMQIuPm2BUTu2L9odvFZ2xAfAuobSBC9T2GVxBcn0UuOfxWcxgdirm5NoC
	yoQFInU/f4V8Fj5r9VVrHDtMC9N+H6ZpEgJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU16-00000004OqT-08DU
	for linux-wireless@vger.kernel.org;
	Sun, 04 Oct 2026 23:45:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 00/12] wifi: AP side locking improvements
Date: Sun,  4 Oct 2026 23:40:46 +0200
Message-ID: <20261004214504.1636783-14-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This obviously goes on top of my (fixed) RTNL redux series.

The idea here is that wiphy mutex can be held for quite a bit
of time (e.g. waiting for firmware), but beacon updates (e.g.
with the critical update design I had proposed a long while
back) and other things should be fast.

So with this not all things require wiphy mutex. These are:

 - beacon and related template updates
   (this one needs driver opt-in),
 - mgmt frame TX,
 - control port TX, and
 - peer probe.

This does make the implementation slightly more complex, but
the added complexity is almost entirely in mac80211 (and some
in cfg80211), unless a driver wants to opt in to unlocked
beacon/template updates, which it has to implement itself for
obvious reasons.

I think we probably want this even without the critical update
design we're still debating, but I thought I'd throw this out
here because a lot of the discussion has been focused on the
latencies throughout the stack, and I never thought they were
fundamental. QED ;-)

johannes

