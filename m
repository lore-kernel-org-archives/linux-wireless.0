Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:55406 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbXIAJrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:47:43 -0400
Message-ID: <46D9353C.2080509@warmcat.com>
Date: Sat, 01 Sep 2007 10:47:40 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: radiotap injection bugs & extending it
References: <1188609135.7585.105.camel@johannes.berg>	 <46D92A1C.4050308@warmcat.com> <1188637615.7585.118.camel@johannes.berg>	 <46D92EFC.2060007@warmcat.com> <1188639380.7585.130.camel@johannes.berg>
In-Reply-To: <1188639380.7585.130.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> Well, for one, the PS code is only relevant if we're ourselves operating
> in IBSS or AP mode. If we're operating in AP/IBSS mode we'll also
> automatically buffer your injected multicast frames for after the DTIM
> beacon. I think we should just buffer injected unicast frames as well,
> it won't hurt your use case (multicast destination) and makes things
> more consistent.

Fine by me.

>> For sure things will be much better and more consistent if we can inject
>> down unassociated interfaces reliably, so this is a nice move.
> 
> Well, no, that's unrelated, and it's a bug in iwlwifi that it craps out
> over that ;)

There are other problems hiding somewhere, perhaps iwl3945, as well.
Having a secondary network interface like mon0 in Monitor mode is still
not quite the same as having the primary network interface in Monitor mode.

Externally generated Packetspammer broadcasts are not visible down a
monitor mode secondary network interface with current wireless-dev on
iwl3945 in the case where it is associated to a network and a secondary
network interface is in Monitor mode.

Deassociate and stick the wlan0 interface in Monitor mode though
(without changing or deleting the mon0 interface) and you suddenly see
the packetspammer broadcasts from the other box just fine.

-Andy
