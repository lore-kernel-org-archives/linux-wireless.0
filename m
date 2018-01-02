Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:34440 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbeABSW7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 13:22:59 -0500
Received: by mail-pg0-f46.google.com with SMTP id j4so24595439pgp.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jan 2018 10:22:59 -0800 (PST)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20171228175832.3253-1-denkenz@gmail.com>
 <20171228175832.3253-5-denkenz@gmail.com>
 <1514899804.2024.5.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com> (sfid-20180102_192304_540837_6311AE85)
Date: Tue, 2 Jan 2018 12:22:55 -0600
MIME-Version: 1.0
In-Reply-To: <1514899804.2024.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 01/02/2018 07:30 AM, Johannes Berg wrote:
> On Thu, 2017-12-28 at 11:58 -0600, Denis Kenzior wrote:
>> This commit implements the TX side of NL80211_CMD_CONTROL_PORT_FRAME.
>> Userspace provides the raw EAPoL frame using NL80211_ATTR_FRAME.  A
>> skbuf is built and then injected onto the netdev of the wireless device.
>> The CONTROL_PORT_ETHERTYPE_NO_ENCRYPT will still in theory be honored by
> 
> You mean CONTROL_PORT_NO_ENCRYPT :-)

Right

> 
>> the underlying TX path code.
> 
> I think this isn't good enough.
> 

That was my thinking as well

> There are cases where CONTROL_PORT_ETHERTYPE_NO_ENCRYPT should be
> unset, but specific frames still shouldn't be encrypted.
> 
> So I think for this particular path it would be better to deprecate
> CONTROL_PORT_ETHERTYPE_NO_ENCRYPT entirely, and have a separate per-
> frame flag.
> 
> That also means that we can't really implement it fully in cfg80211,
> but have to provide some functionality for the driver to do things to
> be able to honour such flags.

Here's another thought I had while poking around.  Given the above I 
don't want to pursue it too seriously unless you think it might work:

We already have the IEEE80211_TX_INTFL_DONT_ENCRYPT flag on the skb and 
some drivers seem to honor this.  At least that seems to be the intent 
as the CONTROL_PORT_NO_ENCRYPT flag ends up being translated to this 
somewhere in net/mac80211/tx.c.  Are the drivers supposed to honor that 
flag?

If so, can we do something like what ieee80211_process_sa_query_req in 
net/mac80211/rx.c or ieee80211_tdls_prep_mgmt_packet in 
net/mac80211/tdls.c do?  E.g. use ieee80211_tx_skb or 
__ieee80211_subif_start_xmit or similar to inject the skb with the 
DONT_ENCRYPT flag?

> 
> Perhaps a new operation, where we pass a pre-built SKB and control
> flags?
> 

This would likely mean that legacy behavior would still have to be 
supported for quite some time (forever?) for drivers that don't get 
around to implementing this, which would be unfortunate.

Regards,
-Denis
