Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07F4C10F0B
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 14:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB5C20882
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 14:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfDBOir (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 10:38:47 -0400
Received: from nbd.name ([46.4.11.11]:45338 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbfDBOip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 10:38:45 -0400
Received: from p548c86fc.dip0.t-ipconnect.de ([84.140.134.252] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hBKYi-0003LV-Ni; Tue, 02 Apr 2019 16:38:40 +0200
Subject: Re: [RFC V3 2/2] ath10k: add tx hw 802.11 encapusaltion offloading
 support
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190401131416.22646-1-john@phrozen.org>
 <20190401131416.22646-3-john@phrozen.org>
 <b7be0488-46ce-f57a-35fd-a00479e0764d@phrozen.org>
 <82b5d619-1214-7464-a873-901677b4445e@newmedia-net.de>
From:   John Crispin <john@phrozen.org>
Message-ID: <c3d532e5-7c7b-0758-674f-9268973a4c42@phrozen.org>
Date:   Tue, 2 Apr 2019 16:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <82b5d619-1214-7464-a873-901677b4445e@newmedia-net.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 02/04/2019 11:27, Sebastian Gottschall wrote:
> Am 01.04.2019 um 16:02 schrieb John Crispin:
>
>>
>> On 01/04/2019 15:14, John Crispin wrote:
>>> @@ -5185,6 +5214,23 @@ static int ath10k_add_interface(struct 
>>> ieee80211_hw *hw,
>>>           break;
>>>       }
>>>   +    switch (vif->type) {
>>> +    case NL80211_IFTYPE_AP:
>>> +        hw_encap = 1;
>>> +        break;
>>> +    case NL80211_IFTYPE_STATION:
>>> +//        if (!sdata->u.mgd.use_4addr)
>>> +            hw_encap = 1;
>>> +        break;
>>> +    case NL80211_IFTYPE_AP_VLAN:
>>> +//        if (!sdata->wdev.use_4addr)
>>> +            hw_encap = 1;
>>> +        break;
>>> +    default:
>>> +        break;
>>> +    }
>>> +    ieee80211_set_hw_80211_encap(vif, ar->ethernetmode & hw_encap);
>>> +
>>>       /* Using vdev_id as queue number will make it very easy to do 
>>> per-vif
>>>        * tx queue locking. This shouldn't wrap due to interface 
>>> combinations
>>>        * but do a modulo for correctness sake and prevent using 
>>> offchannel tx
>>
>> Hi
>>
>> I am not sure what the best way to handle the 4addr mode is. sdata is 
>> part of the subsystem and is not exposed to the drivers.Calling  
>> ieee80211_set_hw_80211_encap() from within the driver looked best to 
>> me at first glance and would avoid adding an extra op call to figure 
>> out if the if encap is supported. Any pointers on what the preferred 
>> solution would look like are welcome.
>>
>>     John
>
> you may do the 4addr check within ieee80211_set_hw_80211_encap, there 
> is no need for dealing with that in ath10k or do i miss something?
>
> Sebastian
>
Correct, I'll add that in V4

     John


