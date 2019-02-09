Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F7DC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 15:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD62218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 15:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="J16jnVGT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfBIPRi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:17:38 -0500
Received: from 1.mo173.mail-out.ovh.net ([178.33.111.180]:39371 "EHLO
        1.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfBIPRi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 10:17:38 -0500
X-Greylist: delayed 4197 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Feb 2019 10:17:37 EST
Received: from player779.ha.ovh.net (unknown [10.109.159.123])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 8EAECF222A
        for <linux-wireless@vger.kernel.org>; Sat,  9 Feb 2019 15:02:14 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player779.ha.ovh.net (Postfix) with ESMTPSA id 1EE22270ABDC;
        Sat,  9 Feb 2019 14:02:12 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549720931;
        bh=Wx+JqDrZsucoQhyjrH465dOtdUGn5rejaBNjK8K7gFA=;
        h=From:To:Cc:Subject:Date;
        b=J16jnVGT/6Q0fu264+rrZyIWcoPtIOrKqMxFjMu5ymSZ+tjWNSv4aPFWt3DJjseo2
         t58ctOfxRUbwPSVxhDP/XCK/q0uGNXMlkT6FPrQkQK8kLzS61JW5B1U9+yMhgkJY7t
         3rn7NUnT/jnodV4Vb9sIUM7c4fl/n2Q9F4+zwkjA=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, mpubbise@codeaurora.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH] mac80211: Honor SW_CRYPTO_CONTROL in AP VLAN mode
Date:   Sat,  9 Feb 2019 15:01:38 +0100
Message-Id: <20190209140138.16692-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15953438730106182770
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleeggddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Restore @SW_CRYPTO_CONTROL when interface is in AP Vlan mode and don't
override driver decision for unicast keys.

Fixes commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto
controlled devices"), which should only have allow SW crypto fallback for
group keys.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/key.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4700718e010f..37e372896230 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -167,8 +167,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * The driver doesn't know anything about VLAN interfaces.
 		 * Hence, don't send GTKs for VLAN interfaces to the driver.
 		 */
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+			ret = 1;
 			goto out_unsupported;
+		}
 	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata,
@@ -213,11 +215,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL)) {
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				return 0;
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
-		}
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.20.1

