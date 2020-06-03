Return-Path: <SRS0=zppH=7Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B6DC433DF
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 09:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31BA8204EA
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 09:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgFCJPO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFCJPO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jun 2020 05:15:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E813CC05BD43
        for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2020 02:15:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jgPUL-008anN-RN; Wed, 03 Jun 2020 11:15:09 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mac80211: initialize return flags in HE 6 GHz operation parsing
Date:   Wed,  3 Jun 2020 11:15:03 +0200
Message-Id: <20200603111500.bd2a5ff37b83.I2c3f338ce343b581db493eb9a0d988d1b626c8fb@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Dan points out that if ieee80211_chandef_he_6ghz_oper() succeeds,
we don't initialize 'ret'. Initialize it to 0 in this case, since
everything went fine and nothing has to be disabled.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 57fa5e85d53c ("mac80211: determine chandef from HE 6 GHz operation")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5820ef02a587..b2a9d47cf86d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -167,6 +167,8 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT |
 			      IEEE80211_STA_DISABLE_HE;
+		else
+			ret = 0;
 		vht_chandef = *chandef;
 		goto out;
 	}
-- 
2.26.2

