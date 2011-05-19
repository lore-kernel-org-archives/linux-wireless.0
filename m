Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48694 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1ESBky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 21:40:54 -0400
Received: by vxi39 with SMTP id 39so1577426vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 18:40:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305758752.8827.1.camel@jlt3.sipsolutions.net>
References: <1305363652.3437.8.camel@jlt3.sipsolutions.net>
 <1305364803.3437.10.camel@jlt3.sipsolutions.net> <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com>
 <1305758752.8827.1.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 18 May 2011 18:40:33 -0700
Message-ID: <BANLkTi=0RMrBKVFFC7UUnVPyZpZvfGvK6g@mail.gmail.com> (sfid-20110519_034103_628354_43B3EAB2)
Subject: Re: [PATCH] mac80211: fix and simplify mesh locking
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 3:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-05-17 at 16:05 -0700, Javier Cardona wrote:
>
>> I'm seeing this after trying your patch, probably because the
>> allocations mesh_table_alloc() can block.  In the past I had tried to
>> allocate the table before entering the critical section.  If that is
>> not possible for the race condition you mention,  then I guess we'll
>> have to make those allocations GFP_ATOMIC?
>
> Err, now I'm confused, how could the code have done non-atomic
> allocations while under rcu_read_lock()? I guess there was just no
> verification there?

I'm not sure.  I can tell you that the bug message is only triggered
after your patch was applied, same .config.
Maybe i have an rcu configuration that does not check that.

Is making the allocations atomic an acceptable solution?

Javier
