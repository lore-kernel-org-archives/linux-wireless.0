Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYCIVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:48 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:47 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 05/24] rt2x00: never disable multicast because it disables broadcast too
Date: Sun, 9 Mar 2008 22:40:40 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092240.41033.IvDoorn@gmail.com> (sfid-20080309_215052_146295_0ED9F7ED)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

On rt73 and rt61 disabling reception of multicast packets also disables
broadcast traffic which we never want to do. Therefore we should never
disable multicast.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 091fe39..9ff7e60 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2298,9 +2298,9 @@ static void rt61pci_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
+	 * - Multicast filter seems to kill broadcast traffic so never use it.
 	 */
-	if (mc_count)
-		*total_flags |= FIF_ALLMULTI;
+	*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a48c82f..77bdef8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1889,9 +1889,9 @@ static void rt73usb_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
+	 * - Multicast filter seems to kill broadcast traffic so never use it.
 	 */
-	if (mc_count)
-		*total_flags |= FIF_ALLMULTI;
+	*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-- 
1.5.4.3

