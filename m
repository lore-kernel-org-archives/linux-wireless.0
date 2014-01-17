Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57671 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaAQOaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 09:30:13 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so1558950eaj.28
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 06:30:12 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: bzhao@marvell.com
Cc: akarwar@marvell.com, linux-wireless@vger.kernel.org,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH] mwifiex: fix wakeup on magic packet
Date: Fri, 17 Jan 2014 15:26:20 +0100
Message-Id: <1389968780-27268-1-git-send-email-afenkart@gmail.com> (sfid-20140117_153017_726610_65B7FED4)
In-Reply-To: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 8 bytes preamble
14 bytes src/dst/eth_type
 6 bytes 0xff:0xff..

http://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
http://en.wikipedia.org/wiki/EtherType

This will fail if we VLAN or the magic packet is encapsulated
as a UDP packet...

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index aeaea0e..7e91587 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2438,7 +2438,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		       ETH_ALEN);
 		mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
 								ETH_ALEN;
-		mef_entry->filter[filt_num].offset = 14;
+		mef_entry->filter[filt_num].offset = 28;
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		if (filt_num)
 			mef_entry->filter[filt_num].filt_action = TYPE_OR;
-- 
1.7.10.4

