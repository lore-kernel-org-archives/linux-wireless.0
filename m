Return-Path: <SRS0=Yp73=6I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA68AC2BA1A
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 10:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE4C20767
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 10:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgDXKBK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Apr 2020 06:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgDXKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Apr 2020 06:01:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E55C09B045
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2020 03:01:09 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRv8t-00FSF7-N5; Fri, 24 Apr 2020 12:01:07 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: reject channels/chandefs with KHz offset >= 1000
Date:   Fri, 24 Apr 2020 12:01:04 +0200
Message-Id: <20200424120103.12b91ecf75f9.I4bf499d58404283bbfacb517d614a816763bccf2@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This should be covered by the next MHz, make sure that the
numbers are always normalized.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c | 3 +++
 net/wireless/core.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d60e50a3b910..e111c08daa0e 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -147,6 +147,9 @@ bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chandef)
 	if (!chandef->chan)
 		return false;
 
+	if (chandef->freq1_offset >= 1000)
+		return false;
+
 	control_freq = chandef->chan->center_freq;
 
 	switch (chandef->width) {
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5757dea2aa94..b795f363d004 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -834,6 +834,9 @@ int wiphy_register(struct wiphy *wiphy)
 			sband->channels[i].orig_mpwr =
 				sband->channels[i].max_power;
 			sband->channels[i].band = band;
+
+			if (WARN_ON(sband->channels[i].freq_offset >= 1000))
+				return -EINVAL;
 		}
 
 		for (i = 0; i < sband->n_iftype_data; i++) {
-- 
2.25.1

