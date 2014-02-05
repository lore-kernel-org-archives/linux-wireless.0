Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39688 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaBEKMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 05:12:43 -0500
Received: by mail-pa0-f41.google.com with SMTP id fa1so172821pad.28
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 02:12:41 -0800 (PST)
MIME-Version: 1.0
From: Blaise Gassend <blaise@suitabletech.com>
Date: Wed, 5 Feb 2014 02:12:20 -0800
Message-ID: <CAPvVjitJ80xtgQ-PtBygZ3uHusQhHNfWf=BMw8EfkgF9mwU8JQ@mail.gmail.com> (sfid-20140205_111253_754628_842D5F01)
Subject: [RFC] Allow active scanning while associated with custom world
 regulatory domain
To: linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks,

I have noticed that with the ath9k boards I use, I am unable to do
active scanning while associated.

I have tracked down the problem to the following causes:

1. The ath9k driver has a custom regulatory domain. It is a world
regulatory domain that has passive scanning
(IEEE80211_CHAN_PASSIVE_SCAN) on most (all?) of the 5GHz band.

2. When I associate, that world regulatory domain is merged with the
country IE regulatory domain to determine what the actual regulatory
domain should be. As part of this merge, the channel flags are ORed
together, so most of the 5GHz band ends up having
IEEE80211_CHAN_PASSIVE_SCAN.

3. When I am associated to an AP with a non-world regulatory domain,
regulatory hints are disabled so there is no mechanism to clear
IEEE80211_CHAN_PASSIVE_SCAN (as there was when I was unassociated and
operating on the driver's world regulatory domain).

This is particularly annoying if you are on a hidden SSID and you are
trying to use multiple interfaces, or if you are trying to do
background scanning to roam to a different BSS, as it is now
impossible to send out the probe requests you need to see BSSes for
your SSID.

I'd be interested in comments on the patch below. It is based on the
assumption that drivers may need to set a custom regulatory domain to
prevent access to certain channels (if the hardware isn't calibrated
for that channel, for instance), but that a driver never needs to
restrict passive scanning beyond what is allowed by the country IE
regulatory domain.

So, are there cases where IEEE80211_CHAN_PASSIVE_SCAN is set in
orig_flags, but not for the country IE regulatory domain and where we
actually do want to prevent active scanning after we associate? Any
other flaws in the proposal below?

Best regards,
Blaise Gassend

Signed-off-by: Blaise Gassend <blaise.gassend_linux@m4x.org>
diff --git a/modules/backports-20131025/net/wireless/reg.c
b/modules/backports-20131025/net/wireless/reg.c
--- a/modules/backports-20131025/net/wireless/reg.c
+++ b/modules/backports-20131025/net/wireless/reg.c
@@ -837,8 +837,6 @@ static void handle_channel(struct wiphy

        request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);

-       flags = chan->orig_flags;
-
        reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
        if (IS_ERR(reg_rule)) {
                /*
@@ -892,7 +890,16 @@ static void handle_channel(struct wiphy
        chan->dfs_state = NL80211_DFS_USABLE;
        chan->dfs_state_entered = jiffies;

-       chan->beacon_found = false;
+        /*
+         * Clear IEEE80211_CHAN_PASSIVE_SCAN from the driver's flags to
+         * allow the associated country IE to permit active scanning on
+         * frequencies that only allow passive scanning according to the
+         * driver's world regulatory domain. Prior to association, beacon
+         * hints would enable active scanning on these channels.
+         */
+        flags = chan->orig_flags & ~IEEE80211_CHAN_PASSIVE_SCAN;
+
+        chan->beacon_found = false;
        chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
        chan->max_antenna_gain =
                min_t(int, chan->orig_mag,
