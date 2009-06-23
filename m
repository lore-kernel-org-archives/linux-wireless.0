Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55314 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZFWFgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 01:36:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 22:36:36 -0700
Date: Tue, 23 Jun 2009 11:05:02 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: ath9k_ps_restore used after ath9k_hw_detach
Message-ID: <20090623053500.GA32640@vasanth-laptop>
References: <4A3FB00F.1020104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A3FB00F.1020104@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 22, 2009 at 09:53:43PM +0530, Jiri Slaby wrote:
> Hi,
> 
> In ath_detach, there is:
> ath9k_hw_detach(sc->sc_ah);
> ath9k_exit_debug(sc);
> ath9k_ps_restore(sc);
> which is obviously wrong. sc->ah is dereferenced in restore, but it's
> already freed since detach.

Yes, this is wrong.
> 
> I don't quite understand why you try to set power while it's being
> already set to full sleep in ath9k_hw_detach.
>So I think the fix is to
> remove the restore call.

Yes, restoring the power state in ath_detach() is pointless.

I'll fix it,Thanks!.

Vasanth

