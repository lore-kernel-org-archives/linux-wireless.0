Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17303 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZIILKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 07:10:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: allow scanning on specified frequencies when using wext-compatibility
Date: Wed, 9 Sep 2009 13:09:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909091309.55068.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handles the case when SIOCSIWSCAN specified iw_scan_req.num_channels and
iw_scan_req.channels[].

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/net/wireless/scan.c
===================================================================
--- linux-wl.orig/net/wireless/scan.c	2009-09-09 10:38:58.000000000 +0200
+++ linux-wl/net/wireless/scan.c	2009-09-09 11:59:39.000000000 +0200
@@ -607,6 +607,9 @@ int cfg80211_wext_siwscan(struct net_dev
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
+	if (wrqu->data.length == sizeof(struct iw_scan_req))
+		wreq = (struct iw_scan_req *)extra;
+
 	rdev = cfg80211_get_dev_from_ifindex(dev_net(dev), dev->ifindex);
 
 	if (IS_ERR(rdev))
@@ -619,9 +622,14 @@ int cfg80211_wext_siwscan(struct net_dev
 
 	wiphy = &rdev->wiphy;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
-		if (wiphy->bands[band])
-			n_channels += wiphy->bands[band]->n_channels;
+	/* Determine number of channels, needed to allocate creq */
+	if (wreq && wreq->num_channels)
+		n_channels = wreq->num_channels;
+	else {
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+			if (wiphy->bands[band])
+				n_channels += wiphy->bands[band]->n_channels;
+	}
 
 	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
 		       n_channels * sizeof(void *),
@@ -638,22 +646,41 @@ int cfg80211_wext_siwscan(struct net_dev
 	creq->n_channels = n_channels;
 	creq->n_ssids = 1;
 
-	/* all channels */
+	/* translate "Scan on frequencies" request */
 	i = 0;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		int j;
 		if (!wiphy->bands[band])
 			continue;
 		for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+
+			/* If we have a wireless request structure and the
+			 * wireless request specifies frequencies, then search
+			 * for the matching hardware channel.
+			 */
+			if (wreq && wreq->num_channels) {
+				int k;
+				int wiphy_freq = wiphy->bands[band]->channels[j].center_freq;
+				for (k = 0; k < wreq->num_channels; k++) {
+					int wext_freq = wreq->channel_list[k].m / 100000;
+					if (wext_freq == wiphy_freq)
+						goto wext_freq_found;
+				}
+				goto wext_freq_not_found;
+			}
+
+		wext_freq_found:
 			creq->channels[i] = &wiphy->bands[band]->channels[j];
 			i++;
+		wext_freq_not_found: ;
 		}
 	}
 
-	/* translate scan request */
-	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
-		wreq = (struct iw_scan_req *)extra;
+	/* Set real number of channels specified in creq->channels[] */
+	creq->n_channels = i;
 
+	/* translate "Scan for SSID" request */
+	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
 				return -EINVAL;
