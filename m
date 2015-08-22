Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34404 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbbHVK6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 06:58:46 -0400
Received: by pdbfa8 with SMTP id fa8so35493647pdb.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2015 03:58:46 -0700 (PDT)
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Donald <gdonald@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 3/4] Staging: rtl819u: ieee80211: Remove unused variable
Date: Sat, 22 Aug 2015 16:28:13 +0530
Message-Id: <1440241094-5927-3-git-send-email-shraddha.6596@gmail.com> (sfid-20150822_125859_499423_6B7E8AE1)
In-Reply-To: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
References: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch discards the variable count as it is not used anywhere 
throughout the kernel.

Build tested it.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 3e502520..3445fd4 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -308,7 +308,6 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 	HT_EXTCHNL_OFFSET chan_offset=0;
 	HT_CHANNEL_WIDTH bandwidth=0;
 	int b40M = 0;
-	static int count;
 	chan = ieee->current_network.channel;
 	netif_carrier_off(ieee->dev);
 
@@ -357,7 +356,6 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 		ieee80211_start_send_beacons(ieee);
 
 	netif_carrier_on(ieee->dev);
-	count = 0;
 	up(&ieee->wx_sem);
 
 }
-- 
2.1.4

