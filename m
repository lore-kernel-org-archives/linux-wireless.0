Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55841 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2KLV7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:16 -0500
Received: by mail-ea0-f174.google.com with SMTP id o11so438714eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:16 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 16/17] Fixed size of BEACON_INTERVAL register
Date: Mon, 12 Nov 2012 23:58:30 +0200
Message-Id: <1352757511-26957-17-git-send-email-maxtram95@gmail.com> (sfid-20121112_231526_311327_BF3F8203)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/r8180_core.c b/r8180_core.c
index 1202332..9e0621b 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -1984,10 +1984,10 @@ void rtl8180_link_change(struct net_device *dev)
 	write_nic_dword(dev, BSSID, ((u32 *)net->bssid)[0]);
 	write_nic_word(dev, BSSID+4, ((u16 *)net->bssid)[2]);
 
-	beacon_interval  = read_nic_dword(dev, BEACON_INTERVAL);
+	beacon_interval  = read_nic_word(dev, BEACON_INTERVAL);
 	beacon_interval &= ~BEACON_INTERVAL_MASK;
 	beacon_interval |= net->beacon_interval;
-	write_nic_dword(dev, BEACON_INTERVAL, beacon_interval);
+	write_nic_word(dev, BEACON_INTERVAL, beacon_interval);
 
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 
-- 
1.7.10.4

