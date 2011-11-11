Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1KKPEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 10:04:25 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <j@w1.fi>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH] wpa_supplicant: Set configured auth_algs
Date: Fri, 11 Nov 2011 20:32:21 +0530
Message-ID: <1321023741-32760-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111111_160433_209403_538A7995)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In Ap mode, Authentication algorithm is reset in hostapd_config_defaults_bss() and
never be set to the configured one. This would pass the default
auth_algs (OPEN|SHARED) to driver and cause authentication isseues.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 wpa_supplicant/ap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/wpa_supplicant/ap.c b/wpa_supplicant/ap.c
index d08fc7c..dada412 100644
--- a/wpa_supplicant/ap.c
+++ b/wpa_supplicant/ap.c
@@ -140,6 +140,9 @@ static int wpa_supplicant_conf_ap(struct wpa_supplicant *wpa_s,
 	bss->ssid.ssid_len = ssid->ssid_len;
 	bss->ssid.ssid_set = 1;
 
+	if (ssid->auth_alg)
+		bss->auth_algs = ssid->auth_alg;
+
 	if (wpa_key_mgmt_wpa_psk(ssid->key_mgmt))
 		bss->wpa = ssid->proto;
 	bss->wpa_key_mgmt = ssid->key_mgmt;
-- 
1.7.0.4

