Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E360A391837
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785661104; cv=none; b=W0x8+yWFUYAsU3CjmZaZRdlcV49jCRMU5g3qKm5k2iRYtxmG8IpJoc2eIyJM+wSWIlfjW7vJ3xKcpIf379puSA2N9WnUQEGm5EHz9tWFv5DoxCrkrXD4qsgFlNFM2xj8+h2LLgi7P2stW38Ccwz5JUvJg7SC0FdbCGJBWAwaHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785661104; c=relaxed/simple;
	bh=7RQfqheM7kO8rVgmlHGUnx9BJBJcsvNX4lfscLyOvL0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a9oOUirAUldV6LBZ7NVvp1CdEjoBfIqXa8Kq4Z+H4nWdXgNKcBdf8g3X6AA2t3RQsdKsjGaL2Bni7qCYbe9h83CD7mYb+jz+wSOgmB4JJgnkNuAgxdGWI2OWzVi0gZFf3wdeNWNzZD4XAicsoK3hO/b4Ww8P0w5KWEwKGa6H0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Vp30cBMf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Vp30cBMf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=7RQfqheM7kO8rVgmlHGUnx9BJBJcsvNX4lfscLyOvL0=; t=1785661103; x=1786870703; 
	b=Vp30cBMfK8miNpfqqPtmQdcboSkrw/zAT1Jg0cPI6zL74ulYiD7Xm5Jc2BhYerk17akC/8vtMoj
	5Y5KeM5+KgEeloME0IuLUvSCO/7Vv+6DVWWJ2KsAt/kWs4DJAMG9mXLrOV88KxCR/UfmgU6B1ivNY
	RrB/65wCeY552B+vpkdZVRgZ8jZVQjTTbeMRhh6/vvkBZAbZFlBtY0IFm3OqeBsAjJxlcAQvypzaK
	GdPnjZIIEvZu/0kVRCrX0oOCB9nqmsp4nFOtA0Kjvd7OMBRaJmW/0RZiWgNBjqnePZzg2Nd7sNUTn
	YO1d9385dLGYIkc6DhBwpwIVzvlTGUoCCblQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqS1U-00000004NaL-1jo2
	for linux-wireless@vger.kernel.org;
	Sun, 02 Aug 2026 10:58:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/4] wifi: mac80211: encap offload fixes
Date: Sun,  2 Aug 2026 10:57:17 +0200
Message-ID: <20260802085818.1336616-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Targeting wireless-next mostly because apparently nobody cares and
it's really late in the cycle (and there's some risk involved).

johannes

