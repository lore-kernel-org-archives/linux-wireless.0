Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38202493D4A;
	Mon, 21 Sep 2026 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994480; cv=none; b=bWqWY+ryB4R1z1s0lW4X2fVsZ3JDJWHgv2xT0VWCcmqsA1YT4rBk2k8Kau3SZHUyZEAiw6rvbcnBUFa5AchVshO5SMqyc4AH6jwFy2jds9+UzaXrqmC/Kj6y8E4RSLAA4S6HJ0sPsGsyle18cWcNkiLKHQ2EH3TA9fN3gfrQLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994480; c=relaxed/simple;
	bh=2fE5xk31Ydc8qHt9cJZsfqPoH+rlpc0G42g8pVm79PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3lV3zWb3A1DnX63BiYXtHERIIoEwy54JVH5Hajisge7o3qrLJTnrxdzAgu/mQ5j8EajNSdeFvHmptN7RYNBQpA0RX6OUSxDS3jZ6ytyzMtyX/9Ldh9to1cWUwDS5cVEq2j/VXg9aWUdxIHGVUMxgLWKgboQYltx5VCo9rknTyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gTyQEuXY; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gTyQEuXY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=a/JI9n9U4GIKD7hbIC5/PHGmfzI9OO1ueZlZUVUtmJU=;
	t=1789994477; x=1791204077; b=gTyQEuXYzfKjgIgxPTw7sF6NkcWt3t4z07DoPFAGugCXF58
	aCv08tCWoX0ieAyiEKGWDvIV1polaVdwU7BneNVF6YK37BJ6n1c1PPlhq49FnfPIWc/u8vqvdprgO
	TBeTPUU/x1X7pNlZDQ9ZrszRlKE7RyMmr37BeQhIXG8/C0Cyg/P7nRU8H6lU05UgdjHuHyzbbQFUL
	FRybq7lVzkmFV+zPlGx4mqosH6mLTaxZhzaECGshxoZiCGNmfqsWqSl6WZSCfzqorqPUwXlBFD5TI
	OhGeugL9ry96hx3H/T/nsKhOMeh0ISt3MBDthTwFHBUlexpQPYjCTaV5ikKpF0nw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKZ-00000005oVO-1sNR;
	Mon, 21 Sep 2026 14:41:11 +0200
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
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 1/7] wifi: mac80211: add key flags to debugfs
Date: Mon, 21 Sep 2026 14:40:50 +0200
Message-ID: <20260921144048.641cb1492f2e.I3a7d6912def9ba2623b41cc672704cbe3beb0bf3@changeid>
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

From: Johannes Berg <johannes.berg@intel.com>

Since there are two sets of key flags, one for the driver
and one internal to mac80211, add the first set in debugfs
as well. This will be used by hwsim tests to determine if
a key is pairwise or not, since the next changes will make
mac80211 use only per-STA GTKs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 117f58af5ff9..79ae3552c55b 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright (C) 2015	Intel Deutschland GmbH
- * Copyright (C) 2021-2023   Intel Corporation
+ * Copyright (C) 2021-2023, 2026 Intel Corporation
  */
 
 #include <linux/kobject.h>
@@ -42,9 +42,10 @@ static const struct debugfs_short_fops key_ ##name## _ops = {		\
 		 KEY_READ_##format(name)				\
 		 KEY_OPS(name)
 
-#define KEY_CONF_READ(name, format_string)				\
-	KEY_READ(conf_##name, conf.name, format_string)
-#define KEY_CONF_READ_D(name) KEY_CONF_READ(name, "%d\n")
+#define KEY_CONF_READ(name, val, format_string)				\
+	KEY_READ(conf_##name, conf.val, format_string)
+#define KEY_CONF_READ_D(name, val) KEY_CONF_READ(name, val, "%d\n")
+#define KEY_CONF_READ_X(name, val) KEY_CONF_READ(name, val, "0x%x\n")
 
 #define KEY_CONF_OPS(name)						\
 static const struct debugfs_short_fops key_ ##name## _ops = {		\
@@ -53,12 +54,16 @@ static const struct debugfs_short_fops key_ ##name## _ops = {		\
 }
 
 #define KEY_CONF_FILE(name, format)					\
-		 KEY_CONF_READ_##format(name)				\
+		 KEY_CONF_READ_##format(name, name)			\
+		 KEY_CONF_OPS(name)
+#define KEY_CONF_FILE_NAMED(name, val, format)				\
+		 KEY_CONF_READ_##format(name, val)			\
 		 KEY_CONF_OPS(name)
 
 KEY_CONF_FILE(keylen, D);
 KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
+KEY_CONF_FILE_NAMED(conf_flags, flags, X);
 KEY_FILE(flags, X);
 KEY_READ(ifindex, sdata->name, "%s\n");
 KEY_OPS(ifindex);
@@ -356,6 +361,7 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(mic_failures);
 	DEBUGFS_ADD(key);
 	DEBUGFS_ADD(ifindex);
+	DEBUGFS_ADD(conf_flags);
 };
 
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
-- 
2.55.0

