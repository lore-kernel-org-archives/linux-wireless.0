Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F074C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 17:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAFFC20892
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 17:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="DBQ/O3XN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAFFC20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbeLFRgz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 12:36:55 -0500
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:35664 "EHLO
        18.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbeLFRgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 12:36:54 -0500
Received: from player787.ha.ovh.net (unknown [10.109.159.123])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 9DC67149202
        for <linux-wireless@vger.kernel.org>; Thu,  6 Dec 2018 17:21:41 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player787.ha.ovh.net (Postfix) with ESMTPSA id 2E13FAEA9DD;
        Thu,  6 Dec 2018 16:21:40 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/2] nl80211/cfg80211: Add support for Extended Key
 ID
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544113299;
        bh=Rq7CfzdPx9kfk2/xJbIPZbij2QKh6b2zpKRIcDRidEk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DBQ/O3XN43VwooNpsKqJrz8CZ5SslVKw3wcBj7dH0ms0E+0gFpPiZulrb/sdFXahL
         2hNljzYbE86f+jvdYABKLHdlCIrG+LqV5H6T0G++vhZB437haj69fSz72VZJl3ETxV
         cG6T4yDPslTXcw9GYtIsKrVbD7W7KLEbLyFWNOrs=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <20181111110235.14213-2-alexander@wetzel-home.de>
 <471c7131e4b81a06f8c514652038d69819ae66ea.camel@sipsolutions.net>
 <a2d2f2ff-f776-93e8-579a-fbc05f236d76@wetzel-home.de>
 <0d60ddc1367ab8e82811898b13e4d990794c9118.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <f70db2ec-0d14-3ee6-a8e8-9a54c4b1abb6@wetzel-home.de>
Date:   Thu, 6 Dec 2018 17:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <0d60ddc1367ab8e82811898b13e4d990794c9118.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5518316921599499463
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefjedgkeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, 2018-12-05 at 21:54 +0100, Alexander Wetzel wrote:
>>
>> It started out as a flag and I switched to enum later without updating
>> it. I'll chnage that to nl80211_key_install_mode, much much better...
> 
>> No, all stations using Extended Key ID will always use RX_ONLY and
>> SET_TX for pairwise key installs. The AP will install the Key Rx only
>> prior to sending eapol #3, the sta prior to sending eapol #4.
> 
> Actually ... let's see all the operations at nl80211 level.
> 
> We have NEW_KEY and SET_KEY, right? SET_KEY basically already says to
> use a given key for TX from now on, IIRC?
> 
> So realistically, don't we only need
> 
> NEW_KEY (RX-only)
> 
> as a new variant of NEW_KEY?
> 

Yes, that should indeed work. I'll try that and see how it plays out.

>> The PTK0 rekey patch added a new line in front of the description. The
>> next author did not notice that and added the description for
>> NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER at the wrong place, probably
>> assuming it was the end of the list. I've noticed that and fixed the
>> documentation order and the misleading empty line.
>> I'll break that out as a separate cleanup patch if nobody beats me to it:-)
> 
> Oh. OK. It also doesn't really matter ;-)
> 
>>>>    		k->def_multi = true;
>>>>    
>>>> +	k->rx_only = !!info->attrs[NL80211_ATTR_KEY_RXONLY];
>>>> +	k->set_tx = !!info->attrs[NL80211_ATTR_KEY_SETTX];
>>>
>>> shouldn't this already be install_mode?
>>>
>>
>> Looks like switching to NL80211_ATTR_INSTALL_MODE will throw out that,
>> but with the code from this patch that's an interim layer for checks and
>> mapping it. So I'm not sure I understand that comment.
> 
> Well, me neither. Sounds almost like I got ahead of myself.
> 
>>> You need to check if extended key ID is supported
>>
>> Yes. I have added checks in cfg80211_validate_key_settings current
>> development version already, making sure only valid combinations can be
>> called and reach this section.
> 
> Ok, great.
> 
>> NL80211_CMD_SET_KEY is normally only used to set default keys for wep or
>> managment keys. That changes here.
> 
> Right.
> 
>> In this API draft NL80211_CMD_NEW_KEY is only used when installing a
>> Extended Key ID key RX only. The switch to TX is added to
>> NL80211_CMD_SET_KEY. The code has some sanity checks and then tells the
>> driver to switch the key to tx.
> 
> Makes sense.
> 
>> But that has been changed quite a bit, the procedure in this patch
>> turned out to be not so good and even had a locking issue, so it has
>> changed a bit. I guess we should shelf that till I get the new variant
>> working and then look at it again.
> 
> Fair enough.
> 
>>>> +++ b/net/wireless/util.c
>>>> @@ -236,13 +236,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
>>>>    	case WLAN_CIPHER_SUITE_CCMP_256:
>>>>    	case WLAN_CIPHER_SUITE_GCMP:
>>>>    	case WLAN_CIPHER_SUITE_GCMP_256:
>>>> -		/* Disallow pairwise keys with non-zero index unless it's WEP
>>>> +		/* IEEE802.11-2016 allows only 0 and 1 for pairwise keys.
>>>> +		 * Disallow pairwise keys with index above 1 unless it's WEP
>>>>    		 * or a vendor specific cipher (because current deployments use
>>>> -		 * pairwise WEP keys with non-zero indices and for vendor
>>>> +		 * pairwise WEP keys with higher indices and for vendor
>>>>    		 * specific ciphers this should be validated in the driver or
>>>> -		 * hardware level - but 802.11i clearly specifies to use zero)
>>>> +		 * hardware level.
>>>>    		 */
>>>> -		if (pairwise && key_idx)
>>>> +		if (pairwise && key_idx > 1)
>>>>    			return -EINVAL;
>>>>    		break;
>>>
>>> Again, only if driver support is advertised, and the comment should
>>> probably reference the feature bit from the spec.
>>
>> That is where I added most of the sanity checks in the meantime.
>> But what feature bit from the spec are you referring to? The RSN
>> Capability one?
> 
> Well, I wasn't thinking that precisely. I just thought it should mention
> that it now says "IEEE802.11-2016 allows only 0 and 1 for pairwise keys"
> but doesn't clarify that this is only for stations that actually want to
> support it, so it could be read as being always that way.
> 
Makes sense. I'll reword that a bit.

