Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35352 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752771AbeC2LbN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 07:31:13 -0400
Received: by mail-wm0-f42.google.com with SMTP id r82so11032129wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 04:31:12 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
To: Johannes Berg <johannes@sipsolutions.net>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
 <1512990779.26976.69.camel@sipsolutions.net> <5ABCCA33.8070501@broadcom.com>
 <1522322166.5932.13.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        amarnath@qti.qualcomm.com, usdutt@qti.qualcomm.com,
        vamsin@qti.qualcomm.com, Jithu Jance <jithu.jance@broadcom.com>,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABCCE7D.3050702@broadcom.com> (sfid-20180329_133138_938313_5F5A001F)
Date: Thu, 29 Mar 2018 13:31:09 +0200
MIME-Version: 1.0
In-Reply-To: <1522322166.5932.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Jithu, Eylon

On 3/29/2018 1:16 PM, Johannes Berg wrote:
> Hi Arend,
>
>> Picking up a somewhat old thread as I did not see a follow-up on this
>> patch. I got queried about it over here by our FILS team. So what is
>> needed for this patch to pass the bar?
>
> That's indeed a bit old :-)
>
>>>> + * @UPDATE_FILS_ERP_INFO: Indicates that FILS connection parameters (realm,
>>>> + *	username, erp sequence number and rrk) are updated
>>>> + * @UPDATE_AUTH_TYPE: Indicates that Authentication type is updated
>>>
>>> These are new here, but you don't know if they were actually supported:
>>>
>>>> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
>>>> +				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
>>>
>>> here.
>>
>> The description of the FILS_SK_OFFLOAD currently says:
>>
>>    * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS
>> shared key
>>    *      authentication with %NL80211_CMD_CONNECT.
>>
>> Are you suggesting a new flag to cover the new update attributes?
>
> [snip]
>
>>> Again, how do you know the driver will actually look at
>>> UPDATE_AUTH_TYPE?
>>
>> If they don't they are broken, right? And if they are broken, the
>> connection will drop and regular connect will happen anyway, no?
>>
>> We could add a new flag to signal driver will handle the extra
>> parameters in UPDATE_CONNECT_PARAMS, but it is not clear why it would be
>> needed. Seems to me user-space has all the info needed with the existing
>> flag(s).
>
> Agree, and we don't even have any drivers that are setting the
> FILS_SK_OFFLOAD flag anyway, so we can still redefine its semantics to
> some extent.

There is some implied behavior about the UPDATE_AUTH_TYPE. The 
FILS_SK_OFFLOAD only seems to cover NL80211_AUTHTYPE_FILS_SK. So to me 
it seems that changing the auth type really means the driver should give 
up on roaming and let user-space handle it.

> So yeah, I'd argue that what the patch needed was somebody taking a
> critical look at my review ;-)
>
> And perhaps fixing the weird flags thing I pointed out.

Yup. That made sense.

Also there is a DOC section about FILS shared key authentication 
offload" so I suppose that should be extended as well.

Regards,
Arend
