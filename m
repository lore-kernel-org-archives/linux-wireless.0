Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:38864 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753295AbeAaWBU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 17:01:20 -0500
Received: by mail-pg0-f43.google.com with SMTP id y27so11197239pgc.5
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 14:01:20 -0800 (PST)
Subject: Re: [PATCH 3/6] nl80211: Add CMD_CONTROL_PORT_FRAME API
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
References: <20180131213329.25322-1-denkenz@gmail.com>
 <20180131213329.25322-4-denkenz@gmail.com>
 <1517435126.2189.62.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <b59b9107-36bb-5fec-e8f0-364431095ad8@gmail.com> (sfid-20180131_230123_435762_8A9B1FCC)
Date: Wed, 31 Jan 2018 16:01:18 -0600
MIME-Version: 1.0
In-Reply-To: <1517435126.2189.62.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> + * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
>> + *	and RX notification.  This command is used both as a request to transmit
>> + *	a control port frame and as a notification that a control port frame
>> + *	has been received. %NL80211_ATTR_FRAME is used to specify the
>> + *	frame contents.  The frame is the raw EAPoL data, without ethernet or
>> + *	802.11 headers.
> 
> Never mind, so it's without Ethernet header. Is that really desirable
> though? I mean, it could be that the Ethernet address even matters (not
> sure) and it'd probably be easier to handle in (existing) userspace
> where Ethernet frames are expected now?

I also include the from address inside the NL80211 message as ATTR_MAC. 
The protocol as well.  I wrote the docs first and never updated the 
little details afterwards.  Will fix.

> 
>> + nla_put_failure:
>> +	genlmsg_cancel(msg, hdr);
> 
> nit: there's no point in cancelling if you free it (immediately).

Just following some existing code, but will fix.

> 
>> +bool cfg80211_rx_control_port(struct net_device *dev,
>> +			      const u8 *buf, size_t len,
>> +			      const u8 *addr, u16 proto, bool unencrypted)
>> +{
>> +	bool ret;
>> +
>> +	trace_cfg80211_rx_control_port(dev, buf, len, addr, proto, unencrypted);
>> +	ret = __nl80211_rx_control_port(dev, buf, len, addr, proto,
>> +					unencrypted, GFP_ATOMIC);
>> +	trace_cfg80211_return_bool(ret);
> 
> this seems wrong - you return -ERROR from __nl80211_rx_control_port()
> so you need either to pass that on as an integer to the caller, or put
> an == 0 here or something?
> 
> "Return: %true if the frame was passed to userspace"
> 

Yep, will fix.

Regards,
-Denis
