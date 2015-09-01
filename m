Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36546 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbbIAH4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 03:56:00 -0400
Received: by lbvd4 with SMTP id d4so37772562lbv.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 00:55:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH iw] iw: display interface TX power if available
Date: Tue,  1 Sep 2015 09:55:52 +0200
Message-Id: <1441094152-10977-1-git-send-email-zajec5@gmail.com> (sfid-20150901_095603_036555_7CBF1B31)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This makes use of the recently submitted patch
[PATCH] nl80211: put current TX power in interface info
---
 interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/interface.c b/interface.c
index 73ccecd..13806ba 100644
--- a/interface.c
+++ b/interface.c
@@ -367,6 +367,8 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 
 		printf("\n");
 	}
+	if (tb_msg[NL80211_ATTR_WIPHY_TX_POWER_LEVEL])
+		printf("%s\ttxpower %d mBm\n", indent, nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_TX_POWER_LEVEL]));
 
 	return NL_SKIP;
 }
-- 
1.8.4.5

