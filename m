Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62737 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1HZX1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 19:27:43 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 26 Aug 2011 16:27:22 -0700
Message-ID: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> (sfid-20110827_012754_366278_D8DB2F9C)
Subject: BQL crap and wireless
To: Tom Herbert <therbert@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Dave Taht <dave.taht@gmail.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've just read this thread:

http://marc.info/?t=131277868500001&r=1&w=2

Since its not linux-wireless I'll chime in here. It seems that you are
trying to write an algorithm that will work for all networking and
802.11 devices. For networking is seems tough given driver
architecture and structure and the hope that all drivers will report
things in a fairly similar way. For 802.11 it was pointed out how we
have varying bandwidths and depending on the technology used for
connection (AP, 802.11s, IBSS) a different number of possible peers
need to be considered. 802.11 faced similar algorithmic complexities
with rate control and the way Andrew and Derek resolved this was to
not assume you could solve this problem and simply test out the water
by trial and error, that gave birth to the minstrel rate control
algorithm which Felix later rewrote for mac80211 with 802.11n support
[1]. Can the BQL algorithm make use of the same trial and error
mechanism and simply try different values and and use EWMA [2] to pick
the best size for the queue ?

[1] http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/minstrel
[2] http://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average

  Luis
