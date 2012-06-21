Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3094 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab2FUNt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:49:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: [PATCH] brcmsmac: fix NULL pointer crash in brcms_c_regd_init()
Date: Thu, 21 Jun 2012 15:49:13 +0200
Message-ID: <1340286553-12053-1-git-send-email-arend@broadcom.com> (sfid-20120621_155001_233564_A47F7CD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the function brcms_c_regd_init() the channels are validated
against the device capabilities. This is done for both 2.4G and
5G band, but there are devices that are 2.4G only, ie. BCM4313.
For that device this leads to a NULL dereference. This patch adds
a check in brcms_c_regd_init() to fix this.

Issue introduced in wireless-next tree by following commit:
cf03c5d brcm80211: smac: inform mac80211 of the X2 regulatory domain

Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Noticed that one of smoketest machines actually was not sending results
ever since I staged regulatory fixes for it. This particular system has
a 2.4G card fitted so the root cause was quickly found.

Gr. AvS
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index d3c7260..2d365d3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -768,6 +768,11 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
 			band = wlc->bandstate[BAND_2G_INDEX];
 		else
 			band = wlc->bandstate[BAND_5G_INDEX];
+
+		/* skip if band not initialized */
+		if (band->pi == NULL)
+			continue;
+
 		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
 					      &sup_chan);
 
-- 
1.7.9.5


