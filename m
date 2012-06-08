Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54085 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab2FHI4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 04:56:03 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: check iface combinations only when iface is running
Date: Fri, 8 Jun 2012 10:55:44 +0200
Message-ID: <1339145744-9154-1-git-send-email-michal.kazior@tieto.com> (sfid-20120608_105612_783135_D69D0F90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't validate interface combinations on a stopped
interface. Otherwise we might end up being able to
create a new interface with a certain type, but
won't be able to change an existing interface
into that type.

This also skips some other functions when
interface is stopped and changing interface type.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 147f283..eb7ca3c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -805,7 +805,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
-	if (ntype != otype) {
+	if (ntype != otype && netif_running(dev)) {
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
 		if (err)
-- 
1.7.0.4

