Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:46250 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYFLTep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 15:34:45 -0400
Date: Thu, 12 Jun 2008 15:34:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
cc: linville@tuxdriver.com
Subject: [PATCH] WIRELESS: Use kernel-supplied ARRAY_SIZE() macro.
Message-ID: <alpine.LFD.1.10.0806121529270.30641@localhost.localdomain> (sfid-20080612_213449_781793_1EDD4C23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  compile-tested on x86.


 drivers/net/wireless/rndis_wlan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 18c9931..daaf2f7 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -620,8 +620,7 @@ static void dsconfig_to_freq(unsigned int dsconfig, struct iw_freq *freq)
 static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
 {
 	if (freq->m < 1000 && freq->e == 0) {
-		if (freq->m >= 1 &&
-			freq->m <= (sizeof(freq_chan) / sizeof(freq_chan[0])))
+		if (freq->m >= 1 && freq->m <= ARRAY_SIZE(freq_chan))
 			*dsconfig = freq_chan[freq->m - 1] * 1000;
 		else
 			return -1;
@@ -1159,10 +1158,9 @@ static int rndis_iw_get_range(struct net_device *dev,
 		range->throughput = 11 * 1000 * 1000 / 2;
 	}

-	range->num_channels = (sizeof(freq_chan)/sizeof(freq_chan[0]));
+	range->num_channels = ARRAY_SIZE(freq_chan);

-	for (i = 0; i < (sizeof(freq_chan)/sizeof(freq_chan[0])) &&
-			i < IW_MAX_FREQUENCIES; i++) {
+	for (i = 0; i < ARRAY_SIZE(freq_chan) && i < IW_MAX_FREQUENCIES; i++) {
 		range->freq[i].i = i + 1;
 		range->freq[i].m = freq_chan[i] * 100000;
 		range->freq[i].e = 1;

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
