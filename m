Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35888 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcGRTfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:35:07 -0400
Received: by mail-wm0-f46.google.com with SMTP id f126so116100198wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 12:35:06 -0700 (PDT)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
To: Johannes Berg <johannes@sipsolutions.net>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1468868209.2944.1.camel@sipsolutions.net>
 <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com>
 <1468869356.2944.5.camel@sipsolutions.net>
 <fd7fc930-67ab-89bf-5909-0851057e0c84@broadcom.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ba1e77cc-4a73-07fe-2db0-02fb18e32299@broadcom.com> (sfid-20160718_213511_247641_3D523384)
Date: Mon, 18 Jul 2016 21:35:03 +0200
MIME-Version: 1.0
In-Reply-To: <fd7fc930-67ab-89bf-5909-0851057e0c84@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18-7-2016 21:21, Arend Van Spriel wrote:
> On 18-7-2016 21:15, Johannes Berg wrote:
>> On Mon, 2016-07-18 at 21:13 +0200, Arend Van Spriel wrote:
>>>
>>> On 18-7-2016 20:56, Johannes Berg wrote:
>>>> On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
>>>>> Driver may allow support for different beacon interval on virtual
>>>>> interfaces.
>>>>> Allow if such support is advertised by driver. This adds new
>>>>> ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
>>>>
>>>> We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface
>>>> combinations,
>>>> perhaps it would make sense to also put this flag there?
>>>
>>> Hi Johannes,
>>>
>>> Was looking at the same thing. The description of that flag was a bit
>>> unclear to me.
>>>
>>> """
>>>  * @beacon_int_infra_match: In this combination, the beacon intervals
>>>  *      between infrastructure and AP types must match. This is
>>> required
>>>  *      only in special cases.
>>> """
>>>
>>> It is not explicitly stated but it implies the STA vif is connected,
>>> right.
>>
>> Yes.
>>
>> Forget this flag. I don't think any driver sets it - it was a hack for
>> iwldvm. I also don't think any userspace cares about it, and it likely
>> never really worked. What if the STA vif reconnects anyway?

Uhm. My memory tells me differently and LXR also [1] :-p

Regards,
Arend

[1]
http://lxr.free-electrons.com/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c#L6182
