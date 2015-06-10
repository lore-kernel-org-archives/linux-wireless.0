Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:61772 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbbFJM0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 08:26:17 -0400
Message-ID: <55782CE5.9010300@neratec.com> (sfid-20150610_142635_263704_F29B2EEC)
Date: Wed, 10 Jun 2015 14:26:13 +0200
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: check correct maximum bandwidth for quarter
 and half rate.
References: <1433863625-30579-1-git-send-email-matthias.may@neratec.com>	 (sfid-20150609_173523_482237_45077999) <1433881789.1892.29.camel@sipsolutions.net>
In-Reply-To: <1433881789.1892.29.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/15 22:29, Johannes Berg wrote:
> On Tue, 2015-06-09 at 17:27 +0200, Matthias May wrote:
>> When using quarter and half rates we might want to use self defined
>> frequencies with self defined country codes closer to the border.
>> To avoid these frequencies to be disabled, we need to check if
>> the frequency fits the band with the actual bandwidth.
>> +++ b/net/wireless/reg.c
>> @@ -1016,6 +1016,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
>>   	for (i = 0; i < regd->n_reg_rules; i++) {
>>   		const struct ieee80211_reg_rule *rr;
>>   		const struct ieee80211_freq_range *fr = NULL;
>> +		u32 max_bw = MHZ_TO_KHZ(20);
>>   
>>   		rr = &regd->reg_rules[i];
>>   		fr = &rr->freq_range;
>> @@ -1028,8 +1028,10 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
>>   		 */
>>   		if (!band_rule_found)
>>   			band_rule_found = freq_in_rule_band(fr, center_freq);
>> +		if (fr->max_bandwidth_khz < max_bw)
>> +			max_bw = fr->max_bandwidth_khz;
>>   
>> -		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
>> +		bw_fits = reg_does_bw_fit(fr, center_freq, max_bw);
> So the old code here assumes 20 MHz channel bandwidth, which was
> reasonable until 5/10 MHz were supported.
>
> However, your change looks very odd.
>
> Consider a situation where for some reason you have a regulatory domain
> without 20 MHz channels at all, only allowing a max bandwidth of 10 MHz.
> Then, this code will cause all checks for "channels" to be erroneously
> successful, since you're not really checking the request against the
> regd.
>
> What's needed instead is to actually pass in the requested bandwidth
> from the caller. Additionally, it seems that at least the caller in
> handle_channel_custom() must loop through the available bandwidths
> (5/10/20) and disable those that don't fit, instead of disabling the
> channel if 20 MHz doesn't fit.
>
> johannes
>
Hi
The scenario you describe, is actually what i'm working on.
I have some self defined country codes and some self defined frequencies.
Constructed scenario:
I run a single 5Mhz wide channel on the frequency 5175.
I created a dummy countrycode XS which only allows 5MHz wide channels.
root@RM2:~# iw reg get
country XS: DFS-UNSET
     (5172 - 5247 @ 5), (N/A, 15), (N/A)

Without the patch the channel 5175 and 5180 would be disabled because 
the check sees that 20MHz won't fit.
I'm not sure what exactly you mean that the handle_channel_custom needs 
to loop through 5/10/20.
The freq_reg_info_regd sets the disabled flag on the channel at init.
This is not while trying to start operation on a channel, because the 
channel is already disabled.
Or do you mean to actually have different sets of flags for the 
different bandwidths?

I see that it's erroneously possible to run a 10/20MHz channel on 5175, 
even though this shouldn't be allowed.
However setting the proper flags bw_flags should fix this.

Expanding the patch with the patch below ensures that one can't start 
operation on a channel which it's not allowed on.
Or is there a better way?

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c8fabda..4f96563 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1139,9 +1139,12 @@ static void handle_channel(struct wiphy *wiphy,
      /* Check if auto calculation requested */
      if (reg_rule->flags & NL80211_RRF_AUTO_BW)
          max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-
+    if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+        bw_flags = IEEE80211_CHAN_NO_10MHZ;
+    if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+        bw_flags |= IEEE80211_CHAN_NO_20MHZ;
      if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-        bw_flags = IEEE80211_CHAN_NO_HT40;
+        bw_flags |= IEEE80211_CHAN_NO_HT40;
      if (max_bandwidth_khz < MHZ_TO_KHZ(80))
          bw_flags |= IEEE80211_CHAN_NO_80MHZ;
      if (max_bandwidth_khz < MHZ_TO_KHZ(160))
@@ -1575,8 +1578,12 @@ static void handle_channel_custom(struct wiphy 
*wiphy,
      if (reg_rule->flags & NL80211_RRF_AUTO_BW)
          max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);

+    if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+        bw_flags = IEEE80211_CHAN_NO_10MHZ;
+    if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+        bw_flags |= IEEE80211_CHAN_NO_20MHZ;
      if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-        bw_flags = IEEE80211_CHAN_NO_HT40;
+        bw_flags |= IEEE80211_CHAN_NO_HT40;
      if (max_bandwidth_khz < MHZ_TO_KHZ(80))
          bw_flags |= IEEE80211_CHAN_NO_80MHZ;
      if (max_bandwidth_khz < MHZ_TO_KHZ(160))

Matthias
