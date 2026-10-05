Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D5F386561
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195066; cv=none; b=K+KVteR446peGV3p7lEiloDGPyX3NSpjYLp6ZzMsAicYIXi+qn7dmyLlJtocinVzNYuT6fLkadeVYQmsdvqtxtKYp7n3rRoaDwf3as+lCqVgFg/1nudGmxO3ClECjoDXOCheIm4C6nvxgIRAWy3+BRQdOMf0xWTKdX7EKKXzbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195066; c=relaxed/simple;
	bh=bt44u1oa2pUCmHpRWqqPno10UU1AGdLNS8cerPaRY2M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=m7oWOv2cykglPNM6UrxXHOdwxIZkK1h/D58hk5rbHAbHWTH3MuACAGbxymfFZ/BqTUmStkI/wQKDrvUZ/P0J9fZvjW3F7yBM4eyU2R+LRjqBu2n5ctVcT4zKkub8y3od5MERwdxjWkd5xzvmxSFffMSa/hpDxEY9ao5+Zdclq10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=g0Rq6yWZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="g0Rq6yWZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=bt44u1oa2pUCmHpRWqqPno10UU1AGdLNS8cerPaRY2M=; t=1791195064; x=1792404664; 
	b=g0Rq6yWZv+4sQwanMe9e8LU3AYrpMb53i1ICu5sICkDFmGpYQdbhQlOxoyXFXgsrNhXi/xUqVlD
	SJ/nCfPQFvwa6/FqH2wfW9dCfUA6zWEOSHcoYefF7D5zCFi7ELTrExbLZpUwqW3IXWfbIbFQ3stWc
	4YqTYMWv51RaUesUzreRP+Js2Uy5LtXq+1TsUMVidQBbS3yhJXXxykfdbcDQF6KZRDEsbA1/nTZWY
	mQUxYuuwGrUxKU1xY/TfZTwY8ObMq6MDUfHWB9UfXgo+xGOfsbDKh0n3z9W/u+t1jMBpR38XnT8MJ
	Fk+P3nj/uq+HGnP56gypBj3BJ1xbhMjliHaw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfev-00000005CGx-49s4
	for linux-wireless@vger.kernel.org;
	Mon, 05 Oct 2026 12:11:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH v2 00/13] wifi: lock contention improvements
Date: Mon,  5 Oct 2026 12:06:16 +0200
Message-ID: <20261005101057.1992330-15-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As before, on top of the series I just sent:
https://lore.kernel.org/linux-wireless/20261005100525.1991059-20-johannes@sipsolutions.net/

The idea is the same: make some methods unlocked to avoid lock
contention on the wiphy mutex, adding also a new "update beacon"
method (but that needs driver opt-in, for iwlwifi that'd be ~40
lines changed since it can send commands async).

I've changed the approach though - in part to cover NAN TX, but
also to make it a bit more easier to reason about and extend in
the future for other wdevs.

So patch 5 is new, split out from what was patch 5 before and
is now patch 6, to make it easier to understand.

I'm actually pretty happy with this and it passes tests, so I
see no reason not to do this, but it won't apply on the tree
now and I need to settle the RTNL redux first, so still RFC.

johannes

