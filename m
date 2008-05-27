Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112]:61927 "EHLO
	smtp2.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYE0IPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 04:15:05 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: use ARRAY_SIZE instead of sizeof when adding
	11g rates
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Scott Ashcroft <scott.ashcroft@talk21.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 27 May 2008 11:15:02 +0300
Message-ID: <20080527081502.15936.68708.stgit@fate.lan> (sfid-20080527_101510_823954_B2263E54)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Scott Ashcroft <scott.ashcroft@talk21.com>

While figuring out the TKIP problem I found a bug in the code which adds the 11g 
rates. It's using sizeof instead of ARRAY_SIZE to terminate the for loop. This makes 
it fall off the end of the rates array start into the frequency array instead. Running 
"iwlist rate" should show the problem as there will always be 32 rates with the last 
few being bogus.

The following patch will fix it.

Signed-off-by: Scott Ashcroft <scott.ashcroft@talk21.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d0b1fb1..ed310f8 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1108,7 +1108,7 @@ static int rndis_iw_get_range(struct net_device *dev,
 	/* fill in 802.11g rates */
 	if (has_80211g_rates) {
 		num = range->num_bitrates;
-		for (i = 0; i < sizeof(rates_80211g); i++) {
+		for (i = 0; i < ARRAY_SIZE(rates_80211g); i++) {
 			for (j = 0; j < num; j++) {
 				if (range->bitrate[j] ==
 					rates_80211g[i] * 1000000)

