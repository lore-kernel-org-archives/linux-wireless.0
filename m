Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34381 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbdCBK7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 05:59:41 -0500
Received: by mail-qk0-f182.google.com with SMTP id s186so116715308qkb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 02:59:19 -0800 (PST)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221123758.5339-2-johannes@sipsolutions.net>
 <177c53b2-cd5f-97a9-26b0-b590071785cb@broadcom.com>
 <1488445144.8390.13.camel@sipsolutions.net>
Cc: Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dc3d9463-3fdf-d3cf-ca69-50350394b487@broadcom.com> (sfid-20170302_120017_657700_97F254E4)
Date: Thu, 2 Mar 2017 11:50:44 +0100
MIME-Version: 1.0
In-Reply-To: <1488445144.8390.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2-3-2017 9:59, Johannes Berg wrote:
> 
>>> +	int	(*del_pmk)(struct wiphy *wiphy, struct
>>> net_device *dev,
>>> +			   const u8 *aa);
>>
>> Minor nit, but prefer clr_pmk to clear the pmk.
> 
> Why? You don't have "the PMK" that you can clear, you have "a PMK" (for
> the network) and after deleting it you don't have it anymore. You don't
> have a "cleared PMK" afterwards, you just don't have any. I think the
> delete makes more sense?

Ah. I just looked at set_pmk and felt its counter-part should therefor
be clr_pmk. Following your logic should it be add_pmk iso set_pmk?

>>> +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X,
>>
>> So do we need this flag. Is the fact that the driver implements the
>> set_pmk and del_pmk (or clr_pmk) callbacks not sufficient provided
>> they are listed in the "supported commands" message of wiphy dump
>> (not in this patch). Which reminds me, is "supported commands" no
>> longer preferred because that list does not seem complete?
> 
> It's complicated... We've kinda naturally gravitated towards extended
> feature flags because they're so easy to handle now (only need to
> define the bit) - and with mac80211 in the picture, relying on the
> handlers only often didn't work, so it requires extra code in the CMD()
> advertising - and anyway it already requires extra code there unlike
> the feature flags...
> 
> So overall - while this isn't stated policy (yet?) - I think we prefer
> the feature bits.

I see. Glad they worked out that way ;-)

Regards,
Arend
