Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49608 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHFReM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 13:34:12 -0400
Received: by ewy10 with SMTP id 10so963597ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 10:34:12 -0700 (PDT)
Message-ID: <4A7B140A.6070607@gmail.com>
Date: Thu, 06 Aug 2009 18:34:02 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/4] orinoco: use cfg80211 for key manipulation
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com> <1249544403.3617.5.camel@johannes.local>
In-Reply-To: <1249544403.3617.5.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> - The cfg80211 notification functions like cfg80211_connect_result
>>   are not called in this series. Does the driver need to keep track of
>>   each call and make sure it calls the right notifer? Right now orinoco
>>   arbitrarily sends SIOCGIWAP, IWEVASSOCRESPIE and IWEVASSOCREQIE on
>>   ?authorisation? Also not sure how this will tie in with
>>   cfg80211_send_rx_auth/assoc.
> 
> You don't have to worry about send_rx_auth/assoc -- those are for
> drivers like mac80211 that leave the SME up to cfg80211 or userspace.
> All you need to implement is a call to cfg80211_connect_result() and
> possibly cfg80211_roamed() when the card can roam itself if no BSSID is
> set. Those take the assoc request/response IEs too. You don't need to
> call wireless_send_event at all :)

I thought as much. I'll add those calls, and see what happens.

>> - In station mode, is the connect crypto struct fully filled in
>>   regardless of WEP/WPA? I'd like to set priv->encode_alg at this stage,
>>   and then only accept keys of that type via add_key. Unfortunately
>>   join_ibss doesn't have similar info.
> 
> Yes, it should be filled in. I'm uncertain whether iw does it correctly
> for WEP right now, if not I can fix that. For IBSS, nl80211 can actually
> pass that info, but doesn't right now, it probably should do that
> though.
> 
>> - In adhoc mode, how do you set open/shared WEP? i.e. how does orinoco
>>   know to set priv->wep_restrict?
> 
> What's priv->wep_restrict? open/shared in ad-hoc seems very strange
> since you have no authentication frames?

priv->wep_restrict differentiates between using
NL80211_AUTHTYPE_OPEN_SYSTEM or NL80211_AUTHTYPE_SHARED_KEY. If it makes
no difference, I'll just zero it in ad-hoc mode.

>> - Digging around cfg80211, it looks like set_default_key isn't called
>>   when authentication is TKIP. How does the driver tell which key to use
>>   for transmit? Are we supposed to assume the group key is the transmit
>>   key?
> 
> The pairwise key, of course. But you knew that, so I think I just don't
> understand the question.

A bit of confusion on my part, I (think I) meant pairwise key. The tkip
key install RID takes a flag to indicate when the key is the transmit
key. So I'll set this for any pairwise key being installed, and assume
we only get one of those. Should work in station mode.

>> - TKIP pairwise keys. I think orinoco has always ignored them. The Agere
>>   driver installed pairwaise keys to index 0. Should I attempt anything?
> 
> I don't think it can have ignored them for proper operation? When you're
> doing WPA, you can only receive with the group key, and transmit with
> the pairwise key negotiated with the AP.

I think I'm just misremembering the details of what the Agere driver
did, and confusing myself.

Thanks for taking the time to have a look (and answer my silly questions!).


Dave.
