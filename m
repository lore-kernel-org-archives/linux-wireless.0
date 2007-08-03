Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:28303 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbXHCP7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:59:37 -0400
Received: by ug-out-1314.google.com with SMTP id j3so480662ugf
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 08:59:35 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
Date: Fri, 3 Aug 2007 18:04:04 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707312037.33060.IvDoorn@gmail.com> <200708031736.27782.IvDoorn@gmail.com> <1186155722.4647.55.camel@johannes.berg>
In-Reply-To: <1186155722.4647.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708031804.04234.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, Johannes Berg wrote:
> On Fri, 2007-08-03 at 17:36 +0200, Ivo van Doorn wrote:
> 
> > But that would mean that when a non-monitor and monitor interface are
> > enabled at the same time, the montitor interface is quite pointless since
> > all frames can be caught on the regular interface as well. 
> 
> Not true, monitor mode interfaces gives you a lot more info (radiotap.)
> 
> > A monitor interface is supposed to catch as many frames as possible,
> > if a monitor interface does not catch frames not directly send to it, it won't
> > catch anything except beacons.
> 
> Not if we want to use monitor interfaces for the userspace mlme.
> 
> > Even when there is only 1 interface which is in monitor mode, the user shouldn't
> > have to set the device into promisc mode right?
> 
> Actually, imho they should have to. And tcpdump always does anyway.

Well I hope so, otherwise I'll get quite a lot of bugreports. ;)

Next rt2x00 release will not treat monitor mode interfaces special.
Just read the http://www.linuxwireless.org/en/developers/mac80211/semantics article
So the next rt2x00 will comply with that.

Ivo
