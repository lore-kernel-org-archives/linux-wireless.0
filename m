Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:1383 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759038Ab0LNCbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 21:31:47 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0159163904
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 11:31:45 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Subject: Re: [PATCH 1/2] nl80211: Export available antennas
Date: Tue, 14 Dec 2010 11:31:59 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6> <AANLkTinS35SU=RZ+G=b6Q1729Zpfm5cfqjTNOCr6zSe4@mail.gmail.com>
In-Reply-To: <AANLkTinS35SU=RZ+G=b6Q1729Zpfm5cfqjTNOCr6zSe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012141131.59086.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 14 2010 11:23:09 Daniel Halperin wrote:
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index b8fa25d..63b603c 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -841,6 +841,9 @@ enum nl80211_commands {
> >  *     the hardware should not be configured to receive on this antenna.
> >  *     For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
> >  *
> > + * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are
> > available for + *     configuration via the above parameters.
> > + *
> 
> Not clear exactly what the point of this is -- there's no commit
> message -- but should not this API distinguish between TX and RX?
> E.g., several chipsets can only TX from a subset of RX antennas.

This is just the nl80211 part of a patch that got merged earlier, the 
description of which has more info:

https://patchwork.kernel.org/patch/389682/

If it's necessary to distinguish between RX and TX it has to be done there 
too. Can you give us examples of these chipsets which you mentioned?

bruno
