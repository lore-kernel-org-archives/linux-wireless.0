Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2HTKc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 06:32:29 -0400
Message-ID: <1345458739.4459.0.camel@jlt3.sipsolutions.net> (sfid-20120820_123233_336477_B2748C3B)
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Goldenshtein, Victor" <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 20 Aug 2012 12:32:19 +0200
In-Reply-To: <20120813073444.GA2272@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-7-git-send-email-victorg@ti.com>
	 <20120810163635.GC17559@redhat.com>
	 <CAK80WHbVcXtZ0on2Nsfkmj+qQ3jAaPLSc9TvGvuaCoN6P4gAOQ@mail.gmail.com>
	 <20120813073444.GA2272@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-13 at 09:34 +0200, Stanislaw Gruszka wrote:
> On Sun, Aug 12, 2012 at 10:31:29AM +0300, Goldenshtein, Victor wrote:
> > > Why we can not use ->channel_switch calback for this purpose (merge
> > > ieee80211_channel_switch and ieee80211_ap_ch_switch)?
> > >
> > 
> > Well at first (see previous threads) it was a single channel switch
> > for both AP/STA, but later after community reviews it was decided to
> > split these two.
> 
> Ah, ok. Although I do not see the point of creating almost two identical
> structures and two identical callbacks, this is up to Johannes.

Mostly the point is that the behaviour is really different in terms of
who control it and how. E.g. the timing is not synchronised, etc. In
fact I'm not even sure the timing here is done by the device? Although
it really should be I guess.

johannes

