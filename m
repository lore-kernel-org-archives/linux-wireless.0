Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52945 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAGP5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:57:47 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so1937983wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 07:57:46 -0800 (PST)
Received: from muse.ger.corp.intel.com (93-172-181-114.bb.netvision.net.il. [93.172.181.114])
        by mx.google.com with ESMTPSA id o1sm2567110wjf.41.2015.01.07.07.50.20
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Jan 2015 07:50:20 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
Date: Wed,  7 Jan 2015 17:50:11 +0200
Message-Id: <1420645811-17877-3-git-send-email-eliad@wizery.com> (sfid-20150107_165751_047632_1A139663)
In-Reply-To: <1420645811-17877-1-git-send-email-eliad@wizery.com>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radar detection can last indefinite time. There is no
point in deferring a scan request in this case - simply
return -EBUSY.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2: use the newly introduced funcion

 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index cdd8258..4bee1f97 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -505,7 +505,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->scan_req)
+	if (local->scan_req || ieee80211_is_radar_required(local))
 		return -EBUSY;
 
 	if (!ieee80211_can_scan(local, sdata)) {
-- 
1.8.5.2.229.g4448466.dirty

