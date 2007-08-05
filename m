Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61086 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbXHEW7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 18:59:44 -0400
Message-ID: <46B6565C.2050008@lwfinger.net>
Date: Sun, 05 Aug 2007 17:59:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Questions about mac80211 settings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In net/mac80211/regdomain.c, the following structure and data values are entered:

struct ieee80211_channel_range {
         short start_freq;
         short end_freq;
         unsigned char power_level;
         unsigned char antenna_max;
};

static const struct ieee80211_channel_range ieee80211_fcc_channels[] = {
         { 2412, 2462, 27, 6 } /* IEEE 802.11b/g, channels 1..11 */,
         { 5180, 5240, 17, 6 } /* IEEE 802.11a, channels 36..48 */,
         { 5260, 5320, 23, 6 } /* IEEE 802.11a, channels 52..64 */,
         { 5745, 5825, 30, 6 } /* IEEE 802.11a, channels 149..165, outdoor */,
         { 0 }
};

Is the "power_level" here supposed to be the power setting in dBm? If so, where do these numbers 
come from? The FCC regulations call for 20 dBm for the 2.4 GHz band, and 23, 30, and 36 dBm for the 
3 A bands.

The driver passes a set of channels, power levels and antenna values in the call to 
ieee80211_register_hwmode. These power settings seem to be discarded. Why? Shouldn't they overwrite 
the values defined above?

These power settings are of interest because driving the BCM4311 device at its maximum of 18.5 dBm 
severly cuts the performance at high data rates with the AP nearby. It probably causes distortion of 
the output.

Larry


Larry
