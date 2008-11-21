Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:37474 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYKUUWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:22:43 -0500
Received: by rn-out-0910.google.com with SMTP id k40so963826rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:22:42 -0800 (PST)
Message-ID: <b6c5339f0811211222t745c65fve38958c9baa98e46@mail.gmail.com> (sfid-20081121_212255_682538_52E27A8F)
Date: Fri, 21 Nov 2008 15:22:41 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Fabio Rossi" <rossi.f@inwind.it>
Subject: Re: ath5k: problems during the connection to a sitecom AP
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200811192315.35537.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200811150207.12084.rossi.f@inwind.it>
	 <200811172120.11299.rossi.f@inwind.it>
	 <b6c5339f0811180748q354124d2pc3ee9eb3e3cfc745@mail.gmail.com>
	 <200811192315.35537.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 5:15 PM, Fabio Rossi <rossi.f@inwind.it> wrote:
> I've attached a kernel log of what's happening and a commands log with time
> references. I hope it's useful, tell me if you need other data.

Ok, well at least we know we see beacons from the AP in question.
Other than that, it doesn't help a whole lot, as all the log captured
was beacons from various APs.  Can you try again without the 'trace'
option?  Also if you turn on CONFIG_MAC80211_VERBOSE_DEBUG then we
can see the probe requests etc.

If you do have another wireless card, that would still be better.  You
can use it like this:

   # ifconfig wlan1 down
   # iwconfig wlan1 mode monitor
   # ifconfig wlan1 up
   # tcpdump -s 1000 -w assoc.cap -i wlan1

Then you can load assoc.cap into wireshark (you can capture from inside
wireshark too if you prefer).

-- 
Bob Copeland %% www.bobcopeland.com
