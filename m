Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38110 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYJAToI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 15:44:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: avoid "Wireless Event too big" message for assoc response
Date: Wed,  1 Oct 2008 15:45:02 -0400
Message-Id: <1222890302-32486-1-git-send-email-linville@linville-t61.local> (sfid-20081001_214412_014259_11BBE431)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

The association response IEs are sent to userland with an IWEVCUSTOM
event, which unfortunately is limited to a little more than 100 bytes
of IE information with the encoding used.  Many APs send so much
IE information that this message overflows.  When the IWEVCUSTOM
event is too large, the kernel doesn't send it to userland anyway --
better just not to send it.

An attempt was made by Jouni Malinen to correct this issue by
converting to use IWEVASSOCREQIE and IWEVASSOCRESPIE messages instead
("mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM").  Unfortunately,
that caused a problem due to 32-/64-bit interactions on some systems and
was reverted after the 'userland ABI' rule was invoked.  That leaves
us with this option instead of a proper fix, at least until we move
to a cfg80211-based solution.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/mlme.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 902cac1..7a8f0a8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -518,9 +518,11 @@ static void ieee80211_sta_send_associnfo(struct net_device *dev,
 		}
 	}
 
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.data.length = len;
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+	if (len <= IW_CUSTOM_MAX) {
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = len;
+		wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+	}
 
 	kfree(buf);
 }
-- 
1.5.5.1

