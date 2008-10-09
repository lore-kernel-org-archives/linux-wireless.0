Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:62659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYJIRie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 13:38:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so81724fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 10:38:17 -0700 (PDT)
Message-ID: <45e8e6c40810091038i697c9615pb7121882a54d5873@mail.gmail.com> (sfid-20081009_193839_391791_445AD78D)
Date: Thu, 9 Oct 2008 10:38:17 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] allow AP interfaces to handle BACK action frames
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1223546217.22490.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com>
	 <1223546217.22490.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, despite the "h" in ieee80211_rx_h_action, it
filters both BACK (802.11e and required for 802.11n) and spectrum
management (802.11h) action frames.  I suppose that the entire check
isn't really necessary.  I don't know much about the
WLAN_ACTION_SPCT_MSR_REQ frame but as far as the BACK frames, there
shouldn't be any harm with passing them to the driver for any of the
interface types.  Should I resubmit this as removing the check
entirely?  Should there perhaps be separate functions for the 11e and
11h action frames?

Additionally, with the check the way it currently is, an AP interface
(for example) will respond to an ADDBA frame with something strange
(action code 0x83 for starters, and the rest of the action frame
doesn't make sense), at least with iwlagn.  It seems that if the check
fails and we don't pass the frame to the driver, something weird still
happens (otherwise, for iwlagn at least, the right thing happens).  I
haven't had a chance to see if other drivers / interfaces do that.

Thanks,

On Thu, Oct 9, 2008 at 2:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-08 at 16:18 -0700, Andrey Yurovsky wrote:
>> Add AP mode to the allowed interface check in ieee80211_rx_h_action.  This
>> function handles BACK action frames such as ADDBA and AP interfaces need to
>> receive those.
>>
>> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>
> Fine with me, but I think you need to allow VLAN too? Also, how about
> simply removing this check? Can anything bad happen when we try this in
> an IBSS or on WDS or on MESH?
>
> johannes
>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index 080b0ce..fe406f5 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1553,7 +1553,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>>        *        of these frames in other modes as well!
>>        */
>>       if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>> -         sdata->vif.type != NL80211_IFTYPE_ADHOC)
>> +         sdata->vif.type != NL80211_IFTYPE_ADHOC &&
>> +         sdata->vif.type != NL80211_IFTYPE_AP)
>>               return RX_CONTINUE;
>>
>>       switch (mgmt->u.action.category) {
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
