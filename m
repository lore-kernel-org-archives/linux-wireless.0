Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35170 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0LFSBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 13:01:39 -0500
Received: by iwn9 with SMTP id 9so483464iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 10:01:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012061714.15863.br1@einfach.org>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
Date: Mon, 6 Dec 2010 19:01:38 +0100
Message-ID: <AANLkTinjO5vEm+dSXBULYaAeBmQQv8jVqzcDLu0UhwZv@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 9:14 AM, Bruno Randolf <br1@einfach.org> wrote:
[snip]
>
> Other examples:
>
> *** txdesc tries 2
> *** mrr 0 tries 9 rate 12
> *** mrr 1 tries 2 rate 13
> *** mrr 2 tries 3 rate 11
>
> = 16 transmissions in sum.
>
> *** txdesc tries 9
> *** mrr 0 tries 3 rate 11
> *** mrr 1 tries 9 rate 8
> *** mrr 2 tries 3 rate 11
>
> = 24 transmissions in sum. Again, rate[1] and rate[3] are the same, so why
> bother setting it up twice?

I remember from experimenting with rate control in madwifi that weird
stuff can happens when you go above ATH_TXMAXTRY = 13 tx attempts in
total (all mrr segments combined). We thought we saw some significant
improvement on poor links when we reduced retries to fit the whole mrr
chain into 13 retries in total, but we didn't have the equipment to
really verify that. Perhaps something you could try Jonathan in your
excellent testbed?

/Björn
