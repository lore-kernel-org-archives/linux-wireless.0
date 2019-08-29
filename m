Return-Path: <SRS0=l8aR=WZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47180C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 22:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1862022CEA
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 22:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfH2WJf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:09:35 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:5102 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbfH2WJf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Aug 2019 18:09:35 -0400
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 29 Aug 2019 15:09:34 -0700
Received: from asinghal-linux.qualcomm.com ([10.234.220.60])
  by ironmsg05-sd.qualcomm.com with ESMTP; 29 Aug 2019 15:09:34 -0700
Received: by asinghal-linux.qualcomm.com (Postfix, from userid 73644)
        id 6AD1636AF; Thu, 29 Aug 2019 15:09:32 -0700 (PDT)
From:   Amar Singhal <asinghal@codeaurora.org>
To:     johannes@sipsolutions.net, jouni@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jjohnson@codeaurora.org,
        rmanohar@codeaurora.org, Amar Singhal <asinghal@codeaurora.org>
Subject: [PATCH] cfg80211: Add new fields to wiphy structure
Date:   Thu, 29 Aug 2019 15:09:19 -0700
Message-Id: <1567116559-17419-1-git-send-email-asinghal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A channel is completely defined by (oper_class, channel number) tuple,
and not just by center frequency. Operating class also tells about the
bandwidth supported by the channel. Therefore add the operating class and
channel number to the wiphy structure.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
---
 include/net/cfg80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2d17e32..6467b60 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -129,6 +129,8 @@ enum ieee80211_channel_flags {
  * with cfg80211.
  *
  * @center_freq: center frequency in MHz
+ * @oper_class: global operating class for the channel
+ * @chan_num: channel number per IEEE operating class Annex E Table E-4
  * @hw_value: hardware-specific value for the channel
  * @flags: channel flags from &enum ieee80211_channel_flags.
  * @orig_flags: channel flags at registration time, used by regulatory
@@ -150,6 +152,8 @@ enum ieee80211_channel_flags {
 struct ieee80211_channel {
 	enum nl80211_band band;
 	u32 center_freq;
+	u8 oper_class;
+	u8 chan_num;
 	u16 hw_value;
 	u32 flags;
 	int max_antenna_gain;
--
1.9.1

