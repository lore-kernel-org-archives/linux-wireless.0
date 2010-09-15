Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12429 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751818Ab0IOA6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 20:58:12 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0293012286
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 09:58:10 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
Date: Wed, 15 Sep 2010 09:58:14 +0900
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com> <AANLkTi==HEkmY4TR=r+4Ymk_55fBORmRgF+SFGQzK750@mail.gmail.com> <AANLkTim=hRJxQW+UomOQygmLjrePym=Cn-o7RzKqWc+D@mail.gmail.com>
In-Reply-To: <AANLkTim=hRJxQW+UomOQygmLjrePym=Cn-o7RzKqWc+D@mail.gmail.com>
Cc: "ath5k-devel" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009150958.14525.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed September 15 2010 08:07:36 Jonathan Guerin wrote:
> I'm capturing using a third-party station. I've had to use a Madwifi
> station, as ath5k throws a lot of spurious timestamps up, which make
> calculating this very, very difficult.

ah, that's interesting and something we should check, too...

> Actually, I've found that they were exactly one slot time negative
> (give or take 1us). That said, I was doing these calculations using
> the 802.11a OFDM spec timings. I looked at the driver and realised
> that SIFS is actually being initialised to 14us, whereas it should be
> set to 16us. This will also affect DIFS. Once I take these into
> consideration, they come up as approximately 4-5us out. Now that I
> think about it, it could make sense.

hmm, we have a function ath5k_hw_get_default_sifs() which returns 16 for 
802.11a, but it's not used for setting the IFS...

also i think current ath5k_hw_reset_tx_queue() is buggy and sets the AIFS 
wrongly. it uses ah->ah_aifs + tq->tqi_aifs which is 2 + AR5K_TXQ_USEDEFAULT 
which results in 2 + (-1). that does not make sense to me and i will post a 
patch fixing up some of that confusion (but not the SIFS issue) today.

bruno
