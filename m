Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19625 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbZI3Qsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 12:48:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 09:48:54 -0700
Date: Wed, 30 Sep 2009 09:48:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Matt Tierney <matt.tierney@post.harvard.edu>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Possible to set MCS Index?
Message-ID: <20090930164853.GA5730@mosca>
References: <d355d36c0909300814w302f11a4rb5b23a80aee36c43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <d355d36c0909300814w302f11a4rb5b23a80aee36c43@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 08:14:57AM -0700, Matt Tierney wrote:
> This might be a naive question, but I was wondering if it's 
> possible to set the MCS index either from a high level interface 
> or through a hack in the ath9k code. I'd like to fix the MCS Index
> to 15 but I don't know where that is set or if I can 'force' it
> through modifying the ath9k code in wireless-testing. (It doesn't
> appear as if iw provides that sort of functionality and it wasn't
> clear that I could specify a HT rate in hostapd.conf.)

mac80211 rate control code is MCS rate unaware, but we do at least
let drivers pass the MCS rate for tx status reporting. ath9k
unfortunately reports back the wrong MCS rate though because
of the way ath9k rate control works... it seems correcting this
requires a rewrite of our ath9k rate control code and no one has
prioritized on that as its a non-functional fix.

The first step then is to make mac80211 rate controle code MCS
aware and adding MCS rate control support to minstrel, for example.

For ath9k it'd be nice to fix the rate control code to be able
to report the right MCS index, I really am not sure how involved
that is as I've tried to stay away from the rate control code.

A good step would be to get ath9k rate control to be switchable
to minstrel, for example. This can be done as a module parameter
to start but eventually I think it'd be nice to be able to switch
through iw on any given device. That would require quite a lot of
work though.

Once mac80211 is MCS rate control aware the next step would be to
add a commands to set an MCS rate.

The cheesy and quick way to this for ath9k would be through
ath9k/debufs.c

  Luis
