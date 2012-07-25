Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2GYMug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 08:50:36 -0400
Message-ID: <1343220625.4463.31.camel@jlt3.sipsolutions.net> (sfid-20120725_145046_172759_150E9277)
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Date: Wed, 25 Jul 2012 14:50:25 +0200
In-Reply-To: <1343208990.4463.25.camel@jlt3.sipsolutions.net> (sfid-20120725_113644_599580_8AC4476F)
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>
	 (sfid-20120725_113644_599580_8AC4476F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 11:36 +0200, Johannes Berg wrote:
> On Tue, 2012-07-24 at 22:18 +0200, Thomas Huehn wrote:
> > The pointer control.sta is removed from ieee80211_tx_info to free up
> > sufficient memory in SKB_CB on the tx-path to enable new annotations
> > per data packet e.g.support of upcoming Transmit Power Control (TPC).
> > Now the control.sta pointer is put on the stack where passed as
> > function parameter to the .tx equivalent (ieee80211_ops) of each
> > affected wireless driver.
> > Therefore a new structure ieee80211_tx_control is added to mac80211.h
> > which holds the sta structure instead. The tx-path of all affected
> > drivers is restructured to respect the chaneges.
> > 
> > Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> > Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > ---
> > restructure this patch to respect logical API evolutions. thx to Johannes Berg
> > add missing drivers that are effected as well. thx to Xose Vazquez Perez
> > add missing drivers that are effected as well. thx to Johannes Berg
> > simplified control pointer passing in tx.c - thx to Johannes Berg
> 
> Finally applied, but I dropped these spurious changes:

Never mind, it still doesn't compile, dropped it.

I had to rebase my tree due to that, sorry!

johannes

