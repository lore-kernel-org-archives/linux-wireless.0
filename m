Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AGWYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:24:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] hostapd: add country IE debugging options
Date: Thu,  7 Jan 2010 17:24:49 -0500
Message-Id: <1262903089-1958-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you want to debug parsing of country IEs on your
client you can enable the CONFIG_COUNTRY_DBG and then
select the desired triplet. We add four tests cases you
can use.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Jouni, not sure if this is useful to you but it certainly
helped me debug country IE stuff.

 hostapd/Makefile |    4 ++
 src/ap/beacon.c  |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/hostapd/Makefile b/hostapd/Makefile
index d94ceb9..87b0dcc 100644
--- a/hostapd/Makefile
+++ b/hostapd/Makefile
@@ -157,6 +157,10 @@ ifdef CONFIG_IEEE80211N
 CFLAGS += -DCONFIG_IEEE80211N
 endif
 
+ifdef CONFIG_COUNTRY_DBG
+CFLAGS += -DCONFIG_COUNTRY_DBG
+endif
+
 include ../src/drivers/drivers.mak
 OBJS += $(DRV_AP_OBJS)
 CFLAGS += $(DRV_AP_CFLAGS)
diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index dbb6926..b35a46a 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -98,6 +98,81 @@ static u8 * hostapd_eid_erp_info(struct hostapd_data *hapd, u8 *eid)
 	return eid;
 }
 
+#ifdef CONFIG_COUNTRY_DBG
+struct triplet_chan {
+	u8 first_channel;
+	u8 num_channels;
+	s8 max_power;
+} __attribute__ ((packed));
+
+struct triplet_band {
+	u8 num_triplets;
+	struct triplet_chan triplets[];
+} __attribute__ ((packed));
+
+#define TRIPLET(_start, _num_chan, _power) \
+{ \
+	.first_channel = _start, \
+	.num_channels = _num_chan, \
+	.max_power = _power, \
+}
+
+static const struct triplet_band triplet_01 = {
+	.num_triplets = 4,
+	.triplets = {
+		TRIPLET(1, 1, 20),
+		TRIPLET(2, 1, 20),
+		TRIPLET(36, 1, 20),
+		TRIPLET(40, 1, 20),
+	}
+};
+
+static const struct triplet_band triplet_02 = {
+	.num_triplets = 5,
+	.triplets = {
+		TRIPLET(1, 1, 20), /* [1] */
+		TRIPLET(2, 3, 20), /* [2-4] */
+		TRIPLET(5, 8, 20), /* [5-12] */
+		TRIPLET(36, 1, 20), /* [36] */
+		TRIPLET(40, 2, 20), /* [40-44] */
+	}
+};
+
+static const struct triplet_band triplet_03 = {
+	.num_triplets = 4,
+	.triplets = {
+		TRIPLET(1, 4, 20), /* [1-4] */
+		TRIPLET(5, 3, 20), /* [5-7] 2432-2452 */
+		TRIPLET(36, 3, 20), /* [36-44] 5170-5230 */
+		TRIPLET(48, 5, 20), /* [48-64] 5230-5330 */
+	}
+};
+
+static const struct triplet_band triplet_04 = {
+	.num_triplets = 19,
+	.triplets = {
+		TRIPLET(36, 1, 20),
+		TRIPLET(40, 1, 20),
+		TRIPLET(44, 1, 20),
+		TRIPLET(48, 1, 20),
+		TRIPLET(52, 1, 20),
+		TRIPLET(56, 1, 20),
+		TRIPLET(60, 1, 20),
+		TRIPLET(64, 1, 20),
+		TRIPLET(100, 1, 20),
+		TRIPLET(104, 1, 20),
+		TRIPLET(108, 1, 20),
+		TRIPLET(112, 1, 20),
+		TRIPLET(116, 1, 20),
+		TRIPLET(120, 1, 20),
+		TRIPLET(124, 1, 20),
+		TRIPLET(128, 1, 20),
+		TRIPLET(132, 1, 20),
+		TRIPLET(136, 1, 20),
+		TRIPLET(140, 1, 20),
+	}
+};
+#else
 
 static u8 * hostapd_eid_country_add(u8 *pos, u8 *end, int chan_spacing,
 				    struct hostapd_channel_data *start,
@@ -115,7 +190,7 @@ static u8 * hostapd_eid_country_add(u8 *pos, u8 *end, int chan_spacing,
 
 	return pos;
 }
-
+#endif
 
 static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
 				int max_len)
@@ -124,7 +199,11 @@ static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
 	u8 *end = eid + max_len;
 	int i;
 	struct hostapd_hw_modes *mode;
+#ifndef CONFIG_COUNTRY_DBG
 	struct hostapd_channel_data *start, *prev;
+#else
+	const struct triplet_band *triplet_band = &triplet_03;
+#endif
 	int chan_spacing = 1;
 
 	if (!hapd->iconf->ieee80211d || max_len < 6 ||
@@ -140,6 +219,18 @@ static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
 	if (mode->mode == HOSTAPD_MODE_IEEE80211A)
 		chan_spacing = 4;
 
+#if CONFIG_COUNTRY_DBG
+	for (i=0; i < triplet_band->num_triplets; i++) {
+		const struct triplet_chan *triplet = &triplet_band->triplets[i];
+
+		if (end - pos < 3)
+			break;
+
+		*pos++ = triplet->first_channel;
+		*pos++ = triplet->num_channels;
+		*pos++ = triplet->max_power;
+	}
+#else
 	start = prev = NULL;
 	for (i = 0; i < mode->num_channels; i++) {
 		struct hostapd_channel_data *chan = &mode->channels[i];
@@ -166,11 +257,12 @@ static u8 * hostapd_eid_country(struct hostapd_data *hapd, u8 *eid,
 		pos = hostapd_eid_country_add(pos, end, chan_spacing,
 					      start, prev);
 	}
+#endif
 
 	if ((pos - eid) & 1) {
 		if (end - pos < 1)
 			return eid;
-		*pos++ = 0; /* pad for 16-bit alignment */
+		*pos++ = 0; /* pad for divisibility by 2 */
 	}
 
 	eid[1] = (pos - eid) - 2;
-- 
1.6.3.3

