Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:65064 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbZHYT32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 15:29:28 -0400
Received: by vws33 with SMTP id 33so21986vws.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 12:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090825185842.GA7357@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
	 <20090825185842.GA7357@mosca>
Date: Tue, 25 Aug 2009 15:22:55 -0400
Message-ID: <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 2:58 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> OK how about the band info, think that's useful?

Yeah, band is useful.  We don't have to pretty print it though
(unless you really feel like it), %d would work just as well.

Also WARN_ON_ONCE might be a good idea.

>> which could indicate some
>> race condition with flushing the rx queue on channel changes.
>
> I'll see if I can reproduce somehow.
>
>> I haven't yet seen a hw rate we didn't know about.
>
> So you've seen this lately as well?

I saw it some time ago, but then changed the order of how the
curchan/curband variables were set when we change channels and
haven't seen since.  But kerneloops says a lot of other people
are still hitting it as well :(

Hmm, ath5k_rx_stop probably wants an equivalent to txq_drainq in
there somewhere.

-- 
Bob Copeland %% www.bobcopeland.com
