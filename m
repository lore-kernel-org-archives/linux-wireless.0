Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:59538 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYGULUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 07:20:04 -0400
Received: by py-out-1112.google.com with SMTP id p76so994484pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 04:20:03 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216606839.4847.159.camel@localhost>
References: <1216566963.4847.81.camel@localhost>
	 <20080720.102534.246150854.davem@davemloft.net>
	 <1216593170.4847.137.camel@localhost>
	 <20080720.165911.86437240.davem@davemloft.net>
	 <1216606839.4847.159.camel@localhost>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 07:20:01 -0400
Message-Id: <1216639201.4847.217.camel@localhost> (sfid-20080721_132012_278152_319A5A68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-20-07 at 22:20 -0400, jamal wrote:

> We are in sync i think, a single pfifo per TX queue is the way to go. I
> was suggesting it goes in the driver, but this is cleaner: In the

Actually, can i modify that thought and go back to my initial contention
now that things are making more sense?;->
A single s/ware queue per hardware transmit queue is good - but that
being pfifo_fast would be a lot better. It would, in the minimal, keep
things as they were for non-multiq and is a sane choice for any virtual
wire.

cheers,
jamal

