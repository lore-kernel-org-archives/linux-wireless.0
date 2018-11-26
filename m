Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BB0C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 05:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738F520865
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 05:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EbVfu8QI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EbVfu8QI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 738F520865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbeKZQcI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 11:32:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbeKZQcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 11:32:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA0FD6020A; Mon, 26 Nov 2018 05:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543210748;
        bh=4d0xy/PhHLzWxIZ2LCIjMiZoilJhqwu521CNEGmL1ZM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EbVfu8QI31n4gjIRgDwKw5r32FO6+KJ2qOuIFs6ov9tBhnoNMLEQE8J3teW++cIh3
         qRWCRap4ztTktbDPZRbNU+8Zx3aq/lz9FiDpc4v565iUsRhaqdasQdlnLZTGm8Y8SU
         J/Rv5q2f+cbu24YIbVXLldblBHDIqXqgaf/bwaLU=
Received: from [192.168.225.40] (unknown [157.50.27.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mpubbise@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0EDB26020A;
        Mon, 26 Nov 2018 05:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543210748;
        bh=4d0xy/PhHLzWxIZ2LCIjMiZoilJhqwu521CNEGmL1ZM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EbVfu8QI31n4gjIRgDwKw5r32FO6+KJ2qOuIFs6ov9tBhnoNMLEQE8J3teW++cIh3
         qRWCRap4ztTktbDPZRbNU+8Zx3aq/lz9FiDpc4v565iUsRhaqdasQdlnLZTGm8Y8SU
         J/Rv5q2f+cbu24YIbVXLldblBHDIqXqgaf/bwaLU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0EDB26020A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mpubbise@codeaurora.org
Subject: Re: [PATCH] {nl,mac}80211: allow 4addr AP operation on crypto
 controlled devices
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <1542798228-3293-1-git-send-email-mpubbise@codeaurora.org>
 <3ce0f8352354900cd89074bcafe6ac45c29abd78.camel@sipsolutions.net>
From:   Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <cad9cfed-92b5-bea1-a1a1-6b9c45d90056@codeaurora.org>
Date:   Mon, 26 Nov 2018 11:09:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <3ce0f8352354900cd89074bcafe6ac45c29abd78.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/25/2018 12:18 AM, Johannes Berg wrote:

> This looks good to me, just a few nits below
>
> On Wed, 2018-11-21 at 16:33 +0530, Manikanta Pubbisetty wrote:
>> As per the current design, for sw crypto controlled devices, it is
>> the device which has to advertise the support for AP/VLAN iftype
>> based on it's capability to tranmsit packets encrypted in software
>> (In VLAN functionality, group traffic generated for a specific
>> VLAN group is always encrypted in software). Commit db3bdcb9c3ff
>> ("mac80211: allow AP_VLAN operation on crypto controlled devices")
>> has introduced this change.
>>
>> Since 4addr AP operation also uses AP/VLAN iftype, this conditional
>> way of advertising AP/VLAN support has broken 4addr AP mode operation on
>> crypto controlled devices which do not support VLAN functionality.
>>
>> For example:
>> In the case of ath10k driver, not all firmwares have support for VLAN
>> functionality but all can support 4addr AP operation. Because AP/VLAN
>> support is not advertised for these devices, 4addr AP operations are
>> also blocked.
>>
>> Fix this by allowing 4addr opertion on devices which do not advertise
> operation
>
>> AP/VLAN iftype but which can support 4addr operation (the desicion is
> decision
>
>> taken based on the wiphy flag WIPHY_FLAG_4ADDR_AP).
>> Fixes: Commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on
>> crypto controlled devices")
> I think it'd be better not to wrap this

Sure, I'll fix them all in the next version.

>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -1394,8 +1394,13 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>>   		}
>>   		break;
>>   	case NETDEV_PRE_UP:
>> -		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
>> -			return notifier_from_errno(-EOPNOTSUPP);
>> +		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype))) {
>> +			if (!(wdev->iftype == NL80211_IFTYPE_AP_VLAN &&
>> +			      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
>> +			      wdev->use_4addr))
>> +				return notifier_from_errno(-EOPNOTSUPP);
>> +		}
> Maybe that could be combined into one condition? It's kinda hard to read
> either way though. I was thinking of making it positive, but then the
> ERFKILL
>
>>   		if (rfkill_blocked(rdev->rfkill))
>>   			return notifier_from_errno(-ERFKILL);
> would have to be _before_ it, and I'm not sure we want to change that.
>
> So maybe make it
>
> if (!(interface_modes & BIT() ||
>        (iftype == AP_VLAN && use_4addr && wiphy.flags & 4ADDR_AP)))
> 	return ...(-EOPNOTSUPP);
>
> instead?
>
> I feel that's still easier to read than the double conditional with both
> things being negated.

Yeah, It makes sense; I'll change it.

>
>> +++ b/net/wireless/nl80211.c
>> @@ -3383,8 +3383,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>>   	if (info->attrs[NL80211_ATTR_IFTYPE])
>>   		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
>>   
>> -	if (!rdev->ops->add_virtual_intf ||
>> -	    !(rdev->wiphy.interface_modes & (1 << type)))
>> +	if (!rdev->ops->add_virtual_intf)
>>   		return -EOPNOTSUPP;
>>   
>>   	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
>> @@ -3403,6 +3402,13 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>>   			return err;
>>   	}
>>   
>> +	if (!(rdev->wiphy.interface_modes & (1 << type))) {
>> +		if (!(type == NL80211_IFTYPE_AP_VLAN &&
>> +		      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
>> +		      params.use_4addr))
>> +			return -EOPNOTSUPP;
>> +	}
> I'm not sure you should insert this further down, rather tahn at the
> place where the check was before? Why not just insert this part directly
> after the piece you modified above?

I had to move it because use_4addr is only known after the NL_ATTR_4ADDR 
check.

-Manikanta
