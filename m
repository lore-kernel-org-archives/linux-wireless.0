Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1057 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZCaMYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 08:24:13 -0400
Date: Tue, 31 Mar 2009 08:23:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Dhaval Giani <dhaval.lists@thegianis.in>,
	linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090331122348.GA31324@hash.localnet> (sfid-20090331_142417_479648_4FCAAE0C)
References: <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com> <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com> <20090330085952.GB3837@linux.vnet.ibm.com> <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com> <20090330175951.GB4199@linux.vnet.ibm.com> <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com> <20090331035140.GC4199@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090331035140.GC4199@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 09:21:40AM +0530, Dhaval Giani wrote:
> Am not sure what the PID controller is, and google gave me a number of
> results, which did not make too much sense in the context.

CONFIG_MAC80211_RC_PID -- unfortunately I recall having to jump through
a few config hoops to enable it.

> One way I have found of reproducing it is to connect to open networks,
> but it does not happen always. At home, when my network is set to open,
> I do not see this issue, whereas at the airport, kaboom.

Ok - that is a useful data point.  Perhaps something to do with the rates
the peer supports; it would help if you could grab a scan next time you
are in the area.  Turn off auto-connect to open networks, then do:

 # iw dev wlan0 scan trigger
 # iw dev wlan0 scan dump >> dump.out    # do this a few times

Then if a particular peer triggers the problem, we can look at the 
advertised rates to see if anything jumps out.

-- 
Bob Copeland %% www.bobcopeland.com

