Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54141 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbaHRJUw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 05:20:52 -0400
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marc Yang <yangyang@marvell.com>, Xinming Hu <huxm@marvell.com>
Date: Mon, 18 Aug 2014 02:19:34 -0700
Subject: [PATCH 4/4] mwifiex: fix association failure in 5G after leaving
 2.4G IBSS
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147C24@SC-VEXCH2.marvell.com> (sfid-20140818_112056_116430_120CBDE6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When assocaiting to an AP , mwifiex set supported data rates
based on target AP's capability. For 5G AP(11a mode), a/n/ac mode
would possibly be set.
However, for some chips which dont support 11AC mode current config_bands
will be used instead.

For example, if we join an IBSS in 11b mode ,adapter->config_bands
will be set to 1(11b mode). Then we leave IBSS ,and try to connect
5G a/n mode AP. At this time , only 11b mode data rates will be
supported in assoc request , which result in assoc failure with
reason code 18: Association denied due to requesting station not 
supporting all rates.

This patch fix such a cornel case, by adding additional check for 
current chip's 11ac capability.

Reported-by: Andreas Fenkart <afenkart@gmail.com>                                                                                                                                                                                                                             
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index caae973..0b998fd 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -287,10 +287,13 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
                        return -1; 
 
                if (mwifiex_band_to_radio_type(bss_desc->bss_band) ==
-                                               HostCmd_SCAN_RADIO_TYPE_BG)
+                                               HostCmd_SCAN_RADIO_TYPE_BG) {
                        config_bands = BAND_B | BAND_G | BAND_GN;
-               else
-                       config_bands = BAND_A | BAND_AN | BAND_AAC;
+               } else {
+                       config_bands = BAND_A | BAND_AN;
+                       if (adapter->fw_bands & BAND_AAC)
+                               config_bands |= BAND_AAC;
+               }
 
                if (!((config_bands | adapter->fw_bands) & ~adapter->fw_bands))
                        adapter->config_bands = config_bands;
-- 
1.8.1.4
