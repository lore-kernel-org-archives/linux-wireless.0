Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFBA4F96CC;
	Mon, 28 Sep 2026 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623952; cv=none; b=ctSzAK1UZP/7C8TweXjsUJgtphUIx43AjcKfqg1fM6G83fSZdxNHoXn5R/Jcn1JhuRhS6ai88+7pl0sLJcnwlAvd3nsYKgw1Q/AnLTIp6Q6R+bWpd/Nkicxi5BmsI+Q+qLYWaUgM0dI99tnvpo+/Iv/oNdOumRgT9YFwwJGKT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623952; c=relaxed/simple;
	bh=XvLlRT91OKxntugB1PUh2tIiqmHjaW3Whglr3pIB2V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nboYGU6tU7V3psTsnYS2SCNT8OgSYJCVq97yuQYNFCT8rWM9P+aR16DGOKndTG9/9zttWgPipQSlwqcKYDQ5VY1ENhb1CLBe7WFfYROZ5IZq+Kl+swXuhtVLGr157q902skzlYGh9d5DfsvlRt4yei9h/utSlysvklg2LpyFE8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2LzWKnsW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X/48X4YI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dJ1lyYCO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PB5cSkJX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2LzWKnsW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X/48X4YI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dJ1lyYCO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PB5cSkJX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2ADF921BF6;
	Mon, 28 Sep 2026 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790623944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQJanie8EYQn8rJ3v6cUjqxfZzTtx4sUVWsNMC80pjk=;
	b=2LzWKnsWNf98Yanu/VBeAy+NXB6EUW8FkUHEpyA7QXCsXAuP2rBnqNl4xWNAILp/pEEPR6
	ZYO0XMFwlMYFKqetSZdr7MkqJo2T5h/zLrhpm7YU9T0CBz16NibZeUikZKRCxXLekwpvaB
	d1xmpfJDbQHJhIrT7L5/8NHRvWY8mNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790623944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQJanie8EYQn8rJ3v6cUjqxfZzTtx4sUVWsNMC80pjk=;
	b=X/48X4YIFSRs6KjBzc7568RRZLKYIsN84EpWX2sRbpr0Nk8TGQ6Fxh7qULwJwP57m6m4e4
	ThG6BzsrdO80OiCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dJ1lyYCO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PB5cSkJX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790623940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQJanie8EYQn8rJ3v6cUjqxfZzTtx4sUVWsNMC80pjk=;
	b=dJ1lyYCOEaON9wtV2Fvj4FDAuT2H0PDe56i73ICdbTbUBorjtrpOX5bqdLJls2IJrz5pgt
	usaNYr1wydesu5rWNKIE/e7lfYRcR4CfH2V7mt2lM1BtZc3Rowsz+dTZ0rW1QiTrbzuXIK
	wPrmO5pNuh2stwzTpEdbbBBPe9311yI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790623940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQJanie8EYQn8rJ3v6cUjqxfZzTtx4sUVWsNMC80pjk=;
	b=PB5cSkJXFo3d0kxB0QdStweXD/8I8hJSoAcwK6dNf/QQPhUe1/Vikasx8C+NnfVWRfqM/W
	I0Kdp2m7185c+pBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F6BD1352C;
	Mon, 28 Sep 2026 19:32:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4RBiFn3AumpWOAAAD6G6ig:T15
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 19:32:19 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: horms@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	davem@davemloft.net,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/16 net-next v2] wifi: mac80211: replace CONFIG_INET with CONFIG_IPV4 guards
Date: Mon, 28 Sep 2026 21:30:10 +0200
Message-ID: <20260928193046.6698-15-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260928193046.6698-1-fmancera@suse.de>
References: <20260928193046.6698-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 2ADF921BF6
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

Historically, the mac80211 subsystem used CONFIG_INET to guard
IPv4-specific address notifiers, assuming that if IP networking was
enabled, IPv4 was guaranteed to be present. As part of the effort to
make CONFIG_IPV4 optional, this assumption is no longer valid.

Update the conditional compilation guards around the IPv4 address change
notifier and its associated registration routines to explicitly check
for IS_ENABLED(CONFIG_IPV4). This ensures the mac80211 subsystem
compiles successfully without undefined references when building an
IPv6-only kernel.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/mac80211/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7816395681fa..1a0fa55db861 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -558,7 +558,7 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_restart_hw);
 
-#ifdef CONFIG_INET
+#if IS_ENABLED(CONFIG_IPV4)
 static int ieee80211_ifa_changed(struct notifier_block *nb,
 				 unsigned long data, void *arg)
 {
@@ -1655,7 +1655,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	wiphy_unlock(hw->wiphy);
 	rtnl_unlock();
 
-#ifdef CONFIG_INET
+#if IS_ENABLED(CONFIG_IPV4)
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
 	if (result)
@@ -1673,11 +1673,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 #if IS_ENABLED(CONFIG_IPV6)
  fail_ifa6:
-#ifdef CONFIG_INET
+#if IS_ENABLED(CONFIG_IPV4)
 	unregister_inetaddr_notifier(&local->ifa_notifier);
 #endif
 #endif
-#if defined(CONFIG_INET) || defined(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV4)
  fail_ifa:
 #endif
 	wiphy_unregister(local->hw.wiphy);
@@ -1705,7 +1705,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
-#ifdef CONFIG_INET
+#if IS_ENABLED(CONFIG_IPV4)
 	unregister_inetaddr_notifier(&local->ifa_notifier);
 #endif
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.55.0

