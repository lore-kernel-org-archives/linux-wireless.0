Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41468 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1KSLES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 06:04:18 -0500
Subject: [PATCH 3/5] rndis_wlan: add missing __packed
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 19 Nov 2011 13:04:16 +0200
Message-ID: <20111119110416.11950.65162.stgit@localhost6.localdomain6> (sfid-20111119_120432_436813_1D0D93C3)
In-Reply-To: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
References: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some structures were missing __packed.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d5bfc8d..08c85af 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -387,13 +387,13 @@ struct ndis_80211_capability {
 struct ndis_80211_bssid_info {
 	u8 bssid[6];
 	u8 pmkid[16];
-};
+} __packed;
 
 struct ndis_80211_pmkid {
 	__le32 length;
 	__le32 bssid_info_count;
 	struct ndis_80211_bssid_info bssid_info[0];
-};
+} __packed;
 
 /*
  *  private data

