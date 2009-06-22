Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1928 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZFVAFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 20:05:53 -0400
Date: Sun, 21 Jun 2009 20:05:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090622000512.GA30186@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <1244685780-28930-8-git-send-email-me@bobcopeland.com> <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu> <20090613205737.GA30439@hash.localnet> <20090618022524.GC10014@hash.localnet> <20090619212419.2f3626d7@mjolnir.ossman.eu> <b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com> <20090621203800.08cb4a2d@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090621203800.08cb4a2d@mjolnir.ossman.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 21, 2009 at 08:38:00PM +0200, Pierre Ossman wrote:
> This does not sound very Linux:y. Module loading order should not foul
> up things. If it does, then there is some missing dependency somewhere.

Agreed.

> I noticed one more thing though. You call wl12xx_irq() on interrupts,
> and that's all you do. So I have to assume that calls back to
> wl12xx_sdio_read().

It schedules a workqueue, so it shouldn't be a problem.

> Has this code actually been tested? It doesn't seem like it can work to
> me.

Only very basic testing but yeah, it works.

-- 
Bob Copeland %% www.bobcopeland.com

