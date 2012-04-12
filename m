Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39630 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965892Ab2DLSpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:44 -0400
Message-ID: <4F8722D4.5090203@pandora.be> (sfid-20120412_204606_349898_5D7450F0)
Date: Thu, 12 Apr 2012 20:45:40 +0200
From: Bart De Schuymer <bdschuym@pandora.be>
MIME-Version: 1.0
To: Wilco Baan Hofman <wilco@baanhofman.nl>
CC: bridge@lists.linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: Re: [Bridge] ebtables on mac80211
References: <1334183679.3337.14.camel@synlap.andoburg.net>
In-Reply-To: <1334183679.3337.14.camel@synlap.andoburg.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Op 12/04/2012 0:34, Wilco Baan Hofman schreef:
> Hi,
>
> I'm looking to implement hooks to ebtables in the mac80211 wireless
> stack.
>
> I'm trying to find the best approach for doing this.. basically what I
> want to be able to have is clients being able to communicate, but not
> ARP spoofing the gateway or setting up a rogue DHCP.
>
> As it's currently implemented, there's some sort of internal bridge
> functionality within the wireless stack in net/mac80211/rx.c at around
> ieee802_deliver_skb(), where every ethernet packet essentially gets
> routed among wireless clients.
>
> If I understand ebtables correctly, an forward event is triggered for
> every packet to every interface, right? So essentially, this should do
> the same, except that for every wireless client would be a forward from
> the wireless interface to the wireless interface.
>
> What would be the best way to implement this and in what way would it be
> acceptable upstream?
You can add a new ebtables table, requiring minimal changes to the 
userland tool. You can start by adding a table called something like 
"filter-wireless" with a built-in chain on NF_BR_FORWARD. See 
net/bridge/netfilter/ebtable_broute.c: it contains the code that adds 
the broute table with a built-in chain on NF_BR_BROUTING. This approach 
has minimal impact since it doesn't use netfilter hooks (no call to 
nf_register_hooks) and uses a built-in chain that ebtables understands.
If you want to use the netfilter infrastructure, you'll probably need a 
new protocol family. See net/bridge/netfilter/ebtable_filter.c in that case.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

