Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44141 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932426AbcLONcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 08:32:22 -0500
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
 <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
 <1481794142.31776.5.camel@sipsolutions.net>
 <58528607.7090101@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name> (sfid-20161215_143226_525233_F0E5074A)
Date: Thu, 15 Dec 2016 14:32:18 +0100
MIME-Version: 1.0
In-Reply-To: <58528607.7090101@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-12-15 13:01, Thiagarajan, Vasanthakumar wrote:
> On Thursday 15 December 2016 02:59 PM, Johannes Berg wrote:
>>> + * @IEEE80211_CONF_CHANGE_80211_HDR_OFFL: Offload configuration
>>> + *	implementing 802.11 encap/decap for data frames changed.
>>>    */
>>>   enum ieee80211_conf_changed {
>>>   	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
>>> @@ -1279,6 +1286,7 @@ enum ieee80211_conf_changed {
>>>   	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
>>>   	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
>>>   	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
>>> +	IEEE80211_CONF_CHANGE_80211_HDR_OFFL	= BIT(9),
>>>   };
>>
>> Given the requirements (PN check, etc.) I'm not sure how this can
>> change dynamically?
> 
> I agree. Dynamic switch part is buggy, we can start with not allowing
> interfaces resulting in dynamic switch.
Does this mean that when bringing up multiple interfaces, users would
need to figure out the 'magic' order that works?

- Felix
