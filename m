Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:44483 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbeAOQDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 11:03:18 -0500
Received: by mail-oi0-f42.google.com with SMTP id g128so8570612oib.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 08:03:18 -0800 (PST)
Subject: Re: [RFC v2 4/5] nl80211: Implement TX of control port frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
References: <20180110170938.2341-1-denkenz@gmail.com>
 <20180110170938.2341-5-denkenz@gmail.com>
 <1516022078.410.33.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <ec908dbe-a54d-d145-9b49-964f03b5ff22@gmail.com> (sfid-20180115_170322_849045_65975927)
Date: Mon, 15 Jan 2018 10:03:16 -0600
MIME-Version: 1.0
In-Reply-To: <1516022078.410.33.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 01/15/2018 07:14 AM, Johannes Berg wrote:
> Ok this is the interesting part :-)
> 
>> +	int	(*tx_control_port)(struct wiphy *wiphy,
>> +				       struct net_device *dev,
>> +				       const u8 *buf, size_t len,
>> +				       const u8 *dest, const u16 proto,
>> +				       const bool noencrypt);
> 
> (indentation seems off in both patchwork and my email, but whatever)

Yes, that was my fault.

> 
>> +	wdev_lock(wdev);
>> +
>> +	switch (wdev->iftype) {
>> +	case NL80211_IFTYPE_STATION:
>> +		if (wdev->current_bss)
> 
> err, !current_bss?
> 

Seems fine to me?  There's a break after that if statement.

>> +	buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
>> +	len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
>> +	dest = nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +	proto = nla_get_u16(info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE]);
>> +	noencrypt =
>> +		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT]);
> 
> So this is the data we support here.
> 
> Jouni and I were talking about this and were thinking we might need
> "use old key" or something like that. That's rather difficult to do
> though, I'm not even sure we keep the old key around?
> 
> Jouni? Do you see how this could work?
> 
> 
> The other thing we thought about was that maybe we should have "open
> port after this frame", but since it's an in-band mechanism now you
> could do that also just before the frame.
> 
> FWIW, I'm checking with our guy on what other specialities we might
> want to add into this mix as far as workarounds are concerned.
> 

Sure, I'll hold off on re-spinning these until I get more feedback.

Regards,
-Denis
