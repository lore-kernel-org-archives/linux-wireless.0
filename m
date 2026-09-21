Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D37495041;
	Mon, 21 Sep 2026 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994479; cv=none; b=TkQsHRMpE0TFwX7Pd/pImk5yifycx+09SSqoKoebpgec0ls9k11l1OWA8R3WGay4FK0UJ1YUB+5YCslHwYN6zDsrySw4hqUIjJ9Gfj4kiMK7DYXXMggNnJplBpyKWwhvRTzwTI8xGT1YuiOf1diZXHgiE8IRQmJ5uRukErnLql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994479; c=relaxed/simple;
	bh=9XZuk/591Nd1YASdo5dfh09lZ7OJV2y5HJsv5hBeWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+sGdYGfHkIN+Ftfg7q2EQa83l8VuA3MRQ6doMSCbNsJxR6e6hv+nxaf5E1MYdGxiTAxl6nKgbV/vLdJoEbQ3NKUr47CMa4ps8D8r6dOrEtczlZB12f+fBOld81jSGQObYK9vRwscfKpKi3UnZj0Zu/NvMu/wQkcTYcvHLot0q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=L2N8iH+G; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="L2N8iH+G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0g0zdLEzwgYv7youadd7hxtTzzMVvcPJupmSGf4i/ug=;
	t=1789994478; x=1791204078; b=L2N8iH+G3EVUWyFOuhgJWffFhb8v6ZFnRDCFevT1Kuunim2
	6pEwQ4XptfizOkSV/ltUaPhQeSowoCP02XZSg16ld0GiXoKRIDYoa5qVZWUFIvxwMW6FELmawBGZh
	drOjJUwZ8qL+16jG8yW4JZn0uVylynX0AnIjYeYe9sWuJCK/UwjC6eIf8GzvbI4sHA0DRsZukzHla
	IyeFEFWdwnkr1xJ4g5/ImCsRu3WEaKOAQWnyvIpzX0nEAf5DwuSDKvC2D/XSre5Q/RYSWfyU7B5MK
	4g8PBwRqp1W/BCEDkOe6onw0KihoTiW0XVc8KDMQ6gTfCmICVUOq4GtDEfqKrQ6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKa-00000005oVO-21uW;
	Mon, 21 Sep 2026 14:41:12 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 2/7] wifi: mac80211: add key link_id to debugfs
Date: Mon, 21 Sep 2026 14:40:51 +0200
Message-ID: <20260921144048.fee6216d4a22.I262f6ee5af944970707e1d4e6607020fcfe6ba89@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921124048.4146576-9-benjamin@sipsolutions.net>
References: <20260921124048.4146576-9-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Add the link_id to the debugfs. This is useful for hwsim tests to
validate the per-link keys in multi-link tests.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/debugfs_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 79ae3552c55b..3a4f8e9e54dc 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -65,6 +65,7 @@ KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 KEY_CONF_FILE_NAMED(conf_flags, flags, X);
 KEY_FILE(flags, X);
+KEY_CONF_FILE(link_id, D);
 KEY_READ(ifindex, sdata->name, "%s\n");
 KEY_OPS(ifindex);
 
@@ -362,6 +363,7 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(key);
 	DEBUGFS_ADD(ifindex);
 	DEBUGFS_ADD(conf_flags);
+	DEBUGFS_ADD(link_id);
 };
 
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
-- 
2.55.0

