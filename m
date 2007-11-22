Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3848 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXKVPFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:05:32 -0500
Received: from lin01.mn-solutions.de (pD95F8740.dip0.t-ipconnect.de [217.95.135.64])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id EEDF25E40F5
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:05:28 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 766F01E00FD
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:02:32 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 16:05:55 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711221514.37906.hs4233@mail.mn-solutions.de> <1195742483.4149.6.camel@johannes.berg>
In-Reply-To: <1195742483.4149.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221605.55506.hs4233@mail.mn-solutions.de> (sfid-20071122_150536_458314_211D8F87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > And this bit of info might be ESSID, wep key, wpa key, on
> > some drivers even rate or b/g limitations.
>
> Which is crap.

Crap or not, this is the way it used to work.

If mac80211 would have ditched wext and would be using nl80211, I 
wouldn't object. But it claims to be wext-compatible, but it 
isn't.

> Actually, all of these drivers misbehave because they allow
> you to associate to a network that has encryption enabled even
> if you haven't set a key!

Wrong.

I'm not aware (from those 6) that behaves that way. When I just 
enter "iwconfig eth1 essid MUMBLEFUTZ", no key, and then look 
at "iwconfig eth1", then I don't see a MAC address of the AP.

For me this is clearly a sign that they don't behave as you 
claimed.

> > It's the behavior of mac80211 with wext-compatibilty layer
> > that behaves unusually or out-of-the-order.
>
> Again, you're operating on the premise that what some drivers
> do defines wext. That's thankfully untrue and since wext
> doesn't define behaviour, the mac80211 behaviour is well in
> line.

Wrong.

Not "some", but "many" drivers did this, not some. I think 
orinoco_cs were used a lot in older days. And madwifi still 
get's used a lot.

Also I have never said that anything is defined here, or please 
show me the sentence where I wrote this. I just wrote that 
implicitly a number of drivers behave the way.

Face it or not, not everything in life is defined. Nowhere is 
defined how bees behave, and yet they behave in uniform, 
somewhat predicatable ways. So please stop this discussion about 
defined or not defined. mac80211 behaves out-of-the-order 
compared to older drivers. No matter if this behavior was 
formally defined or not.
