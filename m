Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3ADC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 21:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB6E20850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 21:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="wKvGytBc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCB6E20850
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbeLCVHL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 16:07:11 -0500
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:43035 "EHLO
        19.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbeLCVHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 16:07:11 -0500
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2018 16:07:10 EST
Received: from player697.ha.ovh.net (unknown [10.109.146.175])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 11DFA1FD94D
        for <linux-wireless@vger.kernel.org>; Mon,  3 Dec 2018 21:22:13 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player697.ha.ovh.net (Postfix) with ESMTPSA id 5BDC77C607B;
        Mon,  3 Dec 2018 20:22:09 +0000 (UTC)
Subject: Re: [PATCH] mac80211: allow AP_VLAN operation on crypto controlled
 devices
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1543867669;
        bh=snbmpFetkc1S3jN0W1nxhfMU7PdudgoTUtrgD42pl9E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=wKvGytBc7awKUjCc8kA7+DT4PdnBlOkkPS4qym8kf2xqLfmksQwqbG5lhHye/kZ+p
         vdgSXFFktjwv2Xi2P6gKMvYoIojB1j2zZGheAQjxMDYzMbBgZSrmRtugJ1cEo6KrwV
         2wEqRRk3gy7NH6yQ+uMqNorPe6mJ6Il9P9DbDVxU=
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        mpubbise@codeaurora.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
References: <1522242259-16166-1-git-send-email-mpubbise@codeaurora.org>
 <029be0b3-6fb9-1b6a-b512-db620946e08b@wetzel-home.de>
 <3e11d342-ba2d-fc0d-300b-9b2817d07fe4@newmedia-net.de>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <86cecc99-8f9f-7828-fc54-e29272e730cc@wetzel-home.de>
Date:   Mon, 3 Dec 2018 21:07:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <3e11d342-ba2d-fc0d-300b-9b2817d07fe4@newmedia-net.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10409226113848384626
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefuddgudefiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> yes you just missed that ap_vlan is used for 4addr ap's / wds too so 
> that might be related to the weired handling
> 
For my understanding ath10k is supporting 4addr mode with HW ciphers 
only. (As long as you do now switch it to raw mode manually and forcing 
SW crypto only.)

The code in question seems to be only reachable if:
1) set_key returned something other than 0 or 1
2) The driver has set SW_CRYPTO_CONTROL

Once triggered it will overwrite the information from the driver, that 
it's not able to handle this key with either hardware or software 
encryption and try SW encryption anyway.
The packets should then be dropped/scrambled by the card and not be 
useful in any way.

Or the other way round:
4addr frames are still QoS data frames, correct?
So why should SW crypto working after the driver told us it will not?


Alexander

> Sebastian
> 
> Am 02.12.2018 um 14:02 schrieb Alexander Wetzel:
>> Hello,
>>
>>> From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
>>>
>>> In the current implementation, mac80211 advertises the support of
>>> AP_VLANs based on the driver's support for AP mode; it also
>>> blocks encrypted AP_VLAN operation on devices advertising
>>> SW_CRYPTO_CONTROL.
>>>
>>> The implementation seems weird in it's current form and could be
>>> often confusing, this is because there can be drivers advertising
>>> both SW_CRYPTO_CONTROL and AP mode support (ex: ath10k) in which case
>>> AP_VLAN will still be supported but only in open BSS and not in
>>> secured BSS.
>>>
>>> When SW_CRYPTO_CONTROL is enabled, it makes more sense if the decision
>>> to support AP_VLANs is left to the driver. Mac80211 can then allow
>>> AP_VLAN operations depending on the driver support.
>>
>> This first part of the patch contradicts my current understanding of 
>> how Software crypto fallback can be triggered: We have a driver 
>> actively telling us to only fall back to sw crypto when it returns 1 
>> on set_key, BUT we ignore that when the interface is set to 
>> @NL80211_IFTYPE_AP_VLAN and allow software encryption unconditionally?
>>
>> Here the code:
>>         case WLAN_CIPHER_SUITE_GCMP:
>>         case WLAN_CIPHER_SUITE_GCMP_256:
>>                 /* all of these we can do in software - if driver can */
>>                 if (ret == 1)
>>                         return 0;
>>                 if (ieee80211_hw_check(&key->local->hw,
>>                                SW_CRYPTO_CONTROL)) {
>>                         if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>>                                 return 0;
>>                         return -EINVAL;
>>                 }
>>                 return 0;
>>         default:
>>                 return -EINVAL;
>>         }
>>
>>
>> Wouldn't it be preferable to just return "ret" or "-EINVAL" instead of 
>> "0" when the interface has @NL80211_IFTYPE_AP_VLAN set?
>> As it is this basically overrides SW_CRYPTO_CONTROL in AP Vlan mode!
>>
>> For me it looks like the old behavior in this section was already fine 
>> and does not hurt the intention of this patch: A driver setting 
>> SW_CRYPTO_CONTROL won't get support for AP VLANs as long as the driver 
>> is not opting in to it.
>>
>> Therefore I would like to undo this part of the patch again:
>>
>> -        if (ieee80211_hw_check(&key->local->hw,
>>                        SW_CRYPTO_CONTROL))
>> +        if (ieee80211_hw_check(&key->local->hw,
>>                        SW_CRYPTO_CONTROL)) {
>> +            if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>> +                return 0;
>>              return -EINVAL;
>> +        }
>>
>>
>> Do I miss something here and would anyone have issues when I revert 
>> that in another patch?
>>
>> Alexander
>>
