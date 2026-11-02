Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655022;
	b=bzneudzxYRx948X0pqmQ8zkzNNt9A2TigPPXnFLWaEU8R3L99W4y/NZYN+QOvastH/yK
	 UbObL08qJZRym6Qff9kG3FZzpwWcSx6CAWyuymb6gOf7hvaa5OiX0ymuWi6q4EnNW6UWW
	 T9X1yo29668uP4RUHHxsQd7eERGHh65fYn7vVXJCii6QBhwc6yWAJkv6cMXZ9s20QrnJL
	 PsAGK7y5vucUc+PQTxJOFHdfSNANupoitMLXoZPRpQRGV/Zh3vAz9OhjGXA2blN0ZXk09
	 vOJ9S1evKg04QYBRtKebQX6lDUmro86QeFAOXw8oh0AwhU23uxrJXbKmDKa4KwgHFzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655022;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34TaK45KsxAqCJsbPN1IUwfAvc5pHhgxoYno6rDOOQs=;
	b=nf+f3M6778Nwf6h52XNkLOZvjinEjGsjWp6T5f5D5rTtca25VnatVJWZW0lUqnl7l+w8
	 EHQKaucGy6bDtCrMJvXxfOhj8G2i7F5YDSlDjszIN4O0XRuzL62BvgaStyywwtlxS6bDg
	 P93pejIJSwBxP8eVymqwf3iYkMHaZSSqjGFIukVvzFqOwYK2KAcsNheGtjg56I1HF9EUt
	 a2NRQKoSaXGltO78Fbu/OZWALEzcfTDi/l9vykJUGj2y/g1pWxd+YiMjUpBfCjGVb2KZt
	 MRZoiP0K3ebv4dW0S9saU70JVALkbHGZN5WMLoo3Mcq64JMBA8B1phgze14sY12+/0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZAUSb9s9;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD582606A32D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZAUSb9s9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=34TaK45KsxAqCJsbPN1IUwfAvc5pHhgxoYno6rDOOQs=; t=1793655021; x=1794864621; 
	b=ZAUSb9s94O+9Pl6eY5bmoNVPSvy+sTdFOsJs2XSZ2CDgFpsQX2eUft4i4Bb5rer50X5gWvyU5Tb
	9IdFD9ktCCD8fjQwnO4+OFIiYvRo5uU90nYCYAXAB5FWsFd/C7SG7w4NvNaQ86Qqzbztnmc5ANaDA
	4nVngp2oHet9Axyg9+YRIDCvDwaXhLddaj288qoJUespjLdrwFRYZUlEF1rWLlqPIpuuC5bBOFQU7
	adjV7OmJGzIJj43OTw1AWwlDmBy0KzWsLUjqzKWfpgqfg/vl8/547EAT5kS55D9sIj/uIXkU9vaqw
	WU3ocwUdeXfTwN0yVeEWVCb2AHOo61Ok2efQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzbf-00000001zui-1Ex5
	for linux-wireless@vger.kernel.org;
	Mon, 02 Nov 2026 22:30:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/4] wifi: mac80211: partial critical update handling
Date: Mon,  2 Nov 2026 22:26:27 +0100
Message-ID: <20261102213017.1095413-6-johannes@sipsolutions.net>
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

So I was working on an initial version of UHR critical updates,
but decided to throw in a couple of extra cleanups/fixes here.

This isn't really complete, it only handles some parts, but we
have to starts somewhere.

johannes

