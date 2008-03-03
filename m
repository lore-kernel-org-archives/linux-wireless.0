Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56232 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYCCHHy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 02:07:54 -0500
Subject: Re: hostapd with mac80211 progress
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204302356.3938.36.camel@johannes.berg>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
	 <1204302356.3938.36.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 15:08:19 +0800
Message-Id: <1204528099.3087.15.camel@debian.sh.intel.com> (sfid-20080303_070808_335564_7319B766)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2008-02-29 at 17:25 +0100, Johannes Berg wrote:
> now that John merged more stuff you should only need the hostapd
> patch and the allow-ap-vlan-modes patch from my kernel series :)

OK. This time is much better. Now I can at least ping my 4965 AP with
below fix.

The removal of mac80211 IEEE80211_CHAN_W_SCAN flag causes channel flag
incompatibility between hostapd and driver. Hostapd expects
HOSTAPD_CHAN_W_SCAN (0x1) to be set for the configured channel while 0x1
means IEEE80211_CHAN_DISABLED in the new mac80211. We should make
ieee80211_channel_flags and HOSTAPD_CHAN_W_xxx compatible. What do you
think? I now just workaround the problem with:

diff --git a/hostapd/hw_features.c b/hostapd/hw_features.c
index c58e1e4..8a7b013 100644
--- a/hostapd/hw_features.c
+++ b/hostapd/hw_features.c
@@ -294,8 +294,7 @@ static int select_hw_mode1(struct hostapd_iface
*iface)
 	for (j = 0; j < iface->current_mode->num_channels; j++) {
 		struct hostapd_channel_data *chan =
 			&iface->current_mode->channels[j];
-		if ((chan->flag & HOSTAPD_CHAN_W_SCAN) &&
-		    (chan->chan == iface->conf->channel)) {
+		if (chan->chan == iface->conf->channel) {
 			ok = 1;
 			break;
 		}




