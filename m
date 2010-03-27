Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:48580 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0C0FSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Mar 2010 01:18:32 -0400
Received: by yxe12 with SMTP id 12so4187725yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 22:18:31 -0700 (PDT)
From: Bruno Randolf <randolf.bruno@googlemail.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Date: Sat, 27 Mar 2010 14:18:26 +0900
Cc: Derek Smithies <derek@indranet.co.nz>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>
References: <20100325054603.10697.48915.stgit@tt-desk> <201003261046.10755.br1@einfach.org> <alpine.DEB.2.00.1003270913310.3025@monster>
In-Reply-To: <alpine.DEB.2.00.1003270913310.3025@monster>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003271418.26630.randolf.bruno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 March 2010 05:34:21 Derek Smithies wrote:
> It is, essentially,  wishful thinking to assume one can have automatic ANI
> in IBSS mode.
> 
> Given that we are designing a code base to have general use, we have to
> design code that will work for the most number of people "out of the box",
> and they tune it for their situation.
>   To get IBSS to work best "out of the box" (i.e. with no tuning) for the
> most number of people you have to have ANI off
> 
> I had a siution with a IBSS network I am running here, with nodes all
> indoors. OK, they are all madwifi based, but that simply means they have
> an ANI algorithm.
>   At one end of the building, there were four nodes. At the far end of
> the building, there was one node.
> When the remote node talked to the any of the other four, rates were
> always asymmetrical. TCP throughput in one direction was half of TCP
> throughput in the other direction.
>   Why the assymmetry? Cause the four nodes had wound their ANI levels down.
> By copying sensitivity setting  code from the open sourced HAL, and with
> ANI off, the measured TCP throughput rates became much more symmetrical
> (same in both directions).
> 
> I have used madwifi for a number of years now. In networks installed
> outdoors, everything worked fine (initially). As the days went by,
> measured throughputs dropped.
>   The drop in throughput was sometimes caused by ramping,
>       (ticket 1154, also known as transmission delay)
>    sometimes by the rate algorithm failing (sample etc is quite poor)
>    but also by the nodes lowering sensitivy levels.
>    There was sometimes a considerable delay before nodes would join and
>    communicate on a network (this could have net80211 code, or ani, or ??)
> 
> > again - i'm not willing to discuss this based on guesses and assumptions.
> 
> Me too. asumptions are bad - code based on assumptions is bad.
> 
> So the question is then:
>   What is the evidence for ANI helping in IBSS mode?
>     - only when all nodes are an equal distance away from each other - you
>       have a very small network (probably 2 nodes, ANI will be great here)
> 
> > if you have test results showing that a specific ANI setting actually
> > prevented a node from joining an IBSS, i'm happy to resume this
> > discussion.
> 
> Ok, I don't (definatively) have proof of this.
>   I do have proof that automatic ANI in an IBSS network will lead to
>   assymetric TCP throughputs.

still i think that you are too fast in your conclusion that ANI needs to be 
completely disabled for IBSS mode in ath5k - based on some strange experience 
you had with madwifi. madwifi and the HAL do a lot of crazy things, and we 
don't even know how ANI was implemented exactly in the HAL you used for 
testing (was it the same like the open source version? was there a bug?).

 * maybe thruput would be good enough if we considered the minimum beacon 
RSSI?

 * maybe we should avoid to tune one specific parameter in IBSS? (like AP for 
example, only changes noise immunity level, firstep level and spur level)

 * maybe there would be another way to improve or fix the algorithm?

would it be possible that you could reproduce this situation with ath5k? if 
yes, could you find out which ANI parameter you had to change to improve 
thruput?

bruno
