Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:62783 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0CZUeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 16:34:25 -0400
Date: Sat, 27 Mar 2010 09:34:21 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Bruno Randolf <br1@einfach.org>
cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
In-Reply-To: <201003261046.10755.br1@einfach.org>
Message-ID: <alpine.DEB.2.00.1003270913310.3025@monster>
References: <20100325054603.10697.48915.stgit@tt-desk> <201003260927.57491.br1@einfach.org> <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz> <201003261046.10755.br1@einfach.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 26 Mar 2010, Bruno Randolf wrote:
>
> yeah, we all know how great minstrel is... really.
Thanks for the praise on Minstrel.
Felix has done, and is doing, some good work on getting it into the 
kernel. And of course, his current work with minstrel in 802.11 N

>
> i said in most *standard* cases - the standard case for IBSS is still 3 or 5
> guys sitting in a room, or close by, wanting to exchange some data. we should
> have good performance for that, therefore ANI on by default.
It is, essentially,  wishful thinking to assume one can have automatic ANI 
in IBSS mode.

Given that we are designing a code base to have general use, we have to 
design code that will work for the most number of people "out of the box", 
and they tune it for their situation.
  To get IBSS to work best "out of the box" (i.e. with no tuning) for the 
most number of people you have to have ANI off

I had a siution with a IBSS network I am running here, with nodes all 
indoors. OK, they are all madwifi based, but that simply means they have 
an ANI algorithm.
  At one end of the building, there were four nodes. At the far end of 
the building, there was one node.
When the remote node talked to the any of the other four, rates were 
always asymmetrical. TCP throughput in one direction was half of TCP
throughput in the other direction.
  Why the assymmetry? Cause the four nodes had wound their ANI levels down. 
By copying sensitivity setting  code from the open sourced HAL, and with
ANI off, the measured TCP throughput rates became much more symmetrical 
(same in both directions).

I have used madwifi for a number of years now. In networks installed 
outdoors, everything worked fine (initially). As the days went by, 
measured throughputs dropped.
  The drop in throughput was sometimes caused by ramping,
      (ticket 1154, also known as transmission delay)
   sometimes by the rate algorithm failing (sample etc is quite poor)
   but also by the nodes lowering sensitivy levels.
   There was sometimes a considerable delay before nodes would join and
   communicate on a network (this could have net80211 code, or ani, or ??)

> again - i'm not willing to discuss this based on guesses and assumptions.
Me too. asumptions are bad - code based on assumptions is bad.

So the question is then:
  What is the evidence for ANI helping in IBSS mode?
    - only when all nodes are an equal distance away from each other - you
      have a very small network (probably 2 nodes, ANI will be great here)

> if you have test results showing that a specific ANI setting actually
> prevented a node from joining an IBSS, i'm happy to resume this discussion.
Ok, I don't (definatively) have proof of this.
  I do have proof that automatic ANI in an IBSS network will lead to
  assymetric TCP throughputs.

Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

