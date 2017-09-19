Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:49641 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdISJz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 05:55:27 -0400
Received: by mail-wm0-f49.google.com with SMTP id e71so3587392wmg.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 02:55:27 -0700 (PDT)
Subject: Re: [TDLS PATCH V3 1/5] mac80211: Enable TDLS peer buffer STA feature
To: Johannes Berg <johannes@sipsolutions.net>,
        yintang@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <TDLS for ath10k patchset v3>
 <1505790913-28377-1-git-send-email-yintang@qti.qualcomm.com>
 <1505790913-28377-2-git-send-email-yintang@qti.qualcomm.com>
 <db428527-cb2b-5136-24c2-be2fca9e2407@broadcom.com>
 <1505808914.3026.0.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <06857e7e-5ec1-b0b7-7320-42690e852658@broadcom.com> (sfid-20170919_115530_973728_CFF1975A)
Date: Tue, 19 Sep 2017 11:55:24 +0200
MIME-Version: 1.0
In-Reply-To: <1505808914.3026.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-09-17 10:15, Johannes Berg wrote:
> On Tue, 2017-09-19 at 09:56 +0200, Arend van Spriel wrote:
>>
>>> --- a/include/net/cfg80211.h
>>> +++ b/include/net/cfg80211.h
>>> @@ -3249,6 +3249,8 @@ struct cfg80211_ops {
>>>     *	beaconing mode (AP, IBSS, Mesh, ...).
>>>     * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key
>>> installation
>>>     *	before connection.
>>> + * @WIPHY_FLAG_SUPPORT_TDLS_BUFFER_STA: Device support buffer STA
>>> when TDLS is
>>> + *	established.
>>
>> If I am not mistaken no new wiphy flags are supposed to be added.
>> Although this might be something not reported to user-space, right?
>> Have  a look at struct wiphy::ext_features.
> 
> I guess it should just be a HW flag in mac80211? Not sure why userspace
> even needs to know.

Indeed seems specific to stack functionality in mac80211.

Regards,
Arend
