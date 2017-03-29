Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34543 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbdC2Hnb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 03:43:31 -0400
Received: by mail-wm0-f53.google.com with SMTP id w204so16497324wmd.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 00:43:30 -0700 (PDT)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
To: Johannes Berg <johannes@sipsolutions.net>,
        Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
 <1490772890.18052.8.camel@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3320e9f4-21c3-966f-df6e-0bc8292a88a0@broadcom.com> (sfid-20170329_094418_257057_C503D468)
Date: Wed, 29 Mar 2017 09:43:27 +0200
MIME-Version: 1.0
In-Reply-To: <1490772890.18052.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-3-2017 9:34, Johannes Berg wrote:
> On Fri, 2017-03-24 at 21:32 -0400, Dennis New wrote:
>> Ever since I upgraded to the 4.10 kernels (I don't think this
>> behavior existed in the 4.8 series), after I startup my laptop
>> (either from cold boot, or from standby), my wlan0 interface keeps
>> deauthenticating
> 
>> ...
>> 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
>> 19:23:29 kernel: ------------[ cut here ]------------
>> 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
>> net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380

284	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
285					tracking ? 0 :
286					   IEEE80211_CHAN_DISABLED)) {
287		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
288			ret = IEEE80211_STA_DISABLE_HT |
289			      IEEE80211_STA_DISABLE_VHT;
290			break;
291		}

> This is already indicating a severe problem. I don't know how you end
> up in this situation with b43, since that doesn't have any regulatory
> magic afaict.

The only way this WARN_ON can kick in is below so may be interesting to
log the three variables checked in 'if' statement.

161	chandef->chan = channel;
162	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
163	chandef->center_freq1 = channel->center_freq;
164	chandef->center_freq2 = 0;
165
166	if (!ht_cap || !ht_oper || !sta_ht_cap.ht_supported) {
167		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
168		goto out;
169	}
170
171	chandef->width = NL80211_CHAN_WIDTH_20;

>> 19:23:29 kernel: wlan0: associated
>>
>> 19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by
>> local choice (Reason: 3=DEAUTH_LEAVING)
>>
> 
> I'm convinced that this comes from reg_check_channels().
> 
> The above WARN_ON() already told you that the channel was considered
> invalid.
> 
> Do you know what channel your AP is on? Perhaps show the output of "iw
> wlan0 scan dump" while it's connected (you have 60 seconds :P)
> 
> Can you please show the output of "iw list" and "iw phy0 channels"?

Could it be a radar channel and it's waiting for CAC timeout or whatever
the term is ;-) ?

Regards,
Arend
