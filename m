Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:62360 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHKSv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 14:51:26 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so9079962wes.16
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 11:51:25 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ipw2x00: ipw2200.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Mon, 11 Aug 2014 20:52:56 +0200
Message-Id: <1407783176-31297-2-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140811_205223_111557_87B9F80A)
In-Reply-To: <1407783176-31297-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1407783176-31297-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index c5aa404..5fb1b5d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -5552,7 +5552,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 			    min(network->ssid_len, priv->essid_len)))) {
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 
-			strncpy(escaped,
+			strlcpy(escaped,
 				print_ssid(ssid, network->ssid,
 					   network->ssid_len),
 				sizeof(escaped));
@@ -5765,7 +5765,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 		     memcmp(network->ssid, priv->essid,
 			    min(network->ssid_len, priv->essid_len)))) {
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-			strncpy(escaped,
+			strlcpy(escaped,
 				print_ssid(ssid, network->ssid,
 					   network->ssid_len),
 				sizeof(escaped));
@@ -5782,7 +5782,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	 * testing everything else. */
 	if (match->network && match->network->stats.rssi > network->stats.rssi) {
 		char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-		strncpy(escaped,
+		strlcpy(escaped,
 			print_ssid(ssid, network->ssid, network->ssid_len),
 			sizeof(escaped));
 		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded because "
-- 
1.7.10.4

