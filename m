Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBEBC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0258F213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="ULMiAk+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfBJVGu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:06:50 -0500
Received: from 3.mo178.mail-out.ovh.net ([46.105.44.197]:40749 "EHLO
        3.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfBJVGt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:06:49 -0500
X-Greylist: delayed 111871 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 16:06:48 EST
Received: from player763.ha.ovh.net (unknown [10.109.159.248])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 74A1050E43
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:46 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player763.ha.ovh.net (Postfix) with ESMTPSA id 1E8A128EE96E;
        Sun, 10 Feb 2019 21:06:44 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=TfktcRVn+OSERbwCUCJDt1ThE+bK8gss/WKdE4HE6vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ULMiAk+cOeN7iK2EBm6LmXIt2Aw/G8jdhF5LJPcj3be2i094XhSb0pKSzOSQjVnFE
         Wn7TlIh7W0DWJUCUfMUVd7tq1cgN2omnFa5H7NFG0F4YIK6XkCXxt4hqX5fFbUBh4f
         1iTYkKb5JH1UO2StmtCuoMKFYpv9Okvl1jE384d4=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 01/12] mac80211: Optimize tailroom_needed update checks
Date:   Sun, 10 Feb 2019 22:06:09 +0100
Message-Id: <20190210210620.31181-2-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549119178548649159
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleefgdegvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Optimize/cleanup the delay tailroom checks and adds one missing tailroom
update.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

It may make sense to write a small macro for support here.
This is only a small tweak/fix of the existing code to fit to how it's
handled in the Extended Key ID patches.

 net/mac80211/key.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 37e372896230..b9f2bfc00263 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -140,6 +140,12 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * so clear that flag now to avoid trying to remove
 		 * it again later.
 		 */
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+			increment_tailroom_need_count(sdata);
+
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 		return -EINVAL;
 	}
@@ -179,9 +185,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-					   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+		if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -242,9 +248,9 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-				   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+	if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+				 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+				 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -1187,9 +1193,9 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-					   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+		if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			increment_tailroom_need_count(key->sdata);
 	}
 
-- 
2.20.1

