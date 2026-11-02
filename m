Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655834;
	b=xsoWa4LUjCj59jB8OaseCufM3EboBTMLwzfWlZ2tGo5qbGtifKoRN+aWN3C2jrUGPRl1
	 Xapr8LJ/eJ49Fk2jpaL5gNf2WKj6oFyz+o7MtgoeAY/ltUtk1Kr4NNbIQT/ORMDZG9TUv
	 QPVztKbEbJ1ANYNllfjvUVqE50HGx3Z3KsbFVNKxeaCM7jrJrUv73xsX+XIcadvgpwwQM
	 eU1RHBCw+qVBwUoZ96n/qPhQSApLmbYUwMuGThBRp6SVLsaZvu6UkHgXzn9tivhUeArCO
	 ordE2148HobkbV0uo0PaSZdOzcrgpJfe7wQ8PqqBV3+k0LNuMKHRpVb+R4C0R/K6dvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655834;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GhV1ZF1by/gthDwqpqablLf4IEQHr//ANNy86MeF4WU=;
	b=pPWEEEo98Ql30iRuzb85oRof3wDEzmDa6ekrDLCY/6ob0jrrkrC463xNG4x6SHIwUFe7
	 DHF6DaSKj002CikMwM+LAESYjTf5WV7ApOCHVTo75KreoX0ezo0OTbQXk4c1mblSy4pcU
	 t9pZI4DJeBd2aJ1RAH9rNweE3mwFYfzXbxbwvcwKIattF065PEMimNeEQ95Z0P8OSnAHp
	 giIA+vogDxIYRFDLjRCE0/DJp+hIFYJvtz+aoE791N+nPqoxpT9SeySMxJPPt+o1COsG7
	 udN316GI3eq6naEDCKAVNYdV7WYc8bdvpf5f9uUAjSyayGbhF17nF3/x+vpF7YL8K/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=f3+lTcRz;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAAB606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=f3+lTcRz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=GhV1ZF1by/gthDwqpqablLf4IEQHr//ANNy86MeF4WU=; t=1793655833; x=1794865433; 
	b=f3+lTcRzG7H/J4rcNuzZm/b3mYsm7xSSo/bG0X765JtIGSg7+ydF5wIkbvwdYTzZxEQl3XrWuMC
	hZbkSkTQo88jb2YY4H2SMeH5Nd248vUDMunwyYYuNBgJcy3qEucVhcQKOFdoCdKRzLoDluHDiaoea
	XOAOGgp96cKlKALY+MVOj7WN4TEgArcNAHgar1pBDPOjehU96/2ljH8xAuKIwIYXA/nCqs10VHL4I
	97/MqIKAvi+Ib+PPMR30TH5q2vebQK26gq1xlqW8mPiyf8gRGuzCxNXhQADHWl4XvOHnkLMXM3RSk
	6lrOqyaDJNjeMgTSLW/QYoxAW7w2HvodAqzA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzol-000000020tw-224S
	for linux-wireless@vger.kernel.org;
	Mon, 02 Nov 2026 22:43:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/7] wifi: mac80211: station link handling for ST
Date: Mon,  2 Nov 2026 22:42:36 +0100
Message-ID: <20261102214348.1104849-9-johannes@sipsolutions.net>
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

For SMD Transition, we're going to need to add a station for
the new AP MLD, with links relative to that, not related to
the links of the vif.

Rather than try to handle this in the drivers, do something
in mac80211 to make it easier: track the active links in the
station instead of inferring it from the vif links, so that
we can have it separate during SMD transition.

Outside of SMD transition this is just a bit of a help and
cleanup, but during SMD transition it's required.

johannes

