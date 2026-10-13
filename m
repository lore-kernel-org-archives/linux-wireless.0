Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E194E501F30
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896776; cv=none; b=plthKqrhvHz12DPujPj1aDdRV7JP3qlnCYfBFeRWDF4kS2Tkl+n9/z2OKqENG1idUjgEQFG6FqqptBE/3P2oP5jGFweviUr6vFxaXRGUvKtWMItBAEudCyQBzlTXhNBPbqmWjJGrueQqFzWXwkqipcMVu9PAobw4wDuuY2Unuwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896776; c=relaxed/simple;
	bh=IBUC0vJYYrzDVF0L7zzvWqicao4nXkG0OReaHtyWAAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPZR3zR0ZzMJ4E7dD0lBYyRBxXi4nsfHLbWpXuFWy8y6qPhVn2RgurrD/7bRCgfaTsgAYGwx7UCzV2i0XZbBStSb4SazUxfwbCt8un3PPuPETUWflmRAwtckCyvyRMrlpV0tzoBd0NlHKdaLxlmG3GHBkS/dcddHhcTq/9lGes0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=H5UqIcql; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="H5UqIcql"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cOthOmrhWcszCq3XKO/Ed9nK6K2WPHBNtME7FMFWQBk=;
	t=1791896774; x=1793106374; b=H5UqIcqlWD6ws5OTcrla2DP+ZPleY6VGXa1sqj51HEeA5z2
	OiUHqFUdOqwMtisoeTjQqzT6nM7rfA2mbPGw0w1pyL9fRyxPLB8RVdmSu1Vi+3gCJgBjjFAoUrUcU
	s825BnbjP9lQZwVbnE0eWPvMoKoI/85Z4IUNkcV9WwxXPM6D0XHI/7KHZeQoLLHYcyuGvivV/t5ja
	EDwGca9pWubJs8xTK5RENLCXysFLWwwnGJh0LYGzLIH0Wzz7H6QedczDfAyF4BqPSEbyqxyckM1AD
	qavoE4EypDT1t6Cy7IufLpbHsAcRVk0roO2/xbkk/ncUs3AojXFn1jGVf6zeMeYg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCq-0000000HPRi-1s5E;
	Tue, 13 Oct 2026 15:06:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/11] wifi: mac80211: allow drivers to install AP GTK on STA
Date: Tue, 13 Oct 2026 14:59:08 +0200
Message-ID: <20261013150604.e74f14ade79a.I21a55235891576ac6a4fc303a61455e840f3f53f@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Some drivers (e.g. iwlwifi) may want to install the GTK
on the AP station and not on the interface, so need the
station pointer. Allow them to set a flag to request it
to be passed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  4 ++++
 net/mac80211/debugfs.c |  3 ++-
 net/mac80211/key.c     | 19 +++++++++++++------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a25f499f3e9f..0b759697bcfc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3097,6 +3097,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_NDP_BLOCKACK: HW can transmit/receive S1G NDP
  *	BlockAck frames.
  *
+ * @IEEE80211_HW_PER_STA_AP_GTK: Install GTKs to the AP STA entry instead
+ *	of with %NULL sta.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -3158,6 +3161,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_HANDLES_QUIET_CSA,
 	IEEE80211_HW_STRICT,
 	IEEE80211_HW_SUPPORTS_NDP_BLOCKACK,
+	IEEE80211_HW_PER_STA_AP_GTK,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a8f677cfc77e..027db8b9f846 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -4,7 +4,7 @@
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 - 2019, 2021-2025 Intel Corporation
+ * Copyright (C) 2018 - 2019, 2021-2026 Intel Corporation
  */
 
 #include <linux/debugfs.h>
@@ -462,6 +462,7 @@ static const char *hw_flag_names[] = {
 	FLAG(HANDLES_QUIET_CSA),
 	FLAG(STRICT),
 	FLAG(SUPPORTS_NDP_BLOCKACK),
+	FLAG(PER_STA_AP_GTK),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d4d66d249719..35f44a856bd3 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -167,8 +167,13 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 				goto out_unsupported;
 			break;
 		case NL80211_IFTYPE_STATION:
-			/* install group keys w/o STA as we always did */
-			sta = NULL;
+			/*
+			 * unless requested otherwise, NULL out
+			 * the STA for client group keys
+			 */
+			if (!ieee80211_hw_check(&key->local->hw,
+						PER_STA_AP_GTK))
+				sta = NULL;
 			break;
 		default:
 			goto out_unsupported;
@@ -277,9 +282,10 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 		increment_tailroom_need_count(sdata);
 
 	pubsta = sta ? &sta->sta : NULL;
-	/* for now override STA to NULL for client group keys as before */
+	/* unless requested otherwise, NULL out the STA for client group keys */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    !ieee80211_hw_check(&key->local->hw, PER_STA_AP_GTK))
 		pubsta = NULL;
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -1078,9 +1084,10 @@ ieee80211_key_iter(struct ieee80211_hw *hw,
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
 
-	/* for now override STA to NULL for client group keys as before */
+	/* unless requested otherwise, NULL out the STA for client group keys */
 	if (vif->type == NL80211_IFTYPE_STATION &&
-	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	    !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    !ieee80211_hw_check(&key->local->hw, PER_STA_AP_GTK))
 		sta = NULL;
 
 	/* skip keys of station in removal process (if driver knew about STA) */
-- 
2.56.0

