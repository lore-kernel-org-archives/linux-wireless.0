Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655836;
	b=KGJYDfkmXrbQrdm7hGzj0YpRp9/bstNXvtuFt4lY763kgZI8Wll2jH+IWIpt6Z2SHLvM
	 zOW8lyH57c5JBveUXVwuL6fV4P3lk6gNXYmKDm6c4oqLZn68WtbNvQUFL/W3cAT8REn7D
	 5wNx9hHlGZdnXZ8mAstbndW8qo91CnxA1TMNGBftW8tY2/dO85BpCZOBfN5Ndw33qgXCf
	 4dcwcXEXduPKRVZAxrMeJhhYKwF/1A9tstTZqTDt+yVv50VDQNqdPmr5+jPZFSSMtWDV/
	 RKIdtth7GUAdWzPQoI7wVP0EC4ICpgFfQ4Uvv0OcU1wxQZ88RYqfSx/IMl3c9Bkzv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655836;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=l7yRb3Ne8W8AblGwWQ3Of1ecqE3Z0eD9Gp4S57k3Hxk=;
	b=spYYc+FOjZmg6aiDm1P4duxp0GZ3wf/iZd3SRG7rCmUI4AkByUdJIrkCC1Yvx2vy12Mg
	 CyChYDeiYGEdmsGeMmJ+AgvQFQP/XwiP4kW5jzPYQq/tquTBjZmjBabbXMmMhynahpVer
	 aD/33upnBe9tfTiSTXvbtdH+0ItNW9qipH7lYdJjN4e4SM2g52YnkEXwoj9dmS6vw5HpE
	 iueG1Xqi406gdRga0E5BZ7t4BvUkJocSKF23dSbMcqQTywfhs5jyAsSzjA98XhoX0c2uV
	 CDrMYS0uDkL6dd5dqMhdWtc7Gxo5SmQT+grTa7rRo+AF5gIm+AkLqkv7PRKrsePK2ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qBaaX6aH;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E9A606A338
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qBaaX6aH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=l7yRb3Ne8W8AblGwWQ3Of1ecqE3Z0eD9Gp4S57k3Hxk=;
	t=1793655835; x=1794865435; b=qBaaX6aHcevhZT3XMr/vZJEloonY/o+G2APHwVNvksDd7G+
	NMi8EwvxpwvGIhp+fENn2/PJg7zjsfHpde4sA4jwKr/x06whpGO/koUWJVz3cEQiHP9TMrIGRfXBW
	YRSuOdKIewVfxKWFawnIfrEa49Z3E8MMA807R1QJ9UAH6Is7J1foP/M6k9l8cMh+ezd/cTBX7x+RX
	YuvYt0uhcb1XdNSS7vdnBE24hezV/IZPznF9DkGi3Ump7kKK+o0htm42KnQsPu1uXM0JyfK2lVsOm
	8vrsJ/TB4C+nlIDCu3in5dTrHi1RhxctZpuYp3dQEuUcvZVlt8Ida4h0rJFvcSFQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzon-000000020tw-2Dcw;
	Mon, 02 Nov 2026 22:43:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 3/7] wifi: mac80211: clarify change_vif_links() documentation
Date: Mon,  2 Nov 2026 22:42:39 +0100
Message-ID: <20261102224348.b708011cf650.If0190009f9ef7d9243f4452fe224e20af0b90904@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102214348.1104849-9-johannes@sipsolutions.net>
References: <20261102214348.1104849-9-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

Thinking about SMD Transition and looking at this
documentation, and thinking about whether or not
this method can be re-used, I found the docs to be
misleading. Clarify the description.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f07a4d262314..2576f9a30b37 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4732,10 +4732,11 @@ struct ieee80211_prep_tx_info {
  *	resolve a path for hardware flow offloading
  * @can_activate_links: Checks if a specific active_links bitmap is
  *	supported by the driver.
- * @change_vif_links: Change the valid links on an interface, note that while
+ * @change_vif_links: Change the active links of an interface, note that while
  *	removing the old link information is still valid (link_conf pointer),
- *	but may immediately disappear after the function returns. The old or
- *	new links bitmaps may be 0 if going from/to a non-MLO situation.
+ *	but may immediately disappear after the function returns if the link(s)
+ *	is/are not just deactivated, but removed entirely. The old or new links
+ *	bitmaps may be 0 if going from/to a non-MLO situation.
  *	The @old array contains pointers to the old bss_conf structures
  *	that were already removed, in case they're needed.
  *	Note that removal of link should always succeed, so the return value
-- 
2.56.0

