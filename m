Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34461 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1K1BpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 20:45:12 -0500
Received: by vbbfc26 with SMTP id fc26so3389065vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 17:45:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNwqhUXQqxnNKq_Cm7dC_mkw_RSa8DUMXh9y=YYk_yDb2g@mail.gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
	<1322246431-10825-2-git-send-email-mickflemm@gmail.com>
	<CAJ-Vmom6LyS173ZgH_6kODx5pmG0k_8CCgBKmCPFd_8=vwiJPw@mail.gmail.com>
	<CAFtRNNwqhUXQqxnNKq_Cm7dC_mkw_RSa8DUMXh9y=YYk_yDb2g@mail.gmail.com>
Date: Mon, 28 Nov 2011 09:45:11 +0800
Message-ID: <CAJ-Vmokt78qnXsvRUVrL6q-oV+JSH6xjJRafJY_Z_Ej1pnvkQg@mail.gmail.com> (sfid-20111128_024517_200742_A64E0AEF)
Subject: Re: [PATCH v2 01/12] ath5k: Switch from read-and-clear to
 write-to-clear method when handling PISR/SISR registers
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 November 2011 03:59, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> Oh wait. Where are you clearing these bits? It doesn't look like
>> you're even clearing the ah_txq_isr bits in the most recent ath5k tree
>> I have here. This means you're likely not missing events; but you're
>> likely always scanning those queues. Making this code a bit pointless.
>> :)
>
> Yup we don't clean them but that's not a bug, we still only check
> active queues that produced interrupts, not everything. Anyway we have
> txq->lock already so it's not a big deal to implement this I'll post a
> patch on top of this patchset.

Right. but you're likely only using one active TXQ (and then CAB and
beacon queues, which you may not be actually checking the completion
status of) it won't matter. It just means if people start using >1
hardware TXQ, you're going to check the completion status on all of
them. That's not a big deal, it just means you'll spend some CPU
cycles and memory accesses checking queues you don't need to.

You can't protect that interrupt field behind the TXQ lock either,
since you'll have multiple reader/writers from outside the TXQ. Hence
why I put it behind my PCU lock (which I use to protect shared PCU
state, rather than PCU access like how felix did with ath9k.)



Adrian
