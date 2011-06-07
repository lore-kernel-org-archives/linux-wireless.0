Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34509 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab1FGRmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 13:42:36 -0400
Received: by eyh6 with SMTP id 6so2445155eyh.22
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 10:42:33 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ido@wizery.com,
	johannes@sipsolutions.net
Subject: [PATCH 3.0] nl80211: fix overflow in ssid_len
Date: Tue,  7 Jun 2011 20:42:26 +0300
Message-Id: <1307468546-16915-1-git-send-email-coelho@ti.com> (sfid-20110607_194239_505993_63EF6A86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When one of the SSID's length passed in a scan or sched_scan request
is larger than 255, there will be an overflow in the u8 that is used
to store the length before checking.  This causes the check to fail
and we overrun the buffer when copying the SSID.

Fix this by checking the nl80211 attribute length before copying it to
the struct.

This is a follow up for the previous commit
208c72f4fe44fe09577e7975ba0e7fa0278f3d03, which didn't fix the problem
entirely.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/nl80211.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1c57036..c859f50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3412,11 +3412,11 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
-			request->ssids[i].ssid_len = nla_len(attr);
-			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
+			request->ssids[i].ssid_len = nla_len(attr);
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
 			i++;
 		}
@@ -3578,12 +3578,11 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp) {
-			request->ssids[i].ssid_len = nla_len(attr);
-			if (request->ssids[i].ssid_len >
-			    IEEE80211_MAX_SSID_LEN) {
+			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
+			request->ssids[i].ssid_len = nla_len(attr);
 			memcpy(request->ssids[i].ssid, nla_data(attr),
 			       nla_len(attr));
 			i++;
-- 
1.7.1

