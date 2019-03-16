Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0849CC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 21:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CABA9218A1
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 21:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="h9oQCho0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfCPVEJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 17:04:09 -0400
Received: from 1.mo178.mail-out.ovh.net ([178.33.251.53]:56729 "EHLO
        1.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfCPVEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 17:04:07 -0400
Received: from player697.ha.ovh.net (unknown [10.109.159.224])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 6180453D7F
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:44:51 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player697.ha.ovh.net (Postfix) with ESMTPSA id 17DFB3C49732;
        Sat, 16 Mar 2019 20:44:50 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552769089;
        bh=6Z9t0LfgmwrpCiw2kLap20qR4LsWOUdV3dBUyG+mdac=;
        h=From:To:Cc:Subject:Date;
        b=h9oQCho0/RnJYb6pECk1SVjip0rv0hKBnqPt460YPmdva5QqxOQNuK1ERuqbxlzgn
         ADEw8DW4+ETAyRnJmKoob3Xv2pdafEIJS/ZvdOQZjLe1AmI0eqT4kNlg5wYkwcmXXj
         kxC4rJdBfa1yR9MNNLebTkeFKqHm57EW8LSD7BrU=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH] mac80211: Optimize tailroom_needed update checks
Date:   Sat, 16 Mar 2019 21:44:43 +0100
Message-Id: <20190316204443.16762-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6936387854503648455
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Optimize/cleanup the delay tailroom checks and adds one missing tailroom
update.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
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
2.21.0

