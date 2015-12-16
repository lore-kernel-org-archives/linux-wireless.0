Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41386 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934103AbbLPJRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 04:17:49 -0500
Message-ID: <1450257464.3159.1.camel@sipsolutions.net> (sfid-20151216_101757_699487_0BE51FD3)
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
Date: Wed, 16 Dec 2015 10:17:44 +0100
In-Reply-To: <5670DA9A.4010102@candelatech.com> (sfid-20151216_042934_976896_DCE1A2B3)
References: <5670DA9A.4010102@candelatech.com>
	 (sfid-20151216_042934_976896_DCE1A2B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-15 at 19:29 -0800, Ben Greear wrote:
> This patch below was added to the kernel around 2/24/2015
> 
> I am curious mostly about the first change:  I thought the
> transmitter-addr relates to the radio device, not the vdev (sta, ap,
> etc).

It doesn't, even on real hardware.

> But, wouldn't using data from the header break that assumption?
> 
> 
> Is there any actual advantage to having more than one address per
> hwsim radio?  It seems it complicates things for no particular
> reason as far as I can tell?
> 

??
You can do this with any regular hardware that supports multiple
virtual interfaces - each one of them gets its own address.

I think you might be confused by how ath*k implements the address
matching - as I understand it there it's a common address (which may or
may not match the programmed hardware address) along with a mask.
That's not true in general though.

The hwsim commit here just makes wmediumd able to behave properly when
the user changed the vif interface address.

johannes
