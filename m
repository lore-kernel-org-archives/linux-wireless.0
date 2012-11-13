Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58619 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2KMR3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:19 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so10585eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:18 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 16/17] staging: rtl8187se: Fixed size of BEACON_INTERVAL register
Date: Tue, 13 Nov 2012 19:28:22 +0200
Message-Id: <1352827703-4659-17-git-send-email-maxtram95@gmail.com> (sfid-20121113_182947_298412_1428A8A4)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BEACON_INTERVAL register is 16-bit, not 32-bit

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 744ac8d..08fdc4a 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
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

