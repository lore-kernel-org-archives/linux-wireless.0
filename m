Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52268 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab3GLLY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 07:24:28 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so8526025pdj.17
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 04:24:27 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] iw: print out mesh configuration element on scan
Date: Fri, 12 Jul 2013 19:17:06 +0800
Message-Id: <1373627826-20095-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130712_132438_571196_5E2F7E64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print out mesh configuration element which will be useful for
decision making whether to join or not join the mesh network.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 scan.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 6d770d3..4fb0f23 100644
--- a/scan.c
+++ b/scan.c
@@ -787,6 +787,37 @@ static void print_bss_load(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\t\t * available admission capacity: %d [*32us]\n", (data[4] << 8) | data[3]);
 }
 
+static void print_mesh_conf(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	printf("\n");
+	printf("\t\t * Active Path Selection Protocol ID: %d\n", data[0]);
+	printf("\t\t * Active Path Selection Metric ID: %d\n", data[1]);
+	printf("\t\t * Congestion Control Mode ID: %d\n", data[2]);
+	printf("\t\t * Synchronization Method ID: %d\n", data[3]);
+	printf("\t\t * Authentication Protocol ID: %d\n", data[4]);
+	printf("\t\t * Mesh Formation Info:\n");
+	printf("\t\t\t Number of Peerings: %d\n", (data[5] & 0x7E) >> 1);
+	if (data[5] & 0x01)
+		printf("\t\t\t Connected to Mesh Gate\n");
+	if (data[5] & 0x80)
+		printf("\t\t\t Connected to AS\n");
+	printf("\t\t * Mesh Capability\n");
+	if (data[6] & 0x01)
+		printf("\t\t\t Accepting Additional Mesh Peerings\n");
+	if (data[6] & 0x02)
+		printf("\t\t\t MCCA Supported\n");
+	if (data[6] & 0x04)
+		printf("\t\t\t MCCA Enabled\n");
+	if (data[6] & 0x08)
+		printf("\t\t\t Forwarding\n");
+	if (data[6] & 0x10)
+		printf("\t\t\t MBCA Supported\n");
+	if (data[6] & 0x20)
+		printf("\t\t\t TBTT Adjusting\n");
+	if (data[6] & 0x40)
+		printf("\t\t\t Mesh Power Save Level\n");
+}
+
 struct ie_print {
 	const char *name;
 	void (*print)(const uint8_t type, uint8_t len, const uint8_t *data);
@@ -846,6 +877,7 @@ static const struct ie_print ieprinters[] = {
 	[192] = { "VHT operation", print_vht_oper, 5, 255, BIT(PRINT_SCAN), },
 	[48] = { "RSN", print_rsn, 2, 255, BIT(PRINT_SCAN), },
 	[50] = { "Extended supported rates", print_supprates, 0, 255, BIT(PRINT_SCAN), },
+	[113] = { "MESH Configuration", print_mesh_conf, 7, 7, BIT(PRINT_SCAN), },
 	[114] = { "MESH ID", print_ssid, 0, 32, BIT(PRINT_SCAN) | BIT(PRINT_LINK), },
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
 };
-- 
1.7.0.4

