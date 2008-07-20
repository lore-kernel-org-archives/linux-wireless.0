Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:55739 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbYGTReT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 13:34:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1039644rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 10:34:19 -0700 (PDT)
Message-ID: <1ba2fa240807201034u1fbe3343tdcc858f7772d2b39@mail.gmail.com> (sfid-20080720_193424_337234_E35974CD)
Date: Sun, 20 Jul 2008 20:34:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080720.102534.246150854.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216387641.4833.96.camel@localhost>
	 <20080718.140539.122169028.davem@davemloft.net>
	 <1216566963.4847.81.camel@localhost>
	 <20080720.102534.246150854.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 8:25 PM, David Miller <davem@davemloft.net> wrote:
> From: jamal <hadi@cyberus.ca>
> Date: Sun, 20 Jul 2008 11:16:03 -0400
>
>> IMO, in the case of multiple hardware queues per physical wire,
>> and such a netdevice already has a built-in hardware scheduler (they all
>> seem to have this feature) then if we can feed the hardware queues
>> directly, theres no need for any intermediate buffer(s).
>> In such a case, to compare with qdisc arch, its like the root qdisc is
>> in hardware.
>
> They tend to implement round-robin or some similar fairness algorithm
> amongst the queues, with zero concern about packet priorities.
>
> It really is just like a bunch of queues to the phsyical layer,
> fairly shared.
>
> These things are built for parallelization, not prioritization.

Except wireless where HW has prioritizing scheduler per physical non-wire.
Tomas
