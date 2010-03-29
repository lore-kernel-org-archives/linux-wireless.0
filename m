Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:49565 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755628Ab0C2C05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 22:26:57 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0576259608
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 11:26:53 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 10/10] ath5k: Adaptive Noise Immunity (ANI) Implementation
Date: Mon, 29 Mar 2010 11:26:47 +0900
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
References: <20100325054603.10697.48915.stgit@tt-desk> <20100325054952.10697.41515.stgit@tt-desk> <20100329020212.GA27628@hash.localnet>
In-Reply-To: <20100329020212.GA27628@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003291126.48054.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 March 2010 11:02:12 Bob Copeland wrote:
> On Thu, Mar 25, 2010 at 02:49:52PM +0900, Bruno Randolf wrote:
> > +	} else if (strncmp(buf, "noise-low", 8) == 0) {
> > +		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
> > +	} else if (strncmp(buf, "noise-high", 9) == 0) {
> 
> The number of characters here is off-by-one

ah, thanks!

> I also tried setting noise-high while in auto mode, but then the ani
> debug file still showed the values at 0, is that to be expected?

in auto mode, the manual settings may be changed at any time, according to the 
algorithm. if you don't want this to happen, you can echo ani-off, which will 
just stop the automatic mode and keep the last values it used, or echo sens-
high or sens-low which will also stop the auto mode, plus set the min/max 
values.
 
> On my hardware in my location, I don't really notice much of a difference
> with/without ANI, but I definitely don't get any MIB storms, so it
> gets my thumbs up.  I can post my ani file if you're interested.

so you have decent truput with and without ani? that probably means not much 
interference (OFDM and CCK error counters should be low).

bruno
