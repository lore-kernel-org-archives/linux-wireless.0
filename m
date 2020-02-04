Return-Path: <SRS0=zIvl=3Y=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A02C35247
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Feb 2020 15:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C42C2082E
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Feb 2020 15:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgBDPpl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:45:41 -0500
Received: from nbd.name ([46.4.11.11]:43280 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgBDPpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Feb 2020 10:45:41 -0500
Received: from [149.224.158.146] (helo=bertha.datto.lan)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1iz0OR-0000cr-Dy; Tue, 04 Feb 2020 16:45:39 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH] iw: print ru-alloc values when dumping stations
Date:   Tue,  4 Feb 2020 16:45:34 +0100
Message-Id: <20200204154534.5177-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In commit 2f74c59cf11e ("iw: add HE support to station dump call") we added
most of the HE values when parsing tx bitrates/dumping stations. The
ru-alloc value was missing. This patch adds that value.

Signed-off-by: John Crispin <john@phrozen.org>
---
 station.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/station.c b/station.c
index 1be3974..f8600b7 100644
--- a/station.c
+++ b/station.c
@@ -256,6 +256,9 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen)
 	if (rinfo[NL80211_RATE_INFO_HE_DCM])
 		pos += snprintf(pos, buflen - (pos - buf),
 				" HE-DCM %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_DCM]));
+	if (rinfo[NL80211_RATE_INFO_HE_RU_ALLOC])
+		pos += snprintf(pos, buflen - (pos - buf),
+				" HE-RU-ALLOC %d", nla_get_u8(rinfo[NL80211_RATE_INFO_HE_RU_ALLOC]));
 }
 
 static char *get_chain_signal(struct nlattr *attr_list)
-- 
2.20.1

