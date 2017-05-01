Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37473 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2999917AbdEAJk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 05:40:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id m123so93721055wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 May 2017 02:40:28 -0700 (PDT)
Subject: Re: [PATCH 5/9] cfg80211/nl80211: add authorized flag to roaming
 event
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20170426075854.13546-1-luca@coelho.fi>
 <20170426075854.13546-6-luca@coelho.fi>
 <30808bad-1f15-20bd-9bfe-0c10ab8555cd@broadcom.com>
 <1493413355.2431.19.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f1121440-b9c7-f270-6e68-11250f9841aa@broadcom.com> (sfid-20170501_114046_358870_D6102A67)
Date: Mon, 1 May 2017 11:40:26 +0200
MIME-Version: 1.0
In-Reply-To: <1493413355.2431.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/28/2017 11:02 PM, Johannes Berg wrote:
> On Wed, 2017-04-26 at 12:05 +0200, Arend van Spriel wrote:
>>
>>> the mobility domain does not require new 802.1X authentication, but
>>> roaming to another mobility domain does.
>>
>> Not sure about the terminology here. Is "mobility domain" the same
>> as  "ESS" which stands for extended service set as definced in
>> 802.11  standard. If so, I would prefer use of that term here.
> 
> No. "Mobility domain" was defined in 802.11r, it's unrelated to ESS.

Thanks for the reference. So a "Mobility domain" is a group of BSSes 
within the same ESS. Noted.

>>> + * @authorized: true if the 802.1X authentication was done by the
>>> driver or is
>>> + *	not needed (e.g., when Fast Transition protocol was
>>> used), false
>>> + *	otherwise. Ignored for networks that don't use 802.1X
>>> authentication.
>>
>> It is not ignored in this patch so it is expected user-space
>> behavior you are describing, which is not really needed here in
>> cfg80211 driver api.
> 
> Still kinda makes sense though to give that hint to the driver authors,
> don't you think? Though it should be pretty clear ...

I tend to look further than the cfg80211 API ;-) Agree that is good to 
have it within the scope of the cfg80211 driver API.

>>>     *	well to remain backwards compatible.
>>>     * @NL80211_CMD_ROAM: request that the card roam (currently not
>>> implemented),
>>
>> Do we want to keep this comment about the request scenario. Is it
>> likely implemented soon/ever?
> 
> Heh, good question. Probably not, but it's kinda an unrelated cleanup,
> no?

True. It just seems a good time to do it.

>>>     *	sent as an event when the card/driver roamed by itself.
>>> + *	When used as an event, and the driver roamed in a
>>> network that requires
>>> + *	802.1X authentication,
>>> %NL80211_ATTR_CONNECTION_AUTHORIZED should be set
>>> + *	if the 802.1X authentication was done by the driver or
>>> if roaming was
>>> + *	done using Fast Transition protocol (in which case
>>> 802.1X authentication
>>> + *	is not needed). If %NL80211_ATTR_CONNECTION_AUTHORIZED
>>> is not set,
>>> + *	user space is responsible for the 802.1X authentication.
>>
>> Would you consider using NL80211_ATTR_PORT_AUTHORIZED instead
>> referring to the 802.1X port entities.
> 
> I guess that makes sense, yeah.

So I will include this patch in my patchset for PSK/1X offloading taken 
above into account.

Regards,
Arend
