Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34658 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753959AbdC2IUT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:20:19 -0400
Received: by mail-qk0-f170.google.com with SMTP id d10so6560821qke.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 01:20:18 -0700 (PDT)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
To: Johannes Berg <johannes@sipsolutions.net>,
        Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
 <1490772890.18052.8.camel@sipsolutions.net>
 <3320e9f4-21c3-966f-df6e-0bc8292a88a0@broadcom.com>
 <1490773593.7948.2.camel@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <260a3f4a-1ee1-62ec-e3db-294510e71a4e@broadcom.com> (sfid-20170329_102031_818758_83AB2CBD)
Date: Wed, 29 Mar 2017 10:20:15 +0200
MIME-Version: 1.0
In-Reply-To: <1490773593.7948.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29-3-2017 9:46, Johannes Berg wrote:
> 
>>>> 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
>>>> 19:23:29 kernel: ------------[ cut here ]------------
>>>> 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
>>>> net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
>>
>> 284	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy,
>> chandef,
>> 285					tracking ? 0 :
>> 286					   IEEE80211_CHAN_DISABLED
>> )) {
>> 287		if (WARN_ON(chandef->width ==
>> NL80211_CHAN_WIDTH_20_NOHT)) {
>> 288			ret = IEEE80211_STA_DISABLE_HT |
>> 289			      IEEE80211_STA_DISABLE_VHT;
>> 290			break;
>> 291		}
>>
>>> This is already indicating a severe problem. I don't know how you
>>> end
>>> up in this situation with b43, since that doesn't have any
>>> regulatory
>>> magic afaict.
>>
>> The only way this WARN_ON can kick in is below so may be interesting
>> to log the three variables checked in 'if' statement.
> 
> Yeah we should probably extend the WARN_ON() to a WARN() with that
> information.
> 
>> Could it be a radar channel and it's waiting for CAC timeout or
>> whatever the term is ;-) ?
> 
> No. Not even tongue-in-cheek :-)
> This code was designed for regulatory changes, but the WARN_ON()
> indicates that we got connected on a channel that we think isn't
> actually usable. We quite possibly should reject that connection there,
> but it seems to me it should've been rejected elsewhere already...?

But this is prior to connection, right? This warning happens upon
authenticate. So in nl80211_authenticate() we do:

chan = nl80211_get_valid_chan(&rdev->wiphy,
			      info->attrs[NL80211_ATTR_WIPHY_FREQ]);

and in cfg80211_mlme_auth():

req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
			   IEEE80211_BSS_TYPE_ESS,
			   IEEE80211_PRIVACY_ANY);

After that the chain is:

ieee80211_mgd_auth() ->
	ieee80211_prep_connection() ->
		ieee80211_prep_channel() ->
			ieee80211_determine_chantype()

Regards,
Arend
