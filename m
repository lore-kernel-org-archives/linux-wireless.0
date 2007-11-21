Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:42106 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753936AbXKUIBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 03:01:40 -0500
Message-ID: <4743E5DF.9040603@linux.intel.com> (sfid-20071121_080142_347926_B0DC0328)
Date: Wed, 21 Nov 2007 00:01:35 -0800
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Subject: security question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

When I connect to an AP with wpa, then I receive deauth frame, 
ieee80211_rx_mgmt_deauth will be called, which will call 
ieee80211_set_associated(dev, ifsta, 0); to disconnect. In function 
ieee80211_set_associated, it calls wireless_send_event with SIOCGIWAP 
event and memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN). wpa_supplicant will 
receives this event then call mac80211 to remove any old security key, 
the problem it will pass 00:00:00:00:00:00 as station address. 
ieee80211_set_encryption will fail since there are no station with 
00:00:00:00:00:00. This will leave the old key which causes the problems 
in the next reconnection.

Below is the work around to this problem, I am not very familiar with 
security in mac80211 so I appreciate any comment on how to fix this 
problem the right way.

Mohamed

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index c84a26e..e08df5e 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -97,7 +97,10 @@ static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
 			return -EINVAL;
 		}
 
-		sta = sta_info_get(local, sta_addr);
+		if (is_zero_ether_addr(sta_addr))
+			sta = sta_info_get(local, sdata->u.sta.bssid);
+		else
+			sta = sta_info_get(local, sta_addr);
 		if (!sta) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: set_encrypt - unknown addr "
