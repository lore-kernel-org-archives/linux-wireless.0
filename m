Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3390 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab2HXMnn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 08:43:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] wext: include wireless event id when it has a size
 problem
Date: Fri, 24 Aug 2012 14:43:31 +0200
Message-ID: <1345812212-18778-1-git-send-email-arend@broadcom.com> (sfid-20120824_144347_019489_948E84F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wext code checks is the event data is within size limits.
When this check fails a message is logged with violating size.
This patch adds the event id to put us on the right track for
resolving that violation.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Maybe wext is not popular, but I found the change helpful debugging
so others may benefit from it. Still some wireless apps default to
it, eg. wpa_supplicant.

Gr. AvS
---
 net/wireless/wext-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index b0eb7aa..c8717c1 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -478,13 +478,13 @@ void wireless_send_event(struct net_device *	dev,
 	if (descr->header_type == IW_HEADER_TYPE_POINT) {
 		/* Check if number of token fits within bounds */
 		if (wrqu->data.length > descr->max_tokens) {
-			netdev_err(dev, "(WE) : Wireless Event too big (%d)\n",
-				   wrqu->data.length);
+			netdev_err(dev, "(WE) : Wireless Event (cmd=0x%04X) too big (%d)\n",
+				   cmd, wrqu->data.length);
 			return;
 		}
 		if (wrqu->data.length < descr->min_tokens) {
-			netdev_err(dev, "(WE) : Wireless Event too small (%d)\n",
-				   wrqu->data.length);
+			netdev_err(dev, "(WE) : Wireless Event (cmd=0x%04X) too small (%d)\n",
+				   cmd, wrqu->data.length);
 			return;
 		}
 		/* Calculate extra_len - extra is NULL for restricted events */
-- 
1.7.9.5


