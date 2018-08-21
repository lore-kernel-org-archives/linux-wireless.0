Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbeHVBaB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 21:30:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 21 Aug 2018 15:08:02 -0700
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
Message-ID: <7999c366492a4523456227fb49329bf2@codeaurora.org> (sfid-20180822_000805_438355_76A4A4B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-21 12:24, Johannes Berg wrote:
> On Tue, 2018-08-21 at 11:32 -0700, Pradeep Kumar Chitrapu wrote:
>> 
>> I wasn't aware of this android api.
> 
> OK.
> 
>> However, looking at the api, the
>> assumption is that bss is started by a different
>> api and the 'enableResponder' api is used for enabling rtt for a given
>> duration.
> 
> It looks like. Note that there's also *disable*, which we hadn't even
> implemented before.
> 
>> The reason we have added enabling ftm responder through start ap is 
>> that
>> this can reflect beacon IE change in the
>> configuration in the same place.
> 
> Which makes sense, yeah.
> 
>> In case of the separate command,
>> enabling responder will not update the beacon,
>> however, the application must issue the new command, whenever its
>> updating beacon template.
> 
> Right. However, I guess we could allow updating/changing this setting 
> on
> the fly through nl80211_set_beacon() which already allows changing 
> other
> non-beacon parameters (like the probe or assoc response templates), and
> then we can use your approach. Basically changing "SET_BEACON" to be a
> bit like "CHANGE_AP".
Agree. ( ftm_responder param will have to be added in 
cfg80211_beacon_data
instead of cfg80211_ap_settings)

> In that case we definitely would need the
> attribute to be 0/1 as you had it so that it not present can be used to
> indicate "no change".
OK.
> 
> johannes
