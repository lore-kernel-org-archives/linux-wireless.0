Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58636 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1KSLEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 06:04:13 -0500
Subject: [PATCH 2/5] rndis_wlan: pass channel info to cfg80211_roamed()
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 19 Nov 2011 13:04:11 +0200
Message-ID: <20111119110410.11950.8073.stgit@localhost6.localdomain6> (sfid-20111119_120431_823873_A75C4D3E)
In-Reply-To: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
References: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_roamed() now has channel parameter so add passing current channel
info.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 37c4c40..d5bfc8d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2854,8 +2854,9 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 						req_ie_len, resp_ie,
 						resp_ie_len, 0, GFP_KERNEL);
 		else
-			cfg80211_roamed(usbdev->net, NULL, bssid,
-					req_ie, req_ie_len,
+			cfg80211_roamed(usbdev->net,
+					get_current_channel(usbdev, NULL),
+					bssid, req_ie, req_ie_len,
 					resp_ie, resp_ie_len, GFP_KERNEL);
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);

