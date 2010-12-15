Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:49443 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750795Ab0LOJwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 04:52:40 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0938406756
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 18:52:38 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Subject: Re: [PATCH 1/2] nl80211: Export available antennas
Date: Wed, 15 Dec 2010 18:53:10 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6> <201012141131.59086.br1@einfach.org> <AANLkTi=6o=tK1fRhOtchT9UPy+EWCcqzhebVYv+8XJP3@mail.gmail.com>
In-Reply-To: <AANLkTi=6o=tK1fRhOtchT9UPy+EWCcqzhebVYv+8XJP3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012151853.10256.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 14 2010 12:11:52 Daniel Halperin wrote:
> Several of the Intel ones, I believe.  For instance 4965 can RX with 3
> antennas but can maybe only TX with A and B?  Intel also has a 1x2
> (5100 maybe?) chipset.

A lot of maybees ;) Can anyone else comment? Do we need available antennas 
separately for RX and TX?

bruno

> On Mon, Dec 13, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
> > On Tue December 14 2010 11:23:09 Daniel Halperin wrote:
> >> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> >> > index b8fa25d..63b603c 100644
> >> > --- a/include/linux/nl80211.h
> >> > +++ b/include/linux/nl80211.h
> >> > @@ -841,6 +841,9 @@ enum nl80211_commands {
> >> >  *     the hardware should not be configured to receive on this
> >> > antenna. *     For a more detailed descripton see
> >> > @NL80211_ATTR_WIPHY_ANTENNA_TX. *
> >> > + * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are
> >> > available for + *     configuration via the above parameters.
> >> > + *
> >> 
> >> Not clear exactly what the point of this is -- there's no commit
> >> message -- but should not this API distinguish between TX and RX?
> >> E.g., several chipsets can only TX from a subset of RX antennas.
> > 
> > This is just the nl80211 part of a patch that got merged earlier, the
> > description of which has more info:
> > 
> > https://patchwork.kernel.org/patch/389682/
> > 
> > If it's necessary to distinguish between RX and TX it has to be done
> > there too. Can you give us examples of these chipsets which you
> > mentioned?
> > 
> > bruno
