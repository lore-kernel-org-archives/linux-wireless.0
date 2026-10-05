Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8831337C119
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233403; cv=none; b=c7L9AL5BWu0ft7KvfU8ZJLoQDDbtnVK2IulCRMRiI9cC95Q/A/ksc/lW9T1OSHm31iV4fjx1Y9vBHSqk8S8HTB5M25mb6yoaz5df/f63Si9WGg9YL7aEmYVBqtJn5HCuT3vsWQacC289lukWimo/ERQCeTDIEgjyc46r4tiu6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233403; c=relaxed/simple;
	bh=E0a/YeEU4RCGVQbq9CadLSgBxltTcwaTqzOZBzavxWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLsLviK/awHvdCZWHF/dHT4muKLfOpbJ7XO5yc2tu3hiCv1CF739KG3HRONe/E0KB4LWbN2xugCtcdO6KJ+sE/TcMyLGvfiv2WrlKN4nSQgqUK792+PCt/1I0D0EuSB/QtWtohDuulCXt7E0UtE99JHkLP/NTEhg3DtzQ0AQluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tiAtZuEd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tiAtZuEd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NUvQEo5raINciW6i9Ud8TAcspRL+h/l2Ir1VUfPr7O8=;
	t=1791233402; x=1792443002; b=tiAtZuEdrEpV+v4bvEzSbJqTFKU37Zi95sbv6chG3vrG4B9
	Tjqo8iuIgIo7rMCrDvHT9rVQ4+2zl9hBcqUMAE/VCKX4qlaKXL6rKS70JO3RL7R9OY7n11lxJVmrp
	fAuqbfeEC9TUKliZ16lVTOe0+ormrIMi48K6/h3RzIv+KmitUbepArsoEqm2m6WxmnWE0M0tjgNY6
	YIcxbCqFahlCf3lfEghmZ1TKIxvjPj0z8QKmwcd24MDTVLD3es7IrPv/BrNAcGcIgzdWzNUOfjSbe
	M2wvMDZOqY+4ciYQ/W6opwsusRY3E30MvJPyZu76g3yZUumJAIGFkh2l5oH8GELA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdC-00000005cw8-0rXq;
	Mon, 05 Oct 2026 22:49:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/10] wifi: mac80211: clear fragment cache entry 'is_protected'
Date: Mon,  5 Oct 2026 22:47:52 +0200
Message-ID: <20261005224950.c3e4106f34d5.I866c0862db031c3a810d2333acdd22e2733d2b8c@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In practice, we probably shouldn't end up with a fragmented
frame that's protected, filled into the cache, finished or
dropped and then the next frame is unprotected, since only
unicast data frames can be fragmented.

However, tools complain and it's more correct to be able to
do this (e.g. an unencrypted fragmented EAPOL _could_, at
least in theory, happen), so clear the flag when the entry
is reused.

Assisted-by: LLM
Fixes: 7e44a0b597f0 ("mac80211: prevent attacks on TKIP/WEP as well")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1121e650b0dd..bd8ae24ed1be 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2284,6 +2284,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.55.0

