Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52432 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbeADPIh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:08:37 -0500
Message-ID: <1515078514.10342.29.camel@sipsolutions.net> (sfid-20180104_161324_118888_E0A7C4A2)
Subject: Re: UBSAN: Undefined behaviour in net/wireless/nl80211.c:718:4:
 -1665903437 * 100 cannot be represented in type 'int'
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de,
        Mario Limonciello <mario.limonciello@dell.com>,
        Thorsten Leemhuis <linux@leemhuis.info>
Date: Thu, 04 Jan 2018 16:08:34 +0100
In-Reply-To: <f58ac367-9b22-a7dc-7d45-7e9d19e179c0@molgen.mpg.de>
References: <f58ac367-9b22-a7dc-7d45-7e9d19e179c0@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can you reproduce this?

> [   54.426491] UBSAN: Undefined behaviour in net/wireless/nl80211.c:718:4
> [   54.426492] signed integer overflow:
> [   54.426493] -1665903437 * 100 cannot be represented in type 'int'

Obviously.

However, it looks like the real reason is that there's some garbage (-
1665903437) in chan->max_power, which is just stack memory being leaked
out...

This should help?

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 78e71b0390be..7b42f0bacfd8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1769,8 +1769,7 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	if (wiphy->regulatory_flags & REGULATORY_DISABLE_BEACON_HINTS)
 		return;
 
-	chan_before.center_freq = chan->center_freq;
-	chan_before.flags = chan->flags;
+	chan_before = *chan;
 
 	if (chan->flags & IEEE80211_CHAN_NO_IR) {
 		chan->flags &= ~IEEE80211_CHAN_NO_IR;

johannes
