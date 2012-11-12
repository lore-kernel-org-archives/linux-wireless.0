Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2KLTrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:47:23 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so4593906pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:47:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
	<CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
	<20121112192859.GB6842@localhost>
	<CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
Date: Mon, 12 Nov 2012 11:47:22 -0800
Message-ID: <CAJ-VmomZ4tqYWo=7aDY5N77GUQKj6g8Zxkbi5sWXGyRJi0aS0w@mail.gmail.com> (sfid-20121112_204731_949673_F01B30A3)
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Sam Leffler <sleffler@google.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 November 2012 11:40, Sam Leffler <sleffler@google.com> wrote:

> From my experience doing tdma on ath chipsets I know the timestamp is
> a snapshot of the tsf recorded by the dma engine when it writes the
> descriptor on dma completion.  This was only legacy frames; don't know
> how things work for aggregate frames.

RIght. Thomas did some testing (see ath9k-devel) and sees the TSF for
aggregate frames as being the timestamp of the first frame.
No idea if it's the TS of the end of the first frame in an aggregate,
or the beginning of the first frame in the aggregate.
Quite likely at anything other than the lowest MCS, it's going to be
well within a handful of 100uS.


Adrian
