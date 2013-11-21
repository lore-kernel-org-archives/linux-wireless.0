Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36333 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3KUOY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 09:24:29 -0500
Message-ID: <1385043867.10637.39.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20131121_152437_569374_0CC66EFD)
Subject: Re: [RFC] wireless, ipv4, ipv6: drop GTK-protected unicast IP
 packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Thu, 21 Nov 2013 06:24:27 -0800
In-Reply-To: <1385039307.14273.4.camel@jlt4.sipsolutions.net>
References: <1385039154-20637-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131121_140611_855342_F7C001E6) <1385039307.14273.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 14:08 +0100, Johannes Berg wrote:
> On Thu, 2013-11-21 at 14:05 +0100, Johannes Berg wrote:
> 
> > @@ -498,7 +500,8 @@ struct sk_buff {
> >  	 * headers if needed
> >  	 */
> >  	__u8			encapsulation:1;
> > -	/* 7/9 bit hole (depending on ndisc_nodetype presence) */
> > +	__u8			drop_unicast:1;
> 
> The obvious question is here, and for IPv4/IPv6 - should the wireless
> stack be responsible for doing this instead?

I don't really like the idea of reserving a bit for this in sk_buff,
and propagate it in every cloning ...

Someone should replace __copy_skb_header() by a single memset(),
because copying all these bits one by one is not really clever.

And then, adding a test in fast path (ip_rcv_finish()) is really not
nice.

I am not convinced this patch is the right way to solve the problem.



