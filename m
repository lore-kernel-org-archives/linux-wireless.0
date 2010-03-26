Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:52390 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0CZBVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 21:21:15 -0400
Date: Fri, 26 Mar 2010 14:21:50 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Bruno Randolf <br1@einfach.org>
cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
In-Reply-To: <201003260927.57491.br1@einfach.org>
Message-ID: <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz>
References: <20100325054603.10697.48915.stgit@tt-desk> <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz> <20100325211311.GG7651@tux> <201003260927.57491.br1@einfach.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 26 Mar 2010, Bruno Randolf wrote:

>>>> - Improve beacon averaging algorithm for IBSS:
>>> is to turn ani off. which means the issue you raised else where of
>>> providing reasonable userland controls (not via debugfs) becomes
>>> important.
>>
>> If ANI helps IBSS so much then why not just default to turning it
>> off within the driver?
>
> i would say in most standard cases, IBSS nodes are close together or at a
> similar distance, so it does make sense to use ANI by default.
Nope - I disagree. You have made a dangerous assumption, to asume
that
   IBSS node are close together or at a similar distance

if you have a network of ibss nodes, and then look at the rate tables of 
the different nodes (minstrel is great here - it gives a fair and accurte 
represetation of the best rate possible to other nodes) you see there is 
some variation in the optimal rates between nodes.Which suggests that 
using some automatic ani algorithm in an ibss network will foreever lower 
performance for those nodes at the edge of the network.

>
> as well, we all agree that there should be userland controls. the questions is
> just about the interface to use.

Definately - need userland controls. The default for IBSS should have 
ANI off. If the user wants to "futz" with it, they can. With ANI off for 
IBSS, you ensure that on startup, the network has the greatest chance of 
working.

Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"How did you make it work??"
       "Oh, the usual, get everything right".
