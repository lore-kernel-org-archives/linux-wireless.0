Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:42505 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932601AbdDGLwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 07:52:01 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Use new format for configuring firmware
Date: Fri, 7 Apr 2017 17:21:43 +0530
Message-ID: <1491565903-9196-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170407_135218_690529_9D689F8B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configuration packet format has changed in the newer wilc
firmware versions 14.2 and up. This update ensures that the
firmware is initialized correctly by the host and configured
in the required mode.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 59 +++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 926fc16..d3e5b1b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -175,8 +175,9 @@ static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, u16 id, u8 val8)
 	buf[0] = (u8)id;
 	buf[1] = (u8)(id >> 8);
 	buf[2] = 1;
-	buf[3] = val8;
-	return 4;
+	buf[3] = 0;
+	buf[4] = val8;
+	return 5;
 }
 
 static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset, u16 id, u16 val16)
@@ -191,10 +192,11 @@ static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset, u16 id, u16 val16)
 	buf[0] = (u8)id;
 	buf[1] = (u8)(id >> 8);
 	buf[2] = 2;
-	buf[3] = (u8)val16;
-	buf[4] = (u8)(val16 >> 8);
+	buf[3] = 0;
+	buf[4] = (u8)val16;
+	buf[5] = (u8)(val16 >> 8);
 
-	return 5;
+	return 6;
 }
 
 static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32)
@@ -209,19 +211,20 @@ static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32)
 	buf[0] = (u8)id;
 	buf[1] = (u8)(id >> 8);
 	buf[2] = 4;
-	buf[3] = (u8)val32;
-	buf[4] = (u8)(val32 >> 8);
-	buf[5] = (u8)(val32 >> 16);
-	buf[6] = (u8)(val32 >> 24);
+	buf[3] = 0;
+	buf[4] = (u8)val32;
+	buf[5] = (u8)(val32 >> 8);
+	buf[6] = (u8)(val32 >> 16);
+	buf[7] = (u8)(val32 >> 24);
 
-	return 7;
+	return 8;
 }
 
 static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str, u32 size)
 {
 	u8 *buf;
 
-	if ((offset + size + 3) >= MAX_CFG_FRAME_SIZE)
+	if ((offset + size + 4) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
@@ -229,11 +232,12 @@ static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str, u32 siz
 	buf[0] = (u8)id;
 	buf[1] = (u8)(id >> 8);
 	buf[2] = (u8)size;
+	buf[3] = (u8)(size >> 8);
 
 	if ((str) && (size != 0))
-		memcpy(&buf[3], str, size);
+		memcpy(&buf[4], str, size);
 
-	return (size + 3);
+	return (size + 4);
 }
 
 static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
@@ -284,12 +288,12 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_byte[i].id == wid) {
-					g_cfg_byte[i].val = info[3];
+					g_cfg_byte[i].val = info[4];
 					break;
 				}
 				i++;
 			} while (1);
-			len = 2;
+			len = 3;
 			break;
 
 		case WID_SHORT:
@@ -298,12 +302,14 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_hword[i].id == wid) {
-					g_cfg_hword[i].val = cpu_to_le16(info[3] | (info[4] << 8));
+					g_cfg_hword[i].val =
+						cpu_to_le16(info[4] |
+							    (info[5] << 8));
 					break;
 				}
 				i++;
 			} while (1);
-			len = 3;
+			len = 4;
 			break;
 
 		case WID_INT:
@@ -312,12 +318,16 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_word[i].id == wid) {
-					g_cfg_word[i].val = cpu_to_le32(info[3] | (info[4] << 8) | (info[5] << 16) | (info[6] << 24));
+					g_cfg_word[i].val =
+						cpu_to_le32(info[4] |
+							    (info[5] << 8) |
+							    (info[6] << 16) |
+							    (info[7] << 24));
 					break;
 				}
 				i++;
 			} while (1);
-			len = 5;
+			len = 6;
 			break;
 
 		case WID_STR:
@@ -332,12 +342,13 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 						i += toggle;
 						toggle ^= 1;
 					}
-					memcpy(g_cfg_str[i].str, &info[2], (info[2] + 1));
+					memcpy(g_cfg_str[i].str, &info[2],
+					       (info[2] + 2));
 					break;
 				}
 				i++;
 			} while (1);
-			len = 1 + info[2];
+			len = 2 + info[2];
 			break;
 
 		default:
@@ -475,7 +486,8 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 				break;
 
 			if (g_cfg_str[i].id == wid) {
-				u32 size =  g_cfg_str[i].str[0];
+				u32 size = g_cfg_str[i].str[0] |
+						(g_cfg_str[i].str[1] << 8);
 
 				if (buffer_size >= size) {
 					if (g_cfg_str[i].id == WID_SITE_SURVEY_RESULTS)	{
@@ -485,7 +497,8 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 						toggle ^= 1;
 
 					}
-					memcpy(buffer,  &g_cfg_str[i].str[1], size);
+					memcpy(buffer,  &g_cfg_str[i].str[2],
+					       size);
 					ret = size;
 				}
 				break;
-- 
2.7.4
