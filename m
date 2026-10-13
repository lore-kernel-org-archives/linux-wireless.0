Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB2848A8C5
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897216; cv=none; b=ajWEaViZFY4G6r//Ece04P6tjtXOdYmzyusBiEl3QkeQvcZgdS6QKGbvzVuLJP72WVFTkW/NNF/ceHmC1gfC2Pr4jVcW9xW23iWsCSD4s207fQU5NfJX14MsymP/J3IYsi48A0oXSF3/S4U8Y63ZPa1oWMgSOz8v+U2wBd99pxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897216; c=relaxed/simple;
	bh=JvhvmTJJPYMjt/DRscQzy2levCVix4mjcApI3pnH7Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cnfZNyT8C2r/K2sx+rsAF2OGCgv9d6QP/Bk4dRklQlRyT0t7kq+Ln4hr8Z0oWXU07M3qKEfVSLzPzjFCKkNj+irR5ShqJ4Dr5BpmTqE/LFaeGxJou6wM2XtwePkeytsl2YjVzdXTtoJ+NHhYjQreYhuLVyqsP3ihsE4bUt486KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Wkaq89hA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Wkaq89hA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=n+4q8bM1TnwmymBr/jt1MmBhBS1o9ihnXS3fFAz14AI=; t=1791897214; x=1793106814; 
	b=Wkaq89hAimLqBGFOR52CNm6f/1rY6FlBTX5/PMjxwbC19hK0LH5SE0I3zCfQW5jnhhPmd6Byh2d
	Xj190ifj9+kwZgvwbS2RvV855FDlk6TC8AWQMX6BivG2tg5nNyz2MOTk/+Ya6I00oPn9/voITm/o6
	iVXzbvyThTwHXFA/kt6I7V7n0KOhJpSMZP32gpVDwrL4YkNvn3ng5MP8Gpy1oWDjR+zOgXdvTkvYk
	CqlzNvC005n/DoSyshs/8PYH3RCLsm+OMS1/Xx/evpgyYFzNTH4PIb32FRsg60w6lgeBkWv7FuwMB
	VJyIBJy++MBG8FQaBVi3jckPZI2sYl0OjoJA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcJw-0000000HPtA-063p;
	Tue, 13 Oct 2026 15:13:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: tests: fix stack variable bug
Date: Tue, 13 Oct 2026 15:13:29 +0200
Message-ID: <20261013151329.b8135eb40430.I97a6cb689fbc19903c78e2f6dfe37bdc2117b605@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The code in mac80211 assumes that BSS entries are
allocated together with the struct ieee80211_bss
internal data, but the test didn't do that, which
with clang 23 resulted in a KASAN splat here. Fix
the code to properly have both structs.

Fix the allocation while at it, should be the ies
struct size, not the cbss.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tests/chan-mode.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/tests/chan-mode.c b/net/mac80211/tests/chan-mode.c
index 85dc87215d23..d6714df8a5c6 100644
--- a/net/mac80211/tests/chan-mode.c
+++ b/net/mac80211/tests/chan-mode.c
@@ -153,8 +153,11 @@ static void test_determine_chan_mode(struct kunit *test)
 		.mode = params->conn_mode,
 		.bw_limit = params->conn_bw_limit,
 	};
-	struct cfg80211_bss cbss = {
-		.channel = &t_sdata->band_5ghz.channels[0],
+	struct {
+		struct cfg80211_bss cbss;
+		struct ieee80211_bss internal;
+	} bss = {
+		.cbss.channel = &t_sdata->band_5ghz.channels[0],
 	};
 	unsigned long userspace_selectors[BITS_TO_LONGS(128)] = {};
 	u8 bss_ies[] = {
@@ -229,18 +232,18 @@ static void test_determine_chan_mode(struct kunit *test)
 	if (params->userspace_selector)
 		set_bit(params->userspace_selector, userspace_selectors);
 
-	rcu_assign_pointer(cbss.ies,
+	rcu_assign_pointer(bss.cbss.ies,
 			   kunit_kzalloc(test,
-					 sizeof(cbss) + sizeof(bss_ies),
+					 sizeof(*bss.cbss.ies) + sizeof(bss_ies),
 					 GFP_KERNEL));
-	KUNIT_ASSERT_NOT_NULL(test, rcu_access_pointer(cbss.ies));
-	((struct cfg80211_bss_ies *)rcu_access_pointer(cbss.ies))->len = sizeof(bss_ies);
+	KUNIT_ASSERT_NOT_NULL(test, rcu_access_pointer(bss.cbss.ies));
+	((struct cfg80211_bss_ies *)rcu_access_pointer(bss.cbss.ies))->len = sizeof(bss_ies);
 
-	memcpy((void *)rcu_access_pointer(cbss.ies)->data, bss_ies,
+	memcpy((void *)rcu_access_pointer(bss.cbss.ies)->data, bss_ies,
 	       sizeof(bss_ies));
 
 	rcu_read_lock();
-	elems = ieee80211_determine_chan_mode(t_sdata->sdata, &conn, &cbss,
+	elems = ieee80211_determine_chan_mode(t_sdata->sdata, &conn, &bss.cbss,
 					      NULL, 0, &chanreq, &ap_chandef,
 					      userspace_selectors);
 	rcu_read_unlock();
-- 
2.56.0

