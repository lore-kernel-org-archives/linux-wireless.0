Return-Path: <SRS0=VRWf=CF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C86C43461
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 22:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B11920872
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 22:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgH0Wd2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Aug 2020 18:33:28 -0400
Received: from mail.adapt-ip.com ([173.164.178.19]:50412 "EHLO
        web.adapt-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727889AbgH0WdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Aug 2020 18:33:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by web.adapt-ip.com (Postfix) with ESMTP id 5D1754F80F8;
        Thu, 27 Aug 2020 22:33:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at web.adapt-ip.com
Received: from web.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M73bZeBBbYwX; Thu, 27 Aug 2020 22:33:16 +0000 (UTC)
Received: from atlas.campbell.adapt-ip.com (gateway.adapt-ip.com [173.164.178.20])
        (Authenticated sender: thomas@adapt-ip.com)
        by web.adapt-ip.com (Postfix) with ESMTPSA id AE58C4F8182;
        Thu, 27 Aug 2020 22:33:08 +0000 (UTC)
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>
Subject: [PATCH 06/22] {cfg,mac}80211: get correct default channel width for S1G
Date:   Thu, 27 Aug 2020 15:32:48 -0700
Message-Id: <20200827223304.16155-7-thomas@adapt-ip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200827223304.16155-1-thomas@adapt-ip.com>
References: <20200827223304.16155-1-thomas@adapt-ip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Until now, the wifi default channels were assumed to be
NL80211_CHAN_NO_HT, or NL80211_CHAN_WIDTH_20_NOHT. S1G
devices however do not support these channel types/width.
When a default channel width is requested (during default
chandef init, or chanctx removal when not using channel
context), for S1G calculate the correct width. Fixes eg.
configuring strange (20Mhz) width during a scan on the S1G
band.

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
---
 net/mac80211/chan.c |  9 ++++++++-
 net/wireless/chan.c | 10 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index bdc0f29dc6cd..8f48aff74c7b 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -536,7 +536,14 @@ static void ieee80211_del_chanctx(struct ieee80211_local *local,
 
 	if (!local->use_chanctx) {
 		struct cfg80211_chan_def *chandef = &local->_oper_chandef;
-		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		/* S1G doesn't have 20MHz, so get the correct width for the
+		 * current channel.
+		 */
+		if (chandef->chan->band == NL80211_BAND_S1GHZ)
+			chandef->width =
+				ieee80211_s1g_channel_width(chandef->chan);
+		else
+			chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 		chandef->center_freq1 = chandef->chan->center_freq;
 		chandef->freq1_offset = chandef->chan->freq_offset;
 		chandef->center_freq2 = 0;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 0a4b8d3eaed9..3bff52d51b05 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -32,6 +32,16 @@ void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 	chandef->edmg.bw_config = 0;
 	chandef->edmg.channels = 0;
 
+	/* S1G allows a single width per channel, and since chan_type seems to
+	 * be for backwards compatibility only, ignore it and return the per
+	 * frequency width.
+	 */
+	if (chan->band == NL80211_BAND_S1GHZ) {
+		chandef->width = ieee80211_s1g_channel_width(chan);
+		chandef->center_freq1 = chan->center_freq;
+		return;
+	}
+
 	switch (chan_type) {
 	case NL80211_CHAN_NO_HT:
 		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
-- 
2.20.1

