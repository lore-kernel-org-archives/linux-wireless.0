Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYJ2Lua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:50:30 -0400
Subject: [PATCH] libertas: fix buffer overrun
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 11:43:32 +0100
Message-Id: <1225277012.5439.0.camel@johannes.berg> (sfid-20081029_125042_603863_90BE3C56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If somebody sends an invalid beacon/probe response, that can trash the
whole BSS descriptor. The descriptor is, luckily, large enough so that
it cannot scribble past the end of it; it's well above 400 bytes long.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.24-2.6.27, bug present in some form since driver was added (2.6.22)]
---
Not really tested for lack of hw.

John, this is part of the other patch I sent, but this one's
for 2.6.28.

The function there needs to be reviewed more, it seems to access
potentially invalid memory when an AP sends other, too short,
information elements.

--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -598,8 +598,8 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 
 		switch (elem->id) {
 		case MFIE_TYPE_SSID:
-			bss->ssid_len = elem->len;
-			memcpy(bss->ssid, elem->data, elem->len);
+			bss->ssid_len = min_t(int, 32, elem->len);
+			memcpy(bss->ssid, elem->data, bss->ssid_len);
 			lbs_deb_scan("got SSID IE: '%s', len %u\n",
 			             escape_essid(bss->ssid, bss->ssid_len),
 			             bss->ssid_len);


