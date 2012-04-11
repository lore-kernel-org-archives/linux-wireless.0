Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from benp30.colo.bit.nl ([213.154.241.253]:35924 "EHLO
	mail.baanhofman.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2DKWnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 18:43:23 -0400
Message-ID: <1334183679.3337.14.camel@synlap.andoburg.net> (sfid-20120412_004333_489239_125B6E64)
Subject: ebtables on mac80211
From: Wilco Baan Hofman <wilco@baanhofman.nl>
To: bridge@lists.linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 00:34:39 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking to implement hooks to ebtables in the mac80211 wireless
stack.

I'm trying to find the best approach for doing this.. basically what I
want to be able to have is clients being able to communicate, but not
ARP spoofing the gateway or setting up a rogue DHCP.

As it's currently implemented, there's some sort of internal bridge
functionality within the wireless stack in net/mac80211/rx.c at around
ieee802_deliver_skb(), where every ethernet packet essentially gets
routed among wireless clients.

If I understand ebtables correctly, an forward event is triggered for
every packet to every interface, right? So essentially, this should do
the same, except that for every wireless client would be a forward from
the wireless interface to the wireless interface.

What would be the best way to implement this and in what way would it be
acceptable upstream?

Best regards,

Wilco Baan Hofman

