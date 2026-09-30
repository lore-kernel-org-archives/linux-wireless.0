Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936264F68CB;
	Wed, 30 Sep 2026 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776520; cv=none; b=PbrUV8b4XkZirhimddYNNaAmzeXW6FufW1Vo+5E/7UyVEM6/ficmBQiSKOxsMW32/aFOz/aGKNid2iHlfMv0vq5/zyLJssfQuZxzSOOn1nscmtqNzFvbRaxgoMH0FJ1YeW5gwuYXRNWR56HevuuEF7XL2GTokfDcasX6qsZ8epw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776520; c=relaxed/simple;
	bh=khIoAs17NPuqov3hZ1I5P4D7APCOwpU8h83sk72MxLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+bRuQkhGeEhWNn0YUUS/euoeni/ckJiW0VFz7VnWdhu3sSdIRAFLPXuekz/RpnXRYhsNGqy+L3u4IaTRjmjD9vvn5s4yERVy8cY5SwryAE4D3LVaYWW5OWyBqWzN/U3m3hbmMfnvwxSJCibjPt3F2aHyozxsB3Jd1iMtvd5Q/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O0TddSI2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EkpqSW5t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B2h8kmRl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=APeTw1Fh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O0TddSI2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EkpqSW5t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B2h8kmRl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="APeTw1Fh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A1C721E93;
	Wed, 30 Sep 2026 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790776492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBD2fm7jkBI8ZbufJ/IEgu6LDxjnVtU1SSntyNb6WUc=;
	b=O0TddSI20SYRS6+DiLMtdIJrfyzB/bDfTCzPKwa0OzT4fxclmMgoyJVWI1Gt/R57djV16w
	6/lg4hzLuFLUnzoKt0W6cELDRnuf/Nv2Ef3ilnFX90v07jnrLo9qdwLhO6GW9y/ahIHzuA
	B2NOecMCfZGN3WKZBZof/KtgqJjInhk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790776492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBD2fm7jkBI8ZbufJ/IEgu6LDxjnVtU1SSntyNb6WUc=;
	b=EkpqSW5ttNdK9yHOf3Fi99WyQsSuNvQP7AN0g2B5BVuEUxKykBWYRlWq3j00Jpk13z8gaE
	ZtcCAu1bSrUWOvAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790776488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBD2fm7jkBI8ZbufJ/IEgu6LDxjnVtU1SSntyNb6WUc=;
	b=B2h8kmRl7KHSFOg+d5kyTA6qtoTMBEc4e914ZtjPKFSfzuxdHiatdrIEk1aSFDeEnyL6+z
	AFiDLsbmGEMYtb0+P82pymZPVUm7hkIuGaVcViedm0oK9fwUG545kEbRKDMVXDfxpnOG36
	5Rjz0qOsTo+6rI+s0jfDlrBBn9U2o+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790776488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBD2fm7jkBI8ZbufJ/IEgu6LDxjnVtU1SSntyNb6WUc=;
	b=APeTw1FhkxeVd2eDPl58UWWoWD/lBgU53fGIfzQUV8ag/0qiWg3fT7Vh/J1LVkSNRy3I58
	7xE1uAjj5zqbbDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FEAE13AC2;
	Wed, 30 Sep 2026 13:54:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fJXpHGIUvWqUTwAAD6G6ig:T15
	(envelope-from <fmancera@suse.de>); Wed, 30 Sep 2026 13:54:47 +0000
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
Subject: [PATCH 14/16 net-next v3] wifi: mac80211: replace CONFIG_INET with CONFIG_IPV4 guards
Date: Wed, 30 Sep 2026 15:52:57 +0200
Message-ID: <20260930135334.4739-15-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260930135334.4739-1-fmancera@suse.de>
References: <20260930135334.4739-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.76 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.16)[-0.822];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLrr9ek4ud4f4qwi71m7motjzt)];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.76
X-Spam-Level: 
X-Spam-Flag: NO

Historically, the mac80211 subsystem used CONFIG_INET to guard IPv4-specific
address notifiers, assuming that if IP networking was enabled, IPv4 was
guaranteed to be present. As part of the effort to make CONFIG_IPV4 optional,
this assumption is no longer valid.

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

