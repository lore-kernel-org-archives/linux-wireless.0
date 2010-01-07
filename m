Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mail-out.ovh.net ([91.121.26.226]:57023 "HELO
	2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752822Ab0AGHWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 02:22:41 -0500
Message-ID: <4B458BBC.6040200@free.fr>
Date: Thu, 07 Jan 2010 08:22:36 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Issue connecting to an HT40 AP that sends a Country IE
References: <4B3DBB6B.4010107@free.fr> <43e72e891001011524r190950c8pdfc89e765afb205d@mail.gmail.com> 	<4B3F1010.3070906@free.fr> <43e72e891001021004r2c9cf855p52b007a88123bba7@mail.gmail.com> <43e72e891001061739t5ded13e7u6b16c73f1b26b246@mail.gmail.com>
In-Reply-To: <43e72e891001061739t5ded13e7u6b16c73f1b26b246@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040507020106050904080102"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040507020106050904080102
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Luis R. Rodriguez a écrit :
> On Sat, Jan 2, 2010 at 10:04 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>   
>> The issue should  be that a frequency rule is being created for each
>> channel and although 40 MHz is being specified as max bandwidth
>> logistically only 20 MHz fits into that frequency rule. So what the
>> intersection needs to learn is how to merge rules or at least
>> understand them together. It may be easier to parse insaneIEs like the
>> ones your AP generates and re-generate one with actual ranges with
>> contiguity channels merged. And then use that one for the
>> intersection.
>>     
>
> I have a patch in mind now for this, can you please apply this patch
> on iw, scan and send me the output of the scan for your AP?
>
>   Luis
>   
Here is the result for the said AP :

BSS 00:15:6d:e8:88:84 (on wlan0)
        TSF: 627428313658 usec (7d, 06:17:08)
        freq: 5180
        beacon interval: 100
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -76.00 dBm
        last seen: 7604 ms ago
        SSID: BEN_nsm5
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
        DS Parameter set: channel 36
        Country: FR     Environment: Indoor only
        Country IE triplets:
                Channels [36 - 36]
                Channels [40 - 40]
                Channels [44 - 44]
                Channels [48 - 48]
                Channels [52 - 52]
                Channels [56 - 56]
                Channels [60 - 60]
                Channels [64 - 64]
                Channels [100 - 100]
                Channels [104 - 104]
                Channels [108 - 108]
                Channels [112 - 112]
                Channels [116 - 116]
                Channels [120 - 120]
                Channels [124 - 124]
                Channels [128 - 128]
                Channels [132 - 132]
                Channels [136 - 136]
                Channels [140 - 140]
        Power constraint: 0 dB
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: (0x0000)
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
        HT capabilities:
                Capabilities: 0x4e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        No DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 1/2 usec (0x02)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined

iw version 0.9.18-11-g89ea706-dirty

As a quick patch, I have commented 2 lines "bw_flags = 
IEEE80211_CHAN_NO_HT40" in net/wireless/reg.c

I'll try to do a patch for the kernel that does the following action :
- parse the max_power field
- merge rules if the max_power field is the same for both rules
- use max_bandwidth_khz as a capability feature (ie it could be larger 
than  end_freq - start_freq)
- when trying to enable HT40, we might obey 2 reg rules (if they have 
not been merge). In this case, we should intersect rules again.

Does this logic is fine?

Regards,
Benoit


--------------040507020106050904080102
Content-Type: text/x-patch;
 name="country-ie-allow-ht40.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="country-ie-allow-ht40.diff"

commit b716fd7e8506eaff946f1429f048c258a03249ba
Author: Benoit Papillault <benoit.papillault@free.fr>
Date:   Thu Dec 31 10:58:14 2009 +0100

    mac80211: quick fix to allow HT40 with a country IE
    
    This patch fixes an issue to connect to an HT40 AP sending country IE for
    all channels. Doing this way, each channel is 20 MHz only and as such, current
    code would disallow HT40 operation. This can be seen in ht40allow_map

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87ea60d..bb141c8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -999,10 +999,10 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
-
+	/*
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
-
+	*/
 	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
@@ -1318,10 +1318,10 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
-
+	/*
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
-
+	*/
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);

--------------040507020106050904080102--
