Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37622 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755135AbdLOJ2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 04:28:22 -0500
Received: by mail-wm0-f67.google.com with SMTP id f140so16211459wmd.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2017 01:28:21 -0800 (PST)
Subject: Re: [PATCH 1/2] cfg80211/nl80211: Optional authentication offload to
 userspace
To: Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
References: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
 <A0B39E95-DAA8-4676-A0C7-8C21DBFE7DE4@holtmann.org>
 <829f69319fad450db616f02de781d1a8@aphydexm01b.ap.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A3395B3.7090501@broadcom.com> (sfid-20171215_102857_893676_B1DA5B10)
Date: Fri, 15 Dec 2017 10:28:19 +0100
MIME-Version: 1.0
In-Reply-To: <829f69319fad450db616f02de781d1a8@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2017 9:51 AM, Srinivas Dasari wrote:
>> don’t we actually need a flag in NL80211_CMD_CONNECT that indicates that userspace is able to actually handle NL80211_CMD_EXTERNAL_AUTH. It is nice >that there is feature for userspace to see if the driver supports it, but how is the driver able to offload successfully if it doesn’t know that userspace can do it.
> Our idea was the driver to timeout the connect for the scenarios where the external auth (SAE) status is not indicated.
> I agree with you on user space indicating this capability to the driver.
> Is it a fair idea to extend enum cfg80211_assoc_req_flags for this ?

Sounds like a good fit to me although strictly speaking this is not 
about assoc behavior, but then again this enum is used for assoc and 
connect commands.

Regards,
Arend

> Regards,
> Srinivas
>
> -----Original Message-----
> From: Marcel Holtmann [mailto:marcel@holtmann.org]
> Sent: Friday, December 15, 2017 1:29 AM
> To: Jouni Malinen <jouni@qca.qualcomm.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>; linux-wireless@vger.kernel.org; Srinivas Dasari <dasaris@qti.qualcomm.com>
> Subject: Re: [PATCH 1/2] cfg80211/nl80211: Optional authentication offload to userspace
>
> Hi Jouni,
>
>> This interface allows the host driver to offload the authentication to
>> user space. This is exclusively defined for host drivers that do not
>> define separate commands for authentication and association, but rely
>> on userspace SME (e.g., in wpa_supplicant for the
>> ~WPA_DRIVER_FLAGS_SME
>> case) for the authentication to happen. This can be used to implement
>> SAE without full implementation in the kernel/firmware while still
>> being able to use NL80211_CMD_CONNECT with driver-based BSS selection.
>>
>> The host driver sends the NL80211_CMD_EXTERNAL_AUTH event to
>> start/abort the authentication to userspace and status of
>> authentication is further indicated by user space to host driver
>> through the same command interface. Such drivers advertise the
>> capability through NL80211_EXT_FEATURE_EXTERNAL_AUTH.
>
> don’t we actually need a flag in NL80211_CMD_CONNECT that indicates that userspace is able to actually handle NL80211_CMD_EXTERNAL_AUTH. It is nice that there is feature for userspace to see if the driver supports it, but how is the driver able to offload successfully if it doesn’t know that userspace can do it.
>
> Regards
>
> Marcel
>
