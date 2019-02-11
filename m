Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935A0C282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54797218A4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="CgWSWm2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbfBKREj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:04:39 -0500
Received: from mail.toke.dk ([52.28.52.200]:55017 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbfBKREh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:04:37 -0500
Subject: [PATCH 2/3] iw: Add printing of station tx duration and airtime
 weight
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1549904674; bh=4GkId4IC3bp4udG1xQUuZAlhtGc7HIzCJ22On33V9vU=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=CgWSWm2VHruCljGEAckkvnL6ipDCYRXE5eJQ7NQoFXazVe6lBE8xZLy/KNfQEI1UY
         c/oF+UbX6P24e0fVFldD+2jTWkD8Mgq2s27a5HzpD95Y3dDFIUiih7AmBzrznDjjK9
         F3iMHsyxllg0UI25NlbFz5kxozCPSJdHw7ry2lRDwVm3lEdwsmwRSOKpSRKMC+8R/B
         VUyaZf65/MoMMBI4wzLFt9i4plAAmoexgDdfO4OfHTmzbjBVd0Svi7pgj1m8Ka9mjK
         5EOb5wzrrKFxEZ4L4l3T2zLWNmX/b8wWHo37B5xJvPNLXBbJFjpkkOa79InzcuSjLE
         u5jQaaB6nctHQ==
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To:     linux-wireless@vger.kernel.org
Date:   Mon, 11 Feb 2019 18:04:34 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <154990467412.6770.17555468557188569403.stgit@alrua-x1>
In-Reply-To: <154990467406.6770.8841156470323507480.stgit@alrua-x1>
References: <154990467406.6770.8841156470323507480.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds printing of the station TX duration (along with the existing RX
duration), and the airtime weight, both of which were added as part of the
airtime fairness patches that were recently merged into mac80211.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 station.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/station.c b/station.c
index 536120c..25cbbc3 100644
--- a/station.c
+++ b/station.c
@@ -309,6 +309,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_TID_STATS] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_BSS_PARAM] = { .type = NLA_NESTED },
 		[NL80211_STA_INFO_RX_DURATION] = { .type = NLA_U64 },
+		[NL80211_STA_INFO_TX_DURATION] = { .type = NLA_U64 },
 		[NL80211_STA_INFO_ACK_SIGNAL] = {.type = NLA_U8 },
 		[NL80211_STA_INFO_ACK_SIGNAL_AVG] = { .type = NLA_U8 },
 	};
@@ -401,6 +402,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\ttx bitrate:\t%s", buf);
 	}
 
+	if (sinfo[NL80211_STA_INFO_TX_DURATION])
+		printf("\n\ttx duration:\t%lld us",
+		       (unsigned long long)nla_get_u64(sinfo[NL80211_STA_INFO_TX_DURATION]));
+
 	if (sinfo[NL80211_STA_INFO_RX_BITRATE]) {
 		char buf[100];
 
@@ -420,6 +425,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\tavg ack signal:\t%d dBm",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_ACK_SIGNAL_AVG]));
 
+	if (sinfo[NL80211_STA_INFO_AIRTIME_WEIGHT]) {
+		printf("\n\tairtime weight: %d", nla_get_u16(sinfo[NL80211_STA_INFO_AIRTIME_WEIGHT]));
+	}
+
 	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
 		uint32_t thr;
 

