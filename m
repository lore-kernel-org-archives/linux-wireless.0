Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35484 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbcECWIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 18:08:46 -0400
From: Kangjie Lu <kangjielu@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, evel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu, insu@gatech.edu,
	csong84@gatech.edu, Kangjie Lu <kjlu@gatech.edu>
Subject: [PATCH] fix infoleak in ioctl_cfg80211
Date: Tue,  3 May 2016 18:11:46 -0400
Message-Id: <1462313506-7742-1-git-send-email-kjlu@gatech.edu> (sfid-20160504_000907_231842_1D92FFCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"mac" is an array allocated in stack without being initialized,
and will be sent out via "nla_put". The dump_station() is supposed
to initialize the mac address; otherwise, sensitive data in kernel
stack will be leaked. To fix this, either initialize it (e.g.,
memset) or completely remove this dump_station().

Signed-off-by: Kangjie Lu <kjlu@gatech.edu>
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 12d1844..44a1582 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -2926,6 +2926,7 @@ static int cfg80211_rtw_dump_station(struct wiphy *wiphy,
 
 	/* TODO: dump scanned queue */
 
+	memset(mac, 0, ETH_ALEN);
 	return -ENOENT;
 }
 
-- 
1.9.1

