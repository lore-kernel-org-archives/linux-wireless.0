Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdLEQbr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:31:47 -0500
Date: Tue, 05 Dec 2017 11:31:45 -0500 (EST)
Message-Id: <20171205.113145.172521292247335321.davem@davemloft.net> (sfid-20171205_173209_702313_26659857)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        dsahern@gmail.com, johannes.berg@intel.com
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171202202332.10205-1-johannes@sipsolutions.net>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat,  2 Dec 2017 21:23:31 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> This netlink type is used only for backwards compatibility
> with broken userspace that used the wrong size for a given
> u8 attribute, which is now rejected. It would've been wrong
> before already, since on big endian the wrong value (always
> zero) would be used by the kernel, but we can't break the
> existing deployed userspace - hostapd for example now fails
> to initialize entirely.
> 
> We could try to fix up the big endian problem here, but we
> don't know *how* userspace misbehaved - if using nla_put_u32
> then we could, but we also found a debug tool (which we'll
> ignore for the purposes of this regression) that was putting
> the padding into the length.
> 
> Fixes: 28033ae4e0f5 ("net: netlink: Update attr validation to require exact length for some types")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

We're stuck with this thing forever... I'd like to consider other
options.

I've seen this problem at least one time before, therefore I
suggest when we see a U8 attribute with a U32's length:

1) We access it as a u32, this takes care of all endianness
   issues.

2) We emit a warning so that the app gets fixes.

Thanks.
