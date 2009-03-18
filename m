Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16908 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZCRPZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 11:25:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: GSoC project proposals
Date: Wed, 18 Mar 2009 16:25:02 +0100
Cc: Mircea Gherzan <mgherzan@gmail.com>
References: <20090318033600.4d17be51@beast3>
In-Reply-To: <20090318033600.4d17be51@beast3>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903181625.02692.hs4233@mail.mn-solutions.de> (sfid-20090318_162527_024746_0DA42129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From the publised list, I am most interested in the roaming
> project. Please, can anyone tell me who will be mentoring it,
> so I cand get in touch with him/her?

I wonder where the list has been published?


Basically, a patches version of the old madwifi driver still 
roams better than mac80211-based WLAN cards. The latter have 
currently mostly written for "Hotspot"-operation. That is a 
laptop in the vincinity of one access-point.

In my company, I'd be in need for real roaming, as a storage 
warehouse has often 10-40 access-points and the client needs to 
know when to switch to a new one, ideally proactively. And as a 
moder fork-lift is quite fast, you'll need to be quick and 
adept :-)

Helmut Schaa once indicated that he has something in petto, but 
that was weeks ago. But maybe he still has ideas/hints about 
this.

I could help with testing things in a "real" environment, as a 
storage warehouse of one of our customers is just round the 
corner :-)



If I would have to implement it, I'd do rought this:

1) create a consistent picture of available access-points

You can do:

a) scan when needed
b) constantly background scanning
c) a combination of those

With c) I mean the following scheme:

WLAN card receives the broadcasts of the APs anyway, no matter if 
you do an "iwlist XXX scan" or the "iw" equivalent or not. So 
this information could be store into some sort of "database" 
inside mac80211.

Now consider you client is moving, e.g. in a car, on a bike, or 
(in my case) your device is mounted to a fork-lift terminal. 
That means that you have to age the information in 
your "database". Old entries aren't as reliable for roaming 
decisions as new ones. And entries that didn't get an update for 
n seconds (e.g. 5 seconds) are useless.

Also consider that still some network admins think that "hidden 
ESSID" is a security feature and turn this beast on. So even 
with a got SNR a new entry in your bss list might not be 
eligible for roaming, because the AP might have a different 
SSID.



2) Decide when to roam

You should really do this before your current connection stalls, 
e.g. when you find that some other AP is X points better then 
the current one.


3) Decide who roams

In history, we had fullmac drivers (like orinoco_cs or 
wlags_h2_cs) that did all the roaming. For some chipsets used 
for embedded or portable devices, we still have those (e.g. 
libertas_sdio, libertas_cs, the ar5000-driver). But now we have 
mostly software chipsets, so concentrate on this.

However, the fullmac driver do their own roaming. After they did 
that, they notified WPA-Supplicant about the fact. That worked 
quite well, even with WPA and WPA2.

However, I've heard many people that said a roaming decision 
should be done in user-space, by Network-Manager or 
wpa_supplicant and that this is not the business of 
kernel-space.

Now I also have some experience with very light embedded devices 
(e.g. one with an AVR32 CPU has just 8 MB flash, yet it runs 
Linux!). For me the idea of putting Network manager there isn't 
appealing. However, wpa_supplicant is there anyway :-)

But I also claim that within mac80211 you have more information, 
in a "realtime" manner. If you want to relay all of this to 
user-land: okay, possible, via nl80211. But then your device 
will wakeup one or more user-space processes and consumes more 
power (one of my handheld devices can, with a 3200 mAh 
accumulator, survice for more than 8 hours with full WLAN 
connectivity!).

However, you can't do thing "against" the community, so if the 
word is "we do this in NM", then you'll have to do that. :-)  In 
this case be prepared to dive not only into mac80211, cfg80211 
and nl80211, but also into wpa_supplicant and/or nm (at least 
partially).


Some more thoughts: when one roams via wpa_supplicant / 
Network-Manager, it's usually quite easy to roam to very 
different networks, e.g. you can have two network entries "Home 
SCHURIG, WPA2" and "Company, MNSOLUTIONS, 802.11x with TTLS, 
CHAP and Radius".

However, in an environment where you have lots of identically 
configured APs (e.g. 30 APs on different channel, but all with 
the same ESSID and the same encryption scheme) it's usually 
beneficial to roam at a driver level.


4) Think about the future

There are 802.11 extensions for a fast handoff. Not sure if you 
want to implement anything of this, but at least consider them, 
so that adding support for them won't be harder than it should 
be :-)
