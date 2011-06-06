Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51024 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810Ab1FFTbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 15:31:09 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so1454026eyg.25
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 12:31:07 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: stable@kernel.org
Cc: gregkh@suse.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH stable] nl80211: fix check for valid SSID size in scan operations
Date: Mon,  6 Jun 2011 22:30:56 +0300
Message-Id: <1307388656-19240-1-git-send-email-coelho@ti.com> (sfid-20110606_213113_997141_9310118F)
In-Reply-To: <13073811693022@kroah.org>
References: <13073811693022@kroah.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In both trigger_scan and sched_scan operations, we were checking for
the SSID length before assigning the value correctly.  Since the
memory was just kzalloc'ed, the check was always failing and SSID with
over 32 characters were allowed to go through.

This was causing a buffer overflow when copying the actual SSID to the
proper place.

This bug has been there since 2.6.29-rc4.

Backported from commit 208c72f4fe44fe09577e7975ba0e7fa0278f3d03.

Cc: stable@kernel.org
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/nl80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2c70a1e..29a1ce1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3239,12 +3239,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
-- 
1.7.1

