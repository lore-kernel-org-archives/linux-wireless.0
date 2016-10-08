Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35412 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753171AbcJHNli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Oct 2016 09:41:38 -0400
Received: by mail-pf0-f194.google.com with SMTP id t25so4446439pfg.2
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2016 06:41:38 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
        Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] Report scan_abort as part of iw phy
Date: Sat,  8 Oct 2016 15:40:36 +0200
Message-Id: <1475934036-5981-1-git-send-email-ola1olsson@gmail.com> (sfid-20161008_154142_418475_EFF09840)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211: abort_scan has not been reported under the 'Supported commands'
category when calling iw phy. Add that.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 95d55d2..0bbce4f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1526,6 +1526,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
 		CMD(mgmt_tx, FRAME);
 		CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
+		CMD(abort_scan, ABORT_SCAN);
 		if (rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 			i++;
 			if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
-- 
2.7.4
