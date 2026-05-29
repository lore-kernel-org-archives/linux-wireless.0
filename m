Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4BB3AA4EF
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780037109; cv=none; b=n/Qvt5/UT6xSnyhlb6ScgJCqnsjRtcRwkfGoAlonG0HFPVgNoeS7Z0JypYdatwZCPV2J27/90SUndV918PbyvuEUKUi/9mO8r3ZAd+tl2x22/sBUv+cWcClq3BQTa8oUp1mtVEk1Viuh2hh2g4cjqr+1bZTXEeYUquroD7m/CQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780037109; c=relaxed/simple;
	bh=17Uh5uVWhiwrZ7eiXfxOa1FuJc0b6agVJBm0KDQou/E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=B4BdVxvI+6DTq9qE+e6TSDsJd/2jWFSCBDcsb7Mj82X6iRYkUuyiCMGtijHoPUPSQRGUNf9ATYgT60Y2HJtGSsFd74L3N8yReEI1Fh1M+4Z5koaSPp7UO+IOe+y9lVV+ehzz+gL5lB6c3VkxG/T36XKV3y18FEvvEKiTsAEFAVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NnYb8cDv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NnYb8cDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=17Uh5uVWhiwrZ7eiXfxOa1FuJc0b6agVJBm0KDQou/E=; t=1780037107; x=1781246707; 
	b=NnYb8cDvZOrYFfCvePIUbZJ2vK2LPriaLxEG6ia1DM8nppY5YiRQdBq1T3suFq4mIogZU+l5XwN
	Ppi0B4y0fTM5+peb/hTASnlUwsO/k8Je2p9zVexqhn9HXQsRp+O7u/Dst3st1DUylLrPtwDDB+Vb3
	//IIeYue+A2xW9tzcpovuhKDAzoRnBVfqmpG/YwGzaadZzd0Fe9SK2yGt+vxPTSjhtR8lH1Es8ZD/
	/arShZI+EzlU4xXnzpTw/V1wlUu6uDqaoRWBAIVhqFPAOFZYOciQfB6rX0pdqeUrkqMEjafO5zV/m
	mPkuPaEPBsuBkl2OWj7YUn1qoCs7ZQzusftg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSqxs-00000009XXt-3chJ
	for linux-wireless@vger.kernel.org;
	Fri, 29 May 2026 08:45:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/2] wifi: remove 5/10 MHz channel support
Date: Fri, 29 May 2026 08:40:26 +0200
Message-ID: <20260529064502.37422-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We had this discussion last about three years ago and nothing changed,
nobody cares about this code and it's de-facto unusable since the AP
side exists but not client, IBSS sort of exists but can't scan for any
networks, etc. It only exists to attract syzbot attention, and with
all attention going to UHR (WiFi 8), NAN, sensing/ranging, etc. I don't
see any of this changing.

Remove it. We can always put things back if anyone _really_ needs it
(and can actually use it), but I'd expect them to help maintain it as
well then.

johannes

