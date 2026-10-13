Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4972C3CA486
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896772; cv=none; b=IJoDe5qybv0wDGDBM8WvF8FmzXCSBXdvmz5a1EScHUb3T4Nd7MbpopbIuqfPdr98DK7/Km3cuJe6RNW/m123V4JdyCRHAbh4sBUL241zgJ82qKLpSEp6spySvKDzT62N5F3fsja8EqKfzdVg8jM51dV7SQeikguW9hLrqM71F+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896772; c=relaxed/simple;
	bh=ppqB+skWLpOlCHcU+dgJaQNeGPn7QyH7/7+BKNwRd1M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Go85Fz0JQVPeWg3dkZhDVuG2m3vBNSiiLJjVLSOYUY6HB9yEmMLTXA25X5pQVkjw33TzxAHJ5sd3jU+WRiz2DwsOaArRi8z+UUDQ2uZv7bROl/RrfSHfR91vObrLwBSFYoYBVbXWlHDfadIki00nky65olehAs3fYL/13ASPUlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=w4yDsKHj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="w4yDsKHj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=ppqB+skWLpOlCHcU+dgJaQNeGPn7QyH7/7+BKNwRd1M=; t=1791896771; x=1793106371; 
	b=w4yDsKHjLu9VEdo8NK6hC86CSGKHO9FAZfCZPjeZIYVKZnHsIs10BnupMtU9lYANTbEC6TovSwm
	rhf4PoKdqG/yzWLZ+xXmrHfzk0x0z5UKXTlQOoYZNzAUfhXrvWzFQ9d09pmYzI+RjyZrQDtMTIo3n
	2NNAoHYikFJ0Ae3IIoaWQRkb5H7Z+fWSPjtnAAinjYCOIQElffDwsFWJq9xDyBT/FyvTlmhWsGUzD
	9+Oi36ymwA2c5M5Hd20A8txtvkwzj84zDhFjvsAEZCZQ2icD7n+oz9Xg/mxYf6UWf90nL4ZvkJ6ZN
	wz87t6dEtXoDVGjzHURTk1kN0et/0GBReAUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCm-0000000HPRi-0027
	for linux-wireless@vger.kernel.org;
	Tue, 13 Oct 2026 15:06:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: wifi: cfg80211/mac80211: key handling improvements
Date: Tue, 13 Oct 2026 14:59:02 +0200
Message-ID: <20261013130604.254393-13-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While working on SMD Transition, and in order to actually do that,
I found that I finally need to link all GTKs to stations, not just
in IBSS and mesh modes but also in client mode.

This is effectively the outcome of that work, some things around
that as well; the core changes are patches 3 and 5, with 6 enabling
drivers to also get it in the API that way.

johannes

