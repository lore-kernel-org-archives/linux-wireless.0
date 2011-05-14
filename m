Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1ENIjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 04:39:01 -0400
Subject: Re: iw connect syntax for wep
From: Johannes Berg <johannes@sipsolutions.net>
To: John Frankish <j-frankish@slb.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1305361659.3437.3.camel@jlt3.sipsolutions.net> (sfid-20110514_102747_082779_483E4E25)
References: <654DF80AD31A344E93DBCC6280BD6DEF19352F42@NL0230MBX08N1.DIR.slb.com>
	 (sfid-20110514_091121_246970_E2FF9308)  <1305361659.3437.3.camel@jlt3.sipsolutions.net>
	 (sfid-20110514_102747_082779_483E4E25)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 10:38:57 +0200
Message-ID: <1305362337.3437.6.camel@jlt3.sipsolutions.net> (sfid-20110514_103906_830179_A9BD65DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 10:27 +0200, Johannes Berg wrote:
> On Sat, 2011-05-14 at 07:01 +0000, John Frankish wrote:
> > The iw documentation and "iw --help" states the following for establishing a wep connection:
> > 
> > iw wlan0 connect foo keys 0:abcde d:1:0011223344
> > 
> > What command syntax is supposed to be used when connecting to an ap using a single wep code consisting of 13 hex pairs?
> > 
> > "iw wlan0 connect ssid keys 1:00112233445566778899AABBCC" does not work
> 
> 13 hex pairs isn't a valid key. WEP keys are either 5 or 10 bytes.

Err, no, I got confused, it's either 5 or 13 bytes of course, and the
above works fine for me. If you have iw earlier than 0.9.16 you
absolutely need to make on key default though by prefixing "d:", later
versions will automatically select one key (basically at random though).

johannes

