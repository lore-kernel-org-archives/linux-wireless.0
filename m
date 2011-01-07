Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51445 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1AGWew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:34:52 -0500
Received: by wwa36 with SMTP id 36so18976953wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 14:34:51 -0800 (PST)
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D2791BD.7050502@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
	 <1294397880.3467.1.camel@jlt3.sipsolutions.net>
	 <4D275CCC.90905@candelatech.com>  <20110107200913.GF21588@tux>
	 <1294432018.2709.2.camel@edumazet-laptop>
	 <4D2791BD.7050502@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 23:26:11 +0100
Message-ID: <1294439171.2709.6.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 07 janvier 2011 à 14:20 -0800, Ben Greear a écrit :
> On 0
> > Using skb_copy() is wrong then, since it makes a copy (order-1
> > allocations)
> >
> > It should use :
> >   skb_alloc( actual_size_of_frame  not the 3840 thing ...)
> >   copy(data)
> 
> We need the extra stuff copied too I think (like skb->cb).
> 
> If you could provide a bit more complete example code, I'll be happy
> to test it...

take a random drivers/net using copybreak ... say ... tg3.c

lines 4785

len = length_of_the_current_frame
copy_skb = netdev_alloc_skb(...,  len); 
// allocates exact required size not a byte more....
...
skb_copy_from_linear_data(skb, copy_skb->data, len);
...
skb_put(skb, len);
...






