Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62631 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab2FTGO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:29 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 08/13] cfg80211: refuse to .set_monitor_channel when non-monitors are present
Date: Wed, 20 Jun 2012 08:14:14 +0200
Message-ID: <1340172859-18146-9-git-send-email-michal.kazior@tieto.com> (sfid-20120620_081457_417405_D0385192)
In-Reply-To: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having .set_monitor_channel work with non-monitor
interfaces running would make interface
combinations accounting ambiguous.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/chan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 167e7cb..019401b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -85,6 +85,8 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 
 	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
+	if (!cfg80211_has_monitors_only(rdev))
+		return -EBUSY;
 
 	chan = rdev_freq_to_chan(rdev, freq, chantype);
 	if (!chan)
-- 
1.7.0.4

