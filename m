Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F03C282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 10:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80ECA20851
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 10:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfEWKvA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 06:51:00 -0400
Received: from nbd.name ([46.4.11.11]:49438 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWKu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 06:50:59 -0400
Received: from pd95fd032.dip0.t-ipconnect.de ([217.95.208.50] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hTlJJ-0007sV-Vr; Thu, 23 May 2019 12:50:58 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH] iw: add HE support to station dump call
Date:   Thu, 23 May 2019 12:50:50 +0200
Message-Id: <20190523105050.15405-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 station.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/station.c b/station.c
index 0454f87..aaad079 100644
--- a/station.c
+++ b/station.c
@@ -243,6 +243,18 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 	if (rinfo[NL80211_RATE_INFO_VHT_NSS])
 		pos += snprintf(pos, buflen - (pos - buf),
 				" VHT-NSS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_VHT_NSS]));
+	if (rinfo[NL80211_RATE_INFO_HE_MCS])
+		pos += snprintf(pos, buflen - (pos - buf),
+				" HE-MCS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_MCS]));
+	if (rinfo[NL80211_RATE_INFO_HE_NSS])
+		pos += snprintf(pos, buflen - (pos - buf),
+				" HE-NSS %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_NSS]));
+	if (rinfo[NL80211_RATE_INFO_HE_GI])
+		pos += snprintf(pos, buflen - (pos - buf),
+				" HE-GI %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_GI]));
+	if (rinfo[NL80211_RATE_INFO_HE_DCM])
+		pos += snprintf(pos, buflen - (pos - buf),
+				" HE-DCM %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_DCM]));
 }
 
 static char *get_chain_signal(struct nlattr *attr_list)
-- 
2.20.1

