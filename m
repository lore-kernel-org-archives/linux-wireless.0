Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:13041 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGaK3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 06:29:13 -0400
Received: by rv-out-0506.google.com with SMTP id k40so484774rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 03:29:12 -0700 (PDT)
Message-ID: <1ba2fa240807310329v7256b7dcteffec3d419eb204d@mail.gmail.com> (sfid-20080731_122917_166553_907C91F2)
Date: Thu, 31 Jul 2008 13:29:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Dave Young" <hidave.darkstar@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1217497994.7813.184.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
	 <20080730195637.2197a82d.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0807311156050.27055@sbz-30.cs.Helsinki.FI>
	 <1ba2fa240807310250kd2df7bfxa3591cf78e68f8dc@mail.gmail.com>
	 <1217497994.7813.184.camel@penberg-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 12:53 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, 2008-07-31 at 12:50 +0300, Tomas Winkler wrote:
>> > There's ath5k in the stack trace but that, of course, doesn't
>> > automatically mean it's at fault here. It could have been just the poor
>> > bastard who was the next to allocate 4 KB with kmalloc() noticing the
>> > corruption.
>> >
>> > Hope this helps!
>>
>> I've seen something similar with fragmentation code in iwl4965 but I
>> can reproduce it only when using SLAB. With SLUB it didn't shown up.
>> Does anyone know what is difference between SLAB and SLUB in this context.?
>
> Do you have CONFIG_SLUB_DEBUG_ON enabled? (Note: if you only have
> CONFIG_SLUB_DEBUG enabled, then you need to enable debugging at run-time
> by passing slub_debug to kernel command line.)

Yes sure I've done that with slub_debug=FZPU
Tomas
