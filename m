Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59291 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab3HJEJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 00:09:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix build error when CONFIG_PM is not set
Date: Fri, 9 Aug 2013 21:09:06 -0700
Message-ID: <1376107746-17000-1-git-send-email-bzhao@marvell.com> (sfid-20130810_060931_900651_F3A141B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

config: make ARCH=m68k allmodconfig

All error/warnings:

   drivers/net/wireless/mwifiex/cfg80211.c: In function
       'mwifiex_fill_coalesce_rule_info':
>> drivers/net/wireless/mwifiex/cfg80211.c:2493:3: error: implicit
       declaration of function 'mwifiex_is_pattern_supported'
       [-Werror=implicit-function-declaration]
   drivers/net/wireless/mwifiex/cfg80211.c: At top level:
   drivers/net/wireless/mwifiex/cfg80211.c:2537:12: warning:
       'mwifiex_cfg80211_set_coalesce' defined but not used
       [-Wunused-function]
   cc1: some warnings being treated as errors

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0943e7e..fbad00a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2308,7 +2308,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 }
 EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
 
-#ifdef CONFIG_PM
 static bool
 mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq,
 			     u8 max_byte_seq)
@@ -2339,6 +2338,7 @@ mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq,
 	return true;
 }
 
+#ifdef CONFIG_PM
 static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 				    struct cfg80211_wowlan *wowlan)
 {
@@ -2602,8 +2602,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.suspend = mwifiex_cfg80211_suspend,
 	.resume = mwifiex_cfg80211_resume,
 	.set_wakeup = mwifiex_cfg80211_set_wakeup,
-	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 #endif
+	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 };
 
 #ifdef CONFIG_PM
-- 
1.8.2.3

