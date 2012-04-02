Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2DBMgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 08:36:45 -0400
Date: Mon, 2 Apr 2012 14:35:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: configure different txdesc parameters for
 non HT channel
Message-ID: <20120402123542.GA4567@redhat.com> (sfid-20120402_143648_498158_2E0DCE91)
References: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
 <CAGXE3d8C61rnWPgRU565n_FjjKTqk4pi9ncmdjxyAmEvVM-uvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGXE3d8C61rnWPgRU565n_FjjKTqk4pi9ncmdjxyAmEvVM-uvA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Mon, Apr 02, 2012 at 02:09:14PM +0200, Helmut Schaa wrote:
> Why should we use PIFS for the beacon? Is that what the ralink drivers
> are doing?
Hmm, seems that is my own invention. I thought that should be used for
beacons, but currently I can only find in docs, that this is only needed
for entering PCF.
 
> > +               else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
> > +                       txdesc->u.ht.txop = TXOP_SIFS;
> > +               else
> > +                       txdesc->u.ht.txop = TXOP_BACKOFF;
> > +
> > +               txdesc->u.ht.mcs = txrate->idx;
> > +
> 
> This lacks short preamble handling. Something like:
> 
> if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
>   txdesc->u.ht.mcs |= 0x08;
> 
> Actually, you could just shuffle the code a bit such that the rate setup
> happens before all the HT stuff, no?
Make sense.

Stanislaw
