Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13745 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759717AbZEFUMd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 16:12:33 -0400
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
 on 802.11a capable card
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <20090506172513.GB30070@tuxdriver.com>
References: <1241626486.30590.13.camel@mj>
	 <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
	 <20090506172513.GB30070@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 06 May 2009 16:12:31 -0400
Message-Id: <1241640751.3289.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-06 at 13:25 -0400, John W. Linville wrote:
> On Wed, May 06, 2009 at 12:36:13PM -0400, Bob Copeland wrote:
> > On Wed, May 6, 2009 at 12:14 PM, Pavel Roskin <proski@gnu.org> wrote:
> > > Hello!
> > >
> > > If I scan by "iw dev wlan0 scan" while sending data through the
> > > interface, I get a BUG in net/mac80211/tx.c:
> > 
> > Agreed... Also I think the same thing happens for rx for ath5k,
> > explaining the 'unknown rate index' warnings (sc->curband changes
> > during scan but we process a beacon from 2ghz band, that one at
> > least just needs some synchronization in the driver).
> 
> Ah, that could be -- I sure am tired of reading bug reports about
> that...

I've bisected it.  The problem is introduced by the commit
2038ccfbb5f7fc7d8bca26bf53bdd6c7778136ff:

Author:     Johannes Berg <johannes@sipsolutions.net>
AuthorDate: Wed Apr 29 12:26:17 2009 +0200
Commit:     John W. Linville <linville@tuxdriver.com>
CommitDate: Thu Apr 30 15:06:34 2009 -0400

    mac80211: tell driver when idle

    When we aren't doing anything in mac80211, we can turn off
    much of the hardware, depending on the driver/hw. Not doing
    anything, aka being idle, means:
...

-- 
Regards,
Pavel Roskin
