Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4713 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0IODIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:08:17 -0400
Date: Tue, 14 Sep 2010 23:04:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Bruno Randolf <br1@einfach.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
Message-ID: <20100915030444.GB8429@hash.localnet>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com> <AANLkTi==HEkmY4TR=r+4Ymk_55fBORmRgF+SFGQzK750@mail.gmail.com> <AANLkTim=hRJxQW+UomOQygmLjrePym=Cn-o7RzKqWc+D@mail.gmail.com> <201009150958.14525.br1@einfach.org> <AANLkTinZmv-o-tbR=2kso8jqZPTMdG=eKFCbM9DJ41d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTinZmv-o-tbR=2kso8jqZPTMdG=eKFCbM9DJ41d2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 11:06:21AM +1000, Jonathan Guerin wrote:
> > also i think current ath5k_hw_reset_tx_queue() is buggy and sets the AIFS
> > wrongly. it uses ah->ah_aifs + tq->tqi_aifs which is 2 + AR5K_TXQ_USEDEFAULT
> > which results in 2 + (-1). that does not make sense to me and i will post a
> > patch fixing up some of that confusion (but not the SIFS issue) today.
> 
> SIFS is coming up short:
> ox230/0x28 = 14us

Just a wild guess, driver may include a small fudge factor to account
for time spent in qcu.  At one point I compared all of the initvals
to those from the HAL; we're at least bug-compatible with it if there
are errors here.
 
> By the way, I may be completely wrong about some of these things, I'm
> just going off the understanding I have regarding the register values.

Well mostly no one has looked at them, so you may well have found
some problems.

FWIW if you use coverage classes (not default), we appear to use the
right values there.

-- 
Bob Copeland %% www.bobcopeland.com

