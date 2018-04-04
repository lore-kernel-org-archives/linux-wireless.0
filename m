Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:44967 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeDDNT7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 09:19:59 -0400
Received: by mail-qk0-f180.google.com with SMTP id u9so8958091qkk.11
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2018 06:19:58 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
To: Johannes Berg <johannes@sipsolutions.net>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
 <1512990779.26976.69.camel@sipsolutions.net> <5ABCCA33.8070501@broadcom.com>
 <1522322166.5932.13.camel@sipsolutions.net> <5ABCCE7D.3050702@broadcom.com>
 <5AC4990E.7060806@broadcom.com> <1522838180.3042.1.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        amarnath@qti.qualcomm.com, usdutt@qti.qualcomm.com,
        vamsin@qti.qualcomm.com, Jithu Jance <jithu.jance@broadcom.com>,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC4D0FA.6070306@broadcom.com> (sfid-20180404_152002_715241_C4C97FF3)
Date: Wed, 4 Apr 2018 15:19:54 +0200
MIME-Version: 1.0
In-Reply-To: <1522838180.3042.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/4/2018 12:36 PM, Johannes Berg wrote:
> Hi,
>
>> Started working on this and actually the "weird flags thing" is done for
>> a reason. Maybe the reason was because it is done like that in the
>> CMD_CONNECT case, but the better reason is that we need to return
>> -EINVAL for "no-fils-offload-support, any-fils-param" *and*
>> "fils-offload-support, not-all-fils-param".
>
> Ok, fair enough.

I added a comment for this in the patch.

>>> Also there is a DOC section about FILS shared key authentication
>>> offload" so I suppose that should be extended as well.
>>
>> So looking at the DOC section I am reading the following:
>>
>>    * When FILS shared key authentication is completed, driver needs to
>> provide the
>>    * below additional parameters to userspace.
>>    *	%NL80211_ATTR_FILS_KEK - used for key renewal
>>    *	%NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM - used in further EAP-RP exchanges
>>    *	%NL80211_ATTR_PMKID - used to identify the PMKSA used/generated
>>    *	%Nl80211_ATTR_PMK - used to update PMKSA cache in userspace
>>    * The PMKSA can be maintained in userspace persistently so that it can
>> be used
>>    * later after reboots or wifi turn off/on also.
>>
>> So to me it seems we need these for the ROAM event as well. Agree?
>
> Maybe not all of them, you could be using the same PMKSA, but yes, I
> tend to agree.

I would argue that for the scenario where you do CMD_CONNECT(auth=open) 
and CMD_UPDATE_CONNECT_PARAMS(auth=fils-sk) the ROAM event should 
provide all the above. From what I understand from my colleagues this is 
a supported scenario.

Regards,
Arend
