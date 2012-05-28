Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab2E1LTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 09/14] cfg80211: refuse to .set_monitor_channel when non-monitors are present
Date: Mon, 28 May 2012 13:18:57 +0200
Message-ID: <1338203942-5667-10-git-send-email-michal.kazior@tieto.com> (sfid-20120528_131954_700963_B6DFB74E)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having .set_monitor_channel work with non-monitor
interfaces running would make interface
combinations accounting ambiguous.

Change-Id: I2d579b483fe3c2998c50dcf89600740188f79733
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/chan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 45b28ab..4d71b38 100644
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

