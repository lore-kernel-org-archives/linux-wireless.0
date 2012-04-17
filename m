Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42692 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2DQOkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 10:40:31 -0400
From: <Piotr.Nakraszewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Date: Tue, 17 Apr 2012 17:40:17 +0300
Subject: [RFC] mac80211: Advertise dtim period to all drivers
Message-ID: <E50901D4F2CF69428D43141B7C85867929CC14EA67@EXMB03.eu.tieto.com> (sfid-20120417_164035_359369_44106D76)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Don't look for IEEE80211_HW_NEED_DTIM_PERIOD flag after association finishes and advertise DTIM period to all drivers.

Signed-off-by: Piotr Nakraszewicz <piotr.nakraszewicz@tieto.com>
---
 include/net/mac80211.h |    4 +---
 net/mac80211/mlme.c    |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bebd89f..436267f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -230,9 +230,7 @@ enum ieee80211_rssi_event {
  *	if the hardware cannot handle this it must set the
  *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
- *	valid in station mode only while @assoc is true and if also
- *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
- *	@ps_dtim_period)
+ *	valid in station mode only while @assoc is true
  * @last_tsf: last beacon's/probe response's TSF timestamp (could be old
  *	as it may have been received during scanning long ago)
  * @beacon_int: beacon interval
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8836fa..39e0912 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1290,11 +1290,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
-	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		bss_conf->dtim_period = bss->dtim_period;
-	else
-		bss_conf->dtim_period = 0;
-
+	bss_conf->dtim_period = bss->dtim_period;
 	bss_conf->assoc = 1;
 
 	/* Tell the driver to monitor connection quality (if supported) */
-- 
1.7.0.4


IEEE80211_HW_NEED_DTIM_PERIOD description says:
*	This device needs to know the DTIM period for the BSS before
*	associating.

This patch is helpful for drivers that don't need to know DTIM period before association, but need it after association for power save reasons and can't accept roaming delays.

I can see that I am not the only one that had such problems:
http://article.gmane.org/gmane.linux.kernel.wireless.general/60959
http://article.gmane.org/gmane.linux.kernel.wireless.general/62266

Pozdrawiam / Best regards,
Piotr

