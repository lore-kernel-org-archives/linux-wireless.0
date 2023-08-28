Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F1EC83F1C
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Aug 2023 12:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjH1MGQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Aug 2023 08:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjH1MFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2023 08:05:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBFD130
        for <linux-wireless@vger.kernel.org>; Mon, 28 Aug 2023 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=EPGJHAbLgQhy29pwK65UgV+9J7j79AFCzB1P2l0I+7c=;
        t=1693224342; x=1694433942; b=BUQYVe/JXLDKZgIRzzcgKE+xVUGkoSWIZgt74SaALB1J4GD
        a+iVIAch56ysyhpZvv0t3jQTka9G/9nfvvapivPt9GdFvzRFoKpd9gFDz/3DGM98yss7R0+hRavrv
        6bLMv63mBt5jbiFgOvb2Y2M6SQPguREOMnxDgjmwhBDGpM5ngU+3d+8K2h+LlzVgHEnllrwHQ5GTK
        25sVmqDkfslvIbfXI3FAqStdJhKWrWPheiNJ9Vb/fh2we8yAWzsRGwo6dwjXWBeN7smUPgNgwJm38
        vRaKnV7HMYiS6L7zm40VqpTfupuRHvAj8aHlGdwlSl3fI3ov23uZ6uBSSoBwPJwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qaazz-00Gjgt-2z;
        Mon, 28 Aug 2023 14:05:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/40] wifi: cfg80211: reg: hold wiphy mutex for wdev iteration
Date:   Mon, 28 Aug 2023 13:59:53 +0200
Message-ID: <20230828135928.70547c5a6593.I2497429a1c6445b1e22143203d81de25ff4c0bb8@changeid>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230828115927.116700-41-johannes@sipsolutions.net>
References: <20230828115927.116700-41-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since we will want to remove the wdev lock in the future,
lock the wiphy here to iterate and check the flags.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f861d1d82b18..1cdaf273d775 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3575,14 +3575,17 @@ static bool is_wiphy_all_set_reg_flag(enum ieee80211_regulatory_flags flag)
 	struct wireless_dev *wdev;
 
 	for_each_rdev(rdev) {
+		wiphy_lock(&rdev->wiphy);
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			wdev_lock(wdev);
 			if (!(wdev->wiphy->regulatory_flags & flag)) {
 				wdev_unlock(wdev);
+				wiphy_unlock(&rdev->wiphy);
 				return false;
 			}
 			wdev_unlock(wdev);
 		}
+		wiphy_unlock(&rdev->wiphy);
 	}
 
 	return true;
-- 
2.41.0

