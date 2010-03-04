Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3404 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0CDOON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 09:14:13 -0500
Date: Thu, 4 Mar 2010 09:12:57 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Derek Smithies <derek@indranet.co.nz>
Cc: Bj?rn Smedman <bjorn.smedman@venatech.se>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
Message-ID: <20100304141256.GA1985@hash.localnet>
References: <4B8C3A21.2050105@openwrt.org> <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com> <4B8D25DC.8070502@openwrt.org> <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com> <alpine.DEB.2.00.1003031006390.10063@kauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.1003031006390.10063@kauri>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 03, 2010 at 10:55:26AM +1300, Derek Smithies wrote:
> PID got it wrong - implicit in PID is the assumption that the rates can 
> be ordered in terms of more successful / less successful - and the 
> ordering follows the speed (faster speed=less successful).
>
> Since very slow rates are subject to interference loss (imagine there is 
> a 60hz transmitter out there) packets that take a long time to transmit 
> are far more likely to be shot down, stepping down a rate is going to 
> increase the loss rate.

PID has more problems than just that -- it has lots of oscillation even
when the rate is relatively stable.  See this chart which I
made using mac80211 hwsim and simulated loss (this was after I fixed
the problem in commit e850f68b8f):

http://bobcopeland.com/srcs/tcp_perf.pdf

My simulation involved no collisions and just reduced the SNR over
time.  AARF in this case is an algorithm from academia, which is
susceptible to collision related-loss as you describe above.
In this example, it performed badly because of the latency inherent
between packet queuing and status reporting.

Minstrel definitely performs better in real life.

That said, I looked at the current minstrel code and have a few
puzzlements:

- As I understand it, minstrel is not supposed to delay packets more
  than 24 ms to avoid TCP resends.  However, if I understand the code,
  this is done by limiting each MRR segment to 6 ms, which doesn't seem
  right to me.  The retries in the second MRR slot will have to wait
  a backoff before being used, right?

- Often, two slots in the MRR array use the same rate (e.g. slots 1 and 3).
  Maybe we should pick a 'next lower' rate for the lower slot in such a case?
  If we are really in a place where the originally attempted rate isn't
  workable, this might slightly boost throughput. 
 
The large spikes at rate transition boundaries aren't quite so deep with
fewer retries.

-- 
Bob Copeland %% www.bobcopeland.com

