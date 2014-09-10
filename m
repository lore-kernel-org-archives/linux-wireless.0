Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host1.ip6-networks.net ([95.130.10.56]:57480 "EHLO
	host1.ip6-networks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaIJJ1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 05:27:19 -0400
Subject: Re: 802.11p rate control
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: Emmanuel Thierry <ml@sekil.fr>
In-Reply-To: <1410339003.2761.2.camel@jlt4.sipsolutions.net>
Date: Wed, 10 Sep 2014 11:19:46 +0200
Cc: Rostislav Lisovy <lisovy@gmail.com>,
	linux-wireless@vger.kernel.org, burak.simsek@volkswagen.de,
	s.sander@nordsys.de, sojkam1@fel.cvut.cz,
	jan-niklas.meier@volkswagen.de, thierry.ernst@yogoko.fr,
	oyunaash@gmail.com, laszlo.virag@commsignia.com
Message-Id: <AD4CAB87-0EF1-4915-A576-82C359159416@sekil.fr> (sfid-20140910_112723_667532_65A02915)
References: <1410193824.10388.24.camel@umadbro> (sfid-20140908_183026_729762_39C348F0) <1410339003.2761.2.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Le 10 sept. 2014 à 10:50, Johannes Berg a écrit :

> On Mon, 2014-09-08 at 18:30 +0200, Rostislav Lisovy wrote:
> 
>> If I am not mistaken, it is not possible to live without an in-kernel
>> rate_control algorithm?
>> One interesting idea I got from one colleague is to implement the
>> algorithm logic in the user-space -- kernel would contain just a thin
>> shell controlled from the user-space (via netlink?). This is probably
>> not as insane as it may sound since the purpose of the rate-control
>> algorithm for 802.11p (at least for ITS-G5) is not to "maximize the
>> immediate throughput" but more like "shared medium congestion control",
>> which may require much slower frequency of a control loop.
> 
> I'm not really convinced this is feasible, but in any case - are you
> even communicating long enough with a single peer to make rate control
> feasible?
> 

The way i understand the problem, and as far as it is feasible, the rate-control wouldn't be done on the basis of a single peer-to-peer communication but globally according to the congestion of the shared media.

Most of messages on such link would be multicast or broadcast, in the typical use case where a vehicle/roadside station announces an accident or another danger to neighboring listeners. As a consequence, the main purpose of rate adaptation in this case would not be to ensure the delivery to a particular target, but the delivery to most available targets.


> 
> Anyway - it seems to me that you're getting ahead of yourself. Shouldn't
> you actually have a functioning datapath before worrying about rate
> control? And for that you'll need station handling in mac80211, etc.
> 

I don't know what is the exact status of the patchset in linux wireless. However we performed tests on the complete patchset published on github and didn't see major problems in terms of packet delivery.

Best regards.
Emmanuel Thierry

