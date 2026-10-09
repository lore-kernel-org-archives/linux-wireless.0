Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288E37F728
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557837; cv=none; b=DRCnTKhDUKg8l2Jz/BQZWUDZMvEpNTPlMx9MiI9NjUjX8IAnheKI91UMukblon5EzLTZa/yR0P20+c1f/n4YUrI42mxLM8g4BSf/Bx8XyqXcIpGgSt8EFuXpZpoTkJ50qnD3WwE08QsRgXsIJA4HkDca/YFmYVXKC6GRH0njlQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557837; c=relaxed/simple;
	bh=PdB4GCqJ1GBuelbh1yCLFlsjXDtCvAu9IBq3sX9UJpw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=U0QmFp7TPNdBhL3pDHYEbE//oG0azrbTV2881ARkbSeX6hzSiURQnwNp/khJz4lOu5F0e6tym8wyOrfNyZ5akGbZM7fxHDpHSTMT8HPf5bG97RMTZlLXUj57Smbekh+ngpAOdjiKOhELH5qz3jbdOmAOZXoULNrQeeaaOG6mlLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pglSZNxD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pglSZNxD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=PdB4GCqJ1GBuelbh1yCLFlsjXDtCvAu9IBq3sX9UJpw=; t=1791557835; x=1792767435; 
	b=pglSZNxDGwc2pPL6UaqlSfds6Elxd+3rmS+rrcxe6JHFWB+UMr7mqE0qze0cO+MfA5O+XB1zSQU
	2uvicjPb2k+Hkkh6NoZuevSOQdD9exQuElF+OwRmEIcZocOv3mEYTlW2t5RKTFrLx5yiEf6NI8hEl
	qCV6HUTh1Ojt5ZqZF7vezviZwEj5n4o2N3zNpeaGpi6BHwBc8iDOWdg7BD+SF91jbkWuOzFkSVH+J
	0aPnB76LigTlVOuXtfvOVoQl9udou7mP696ucgtW0rfi1gWg3q/g9IskOtmiXHF+O7+0aaa1DWac7
	yGsx/LWHvyrmIX451QA+vimrkkmhcGh1XdNQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC20-0000000AlEW-020M
	for linux-wireless@vger.kernel.org;
	Fri, 09 Oct 2026 16:57:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/9] wifi: further RTNL redux
Date: Fri,  9 Oct 2026 16:56:15 +0200
Message-ID: <20261009145703.243031-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I thought I'd mostly done what could, but further analysis
shows that a few more places can get rid of RTNL. I've also
included a few related fixes.

johannes

