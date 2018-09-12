Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:36720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbeILXVk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 19:21:40 -0400
Date: Wed, 12 Sep 2018 11:15:55 -0700 (PDT)
Message-Id: <20180912.111555.1317690378514849083.davem@davemloft.net> (sfid-20180912_201605_584618_0CF40078)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        mkubecek@suse.cz, johannes.berg@intel.com
Subject: Re: [RFC v2 1/2] netlink: add NLA_REJECT policy type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180912083610.20857-1-johannes@sipsolutions.net>
References: <20180912083610.20857-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Sep 2018 10:36:09 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some situations some netlink attributes may be used for output
> only (kernel->userspace) or may be reserved for future use. It's
> then helpful to be able to prevent userspace from using them in
> messages sent to the kernel, since they'd otherwise be ignored and
> any future will become impossible if this happens.
> 
> Add NLA_REJECT to the policy which does nothing but reject (with
> EINVAL) validation of any messages containing this attribute.
> Allow for returning a specific extended ACK error message in the
> validation_data pointer.
> 
> While at it fix the indentation of NLA_BITFIELD32 and describe the
> validation_data pointer for it.
> 
> The specific case I have in mind now is a shared nested attribute
> containing request/response data, and it would be pointless and
> potentially confusing to have userspace include response data in
> the messages that actually contain a request.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This looks great, no objections to this idea or the facility.

It does, however, remind me about about the classic problem of how bad
we are at feature support detection because unrecognized attributes are
ignored.

I do really hope we can fully solve that problem some day.
