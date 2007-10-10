Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20550 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXJJTAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 15:00:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: automatically re-associate
Date: Wed, 10 Oct 2007 21:00:14 +0200
References: <200710091404.31491.hs4233@mail.mn-solutions.de> <200710100943.33106.hs4233@mail.mn-solutions.de> <1192028338.9739.28.camel@localhost.localdomain>
In-Reply-To: <1192028338.9739.28.camel@localhost.localdomain>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710102100.15274.hs4233@mail.mn-solutions.de> (sfid-20071010_200024_212617_8C8930E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> so in libertas_mac_event_disconnected() it should to be something like
> the following:
...



I'll look in some of the next days again into this. Today and tomorrow 
I'm busy with other things.

Oh, and BTW, today I found by chance another reason why auto-reassoc is 
helpful and necessary :-)   On a Cisco 1231 AP I played a bit with the 
command interface. And there was a command to check how busy all the 
channels are. When I issued this command, I saw in the log of the Cisco 
(I'm sending it to the console) and also in the syslog of the machine 
running the libertas driver that the Cisco IOS sent an disassociation 
to all clients. Then it went checking for busy channels and gave me 
some output. After this, two client (one libertas, one other) 
automatically re-associated and things continued as if nothing would 
have happened.

Now, in a Cisco AP you can specify the channel for the AP. And you can 
also say "Use least congested Frequency". This makes the AP does this 
channel scanning --- that I issued manually --- do automatically. With 
the current current code, my libertas driven card would have been 
stuck ...



As for WPA driven environments: you can operate WPA supplicant in two 
modes. In one modes does WPA does the work of selecting which AP to 
use. It also sends the equivalent of "iwconfig ethX ap 
xx:XX:XX:XX:XX:XX" to the card.

In the other mode (I think it is "ap_scan=2"), wpa_supplicant just 
reacts to a re-association that the driver did without further fuzz.

I guess that your issues are with the first mode?
