Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:40291 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752673AbeEKIPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:15:01 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 20/30] staging: wilc1000: fix line over 80 chars in scan()
Date: Fri, 11 May 2018 13:43:21 +0530
Message-ID: <1526026411-11058-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101508_650146_D00BBD0A)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issues found by checkpatch.pl script with
the help of local variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b67a170..e64e944 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -636,8 +636,11 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->cfg_scanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
-		for (i = 0; i < request->n_channels; i++)
-			scan_ch_list[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
+		for (i = 0; i < request->n_channels; i++) {
+			u16 freq = request->channels[i]->center_freq;
+
+			scan_ch_list[i] = ieee80211_frequency_to_channel(freq);
+		}
 
 		if (request->n_ssids >= 1) {
 			if (wilc_wfi_cfg_alloc_fill_ssid(request,
-- 
2.7.4
