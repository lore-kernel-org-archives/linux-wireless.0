Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48745 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZCVPLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 11:11:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
Date: Sun, 22 Mar 2009 16:09:26 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org
References: <20090322174515.22f11d92@home.aephome.ru> <1237726612.19647.2.camel@johannes.local> <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com>
In-Reply-To: <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903221609.26412.mb@bu3sch.de> (sfid-20090322_161106_935894_4DC4BA20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 March 2009 15:49:50 Bob Copeland wrote:
> On Sun, Mar 22, 2009 at 8:56 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2009-03-22 at 17:45 +0500, Alexander E. Patrakov wrote:
> >
> >> There are several different panic messages,
> >> the common thing is "Fatal exception in interrupt". Without uvesafb,
> >> they also include "zd_op_tx+0x98/0x1cc [zd1211rw]" as the last line,
> >
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=3b23889bb2366c1b10f69bcca16cf53426b5e309
> >
> >> but with uvesafb, this sometimes changes to
> >> "rate_control_get_rate+0xb7/0xc3 [mac80211]".
> 
> Hmm, I've seen the rate_control one before, and there's a guy
> with ath5k who can reproduce it easily.  Looks like minstrel
> somehow gets confused about the rate table and eventually tries
> to use -1 as a valid rate index.  Neither I nor Felix could come
> up with a logical explanation, though (I am completely lost in
> the RC code, so that's not saying much for me).

There are also strange warnings in the RX path where an invalid rate_idx is
passed with the received packet. I'm pretty sure the driver does not
put an invalid rate_idx. So maybe this is related? Is it possible that
the skb->cb (where I guess the RX status and TX status are stored) is getting
corrupted after the skb got queued by the driver for processing in the
RX or TXstatus tasklet?

-- 
Greetings, Michael.
