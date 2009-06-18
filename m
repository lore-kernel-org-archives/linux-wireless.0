Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbZFRWWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:55 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:57 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 22/23] orinoco: convert giwrange to cfg80211
Date: Thu, 18 Jun 2009 23:21:34 +0100
Message-Id: <1245363695-8289-23-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/wext.c |  115 +----------------------------------
 1 files changed, 1 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 082ea0a..21db578 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -172,119 +172,6 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 	return err;
 }
 
-static int orinoco_ioctl_getiwrange(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_point *rrq,
-				    char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int err = 0;
-	struct iw_range *range = (struct iw_range *) extra;
-	int numrates;
-	int i, k;
-
-	rrq->length = sizeof(struct iw_range);
-	memset(range, 0, sizeof(struct iw_range));
-
-	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = 22;
-
-	/* Set available channels/frequencies */
-	range->num_channels = NUM_CHANNELS;
-	k = 0;
-	for (i = 0; i < NUM_CHANNELS; i++) {
-		if (priv->channel_mask & (1 << i)) {
-			range->freq[k].i = i + 1;
-			range->freq[k].m = (ieee80211_dsss_chan_to_freq(i + 1) *
-					    100000);
-			range->freq[k].e = 1;
-			k++;
-		}
-
-		if (k >= IW_MAX_FREQUENCIES)
-			break;
-	}
-	range->num_frequency = k;
-	range->sensitivity = 3;
-
-	if (priv->has_wep) {
-		range->max_encoding_tokens = ORINOCO_MAX_KEYS;
-		range->encoding_size[0] = SMALL_KEY_SIZE;
-		range->num_encoding_sizes = 1;
-
-		if (priv->has_big_wep) {
-			range->encoding_size[1] = LARGE_KEY_SIZE;
-			range->num_encoding_sizes = 2;
-		}
-	}
-
-	if (priv->has_wpa)
-		range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_CIPHER_TKIP;
-
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) && (!SPY_NUMBER(priv))) {
-		/* Quality stats meaningless in ad-hoc mode */
-	} else {
-		range->max_qual.qual = 0x8b - 0x2f;
-		range->max_qual.level = 0x2f - 0x95 - 1;
-		range->max_qual.noise = 0x2f - 0x95 - 1;
-		/* Need to get better values */
-		range->avg_qual.qual = 0x24;
-		range->avg_qual.level = 0xC2;
-		range->avg_qual.noise = 0x9E;
-	}
-
-	err = orinoco_hw_get_bitratelist(priv, &numrates,
-					 range->bitrate, IW_MAX_BITRATES);
-	if (err)
-		return err;
-	range->num_bitrates = numrates;
-
-	/* Set an indication of the max TCP throughput in bit/s that we can
-	 * expect using this interface. May be use for QoS stuff...
-	 * Jean II */
-	if (numrates > 2)
-		range->throughput = 5 * 1000 * 1000;	/* ~5 Mb/s */
-	else
-		range->throughput = 1.5 * 1000 * 1000;	/* ~1.5 Mb/s */
-
-	range->min_rts = 0;
-	range->max_rts = 2347;
-	range->min_frag = 256;
-	range->max_frag = 2346;
-
-	range->min_pmp = 0;
-	range->max_pmp = 65535000;
-	range->min_pmt = 0;
-	range->max_pmt = 65535 * 1000;	/* ??? */
-	range->pmp_flags = IW_POWER_PERIOD;
-	range->pmt_flags = IW_POWER_TIMEOUT;
-	range->pm_capa = (IW_POWER_PERIOD | IW_POWER_TIMEOUT |
-			  IW_POWER_UNICAST_R);
-
-	range->retry_capa = IW_RETRY_LIMIT | IW_RETRY_LIFETIME;
-	range->retry_flags = IW_RETRY_LIMIT;
-	range->r_time_flags = IW_RETRY_LIFETIME;
-	range->min_retry = 0;
-	range->max_retry = 65535;	/* ??? */
-	range->min_r_time = 0;
-	range->max_r_time = 65535 * 1000;	/* ??? */
-
-	if (priv->firmware_type == FIRMWARE_TYPE_AGERE)
-		range->scan_capa = IW_SCAN_CAPA_ESSID;
-	else
-		range->scan_capa = IW_SCAN_CAPA_NONE;
-
-	/* Event capability (kernel) */
-	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
-	/* Event capability (driver) */
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
-	IW_EVENT_CAPA_SET(range->event_capa, IWEVTXDROP);
-
-	return 0;
-}
-
 static int orinoco_ioctl_setiwencode(struct net_device *dev,
 				     struct iw_request_info *info,
 				     struct iw_point *erq,
@@ -1641,7 +1528,7 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWMODE,	cfg80211_wext_giwmode),
 	STD_IW_HANDLER(SIOCSIWSENS,	orinoco_ioctl_setsens),
 	STD_IW_HANDLER(SIOCGIWSENS,	orinoco_ioctl_getsens),
-	STD_IW_HANDLER(SIOCGIWRANGE,	orinoco_ioctl_getiwrange),
+	STD_IW_HANDLER(SIOCGIWRANGE,	cfg80211_wext_giwrange),
 	STD_IW_HANDLER(SIOCSIWSPY,	iw_handler_set_spy),
 	STD_IW_HANDLER(SIOCGIWSPY,	iw_handler_get_spy),
 	STD_IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
-- 
1.6.0.6

