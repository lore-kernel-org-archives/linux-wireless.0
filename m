Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37151 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754607AbeBPPMY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:24 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/12] staging: wilc1000: fix line over 80 chars in wilc_wlan_cfg_get_wid_value()
Date: Fri, 16 Feb 2018 20:41:45 +0530
Message-ID: <1518793909-15573-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161229_847737_FA8A8CBA)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 character" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index ab69bac..2b44f4c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -484,15 +484,17 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 		} while (1);
 	} else if (type == CFG_STR_CMD) {
 		do {
-			if (g_cfg_str[i].id == WID_NIL)
+			u32 id = g_cfg_str[i].id;
+
+			if (id == WID_NIL)
 				break;
 
-			if (g_cfg_str[i].id == wid) {
+			if (id == wid) {
 				u32 size = g_cfg_str[i].str[0] |
 						(g_cfg_str[i].str[1] << 8);
 
 				if (buffer_size >= size) {
-					if (g_cfg_str[i].id == WID_SITE_SURVEY_RESULTS)	{
+					if (id == WID_SITE_SURVEY_RESULTS) {
 						static int toggle;
 
 						i += toggle;
-- 
2.7.4
