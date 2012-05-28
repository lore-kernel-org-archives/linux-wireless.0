Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64704 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2E1LTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:36 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 01/14] cfg80211: respect intf combinations for 1 interface
Date: Mon, 28 May 2012 13:18:49 +0200
Message-ID: <1338203942-5667-2-git-send-email-michal.kazior@tieto.com> (sfid-20120528_132048_650584_3B3386CF)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't ignore interface combinations when only one
interface is up. Otherwise we may call a driver to
create (or change) interface type to something it
didn't report in interface combinations it
reported.

Change-Id: If0934c7a835ffd29f30b9343ec0e0a3e51bb0b69
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 177df03..147f283 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -965,7 +965,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
-	if (total == 1)
+	if (total == 1 && rdev->wiphy.n_iface_combinations == 0)
 		return 0;
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
-- 
1.7.0.4

