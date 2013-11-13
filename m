Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39378 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 20:24:07 -0500
Message-ID: <5282D4AF.7070704@candelatech.com> (sfid-20131113_022411_828243_56FAD45C)
Date: Tue, 12 Nov 2013 17:23:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Association often fails first time when roaming with 802.11r.
References: <52828324.3060105@candelatech.com> <1384285594.14301.10.camel@jlt4.sipsolutions.net> <52828A27.1040103@candelatech.com> <1384287024.14301.11.camel@jlt4.sipsolutions.net> <52829163.5010201@candelatech.com> <5282AA36.2070703@candelatech.com>
In-Reply-To: <5282AA36.2070703@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 02:22 PM, Ben Greear wrote:

> I think it must have something to do with the ath9k driver resetting
> itself or maybe going to sleep when it notices no other stations are associated.  If I add
> a second station (in this case, I am roaming between two APs on the
> same channel), then the roam time is reliably < 50ms, usually around 40ms.
> 
> When I have a single station, I see kernel logs such as this
> below (I added timestamps to logging messages).
> 
> I'm dropping hostapd mailing from any further replies, as this does not
> seem to be an issue with it's logic...


Oh, my...found the problem.

I had serial console logging on, and all those extra regulatory messages makes
the difference :P

Disabled serial console and now it roams in about 13-14ms :P

/me slaps self in head with wet fish.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

