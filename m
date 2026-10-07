Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130338AC64
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389463; cv=none; b=gycfVeU6XSNh2qQzoUF3b4tv8NdYzja1GUD8qk4lwmQv18uPmIQOz2MuXA0gsMWehCGcIOHImlH5GYwhvwoS5pPgE/lofVDI53Ol2Kzipcfn0N79yRwQQG+PGhp3lIU0QpgKlyjfq9ZUm1bb+B8t5d242OeAf8RLIYlm1z39rZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389463; c=relaxed/simple;
	bh=X7rN6z2i6ztm7gvBvVftkggU9C8Y8EE7csWzApUW9go=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uU/4m3h3qvoLEwrEsa7/9hBFpCYGj1PgtJ1M+pl7s9Y0g7M3PrJ0LjfnysjygWUkCOeDia/fBS5IWD3pXtqN+pUpAdUFmH3SZx2wx2Da4OsA1B7ZfYaawnO73dVONOEPr3kYdrliQIwuzpnfJmhNvFKAZtP4OewbRlWh+bjk/SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v4M56b8T; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v4M56b8T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=X7rN6z2i6ztm7gvBvVftkggU9C8Y8EE7csWzApUW9go=; t=1791389462; x=1792599062; 
	b=v4M56b8T4S1EcHOYHiSvQLyFvSFv3kV8eaoTEjAgBGjH2/lvupe8HsWAcNBU9M6WcCsJbGeYFpp
	U+5bnaeTkvgod+SaeTI9G5IFMYcmkMAHycAoqLc8WBKYxXfyJx/3kGAGIzL+YEVvYtz6rEZK2nPkz
	HrRH047SDAyExSA9WTvn3O2CiHYomXZeV0uf0V2vT5oJf4mnVcqUvLabyLNThdhMpK56wmC+lEfE6
	2Q/n0X7p0JbE5DgTeKoc6BHO2C4qCUvVVPyacTzursf4NWrErw5v3pf3CRhFDDoIJmrLvai/Y4o+8
	3Ahggq5EoB7qpWUKgisKOjgDxG5/P1UqP1bQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEUEN-00000008DV1-2HqG
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 18:10:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/4] wifi: unlocked station statistics
Date: Wed,  7 Oct 2026 18:09:44 +0200
Message-ID: <20261007161056.340373-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PoC-level at this point, though I did go over it once.

Obviously goes on top of the RTNL redux and AP locking sets,
but I haven't even retested it since the cleanups. Just FYI.

I'll test it at some later date and repost as part of the
other patchsets, but will drop the ath12k patch right now.

johannes

