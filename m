Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34350 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbbLPNVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:21:17 -0500
Received: by mail-qg0-f54.google.com with SMTP id 21so33357993qgx.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 05:21:17 -0800 (PST)
Date: Wed, 16 Dec 2015 08:21:13 -0500
From: "me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151216132113.GA4073@localhost> (sfid-20151216_142126_342525_F4B77361)
References: <5670DA9A.4010102@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5670DA9A.4010102@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2015 at 07:29:30PM -0800, Ben Greear wrote:
> This patch below was added to the kernel around 2/24/2015
> 
> I am curious mostly about the first change:  I thought the transmitter-addr
> relates to the radio device, not the vdev (sta, ap, etc).
> 
> But, wouldn't using data from the header break that assumption?

I'm not sure this assumption is correct.  I have a hard time
seeing the value in basing the transmitter addr attribute on some
hardware address that may not even be used.

> Is there any actual advantage to having more than one address per
> hwsim radio?  It seems it complicates things for no particular
> reason as far as I can tell?

As a practical matter: the radios already have two "hardware"
addresses, and as reported in the commit log, only one of them
worked with the netlink interface, and it wasn't even the default
address.

I suppose there's no real benefit to multi-vif on hwsim vs multiple
phys, other than testing multi-vif support in the stack, but why not?
I think this patch actually simplifies things.

Does this patch cause problems for your userspace implementation?

-- 
Bob Copeland %% http://bobcopeland.com/
