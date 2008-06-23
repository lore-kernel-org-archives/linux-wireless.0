Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:52537 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbYFWVXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 17:23:48 -0400
Received: by py-out-1112.google.com with SMTP id p76so1121335pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 14:23:47 -0700 (PDT)
Subject: Re: [PATCH] mac80211: remove ieee80211_get_hdr_info
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214200251.21092.23.camel@brick>
References: <1214200251.21092.23.camel@brick>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 14:23:45 -0700
Message-Id: <1214256225.21092.26.camel@brick> (sfid-20080623_232353_170318_06AEEC3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 43070f098527c6f9022a83eb41e95b166e6d8605 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 23 Jun 2008 14:21:13 -0700
Subject: [PATCH] mac80211: fix incorrect bit masking from previous patch

Checked ieee802.11-2007 and saw I changed this to mask one too many bits,
the original comment is correct.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index fba5fda..5d0d6db 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -322,7 +322,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 	 * Retry, PwrMgt, MoreData; set Protected
 	 */
 	msk_fc = hdr->frame_control;
-	msk_fc &= ~cpu_to_le16(IEEE80211_FCTL_STYPE | IEEE80211_FCTL_RETRY |
+	msk_fc &= ~cpu_to_le16(0x0070 | IEEE80211_FCTL_RETRY |
 			       IEEE80211_FCTL_PM | IEEE80211_FCTL_MOREDATA);
 	msk_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 	put_unaligned(msk_fc, (__le16 *)(aad + 2));
-- 
1.5.6.290.gc4e15



