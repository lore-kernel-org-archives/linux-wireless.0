Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3CPM5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:13 -0400
Message-ID: <1363361818.8656.20.camel@jlt4.sipsolutions.net> (sfid-20130316_135737_920354_330762D1)
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20130312094119.GA23062@magnum.frso.rivierawaves.com> (sfid-20130312_104432_201994_A9C4F916)
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
	 <20130312094119.GA23062@magnum.frso.rivierawaves.com>
	 (sfid-20130312_104432_201994_A9C4F916)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:36:58 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-12 at 10:41 +0100, Karl Beldan wrote:
> On Wed, Feb 13, 2013 at 10:51:08AM +0100, Felix Fietkau wrote:
> > When MCS rates start to get bad in 2.4 GHz because of long range or
> > strong interference, CCK rates can be a lot more robust.
> > 
> > This patch adds a pseudo MCS group containing CCK rates (long preamble
> > in the lower 4 slots, short preamble in the upper slots).
> > 
> With this, mac80211 might send CCK rates with IEEE80211_TX_CTL_AMPDU set.
> For aggregates, if we don't currently set NO_CCK, at the very least the
> 1st rate index should belong to an MCS_GROUP.

I guess that depends on how you expect rate control to work ... I'd
kinda expect the driver to skip aggregation then? I think only ath9k
even uses minstrel + aggregation?

johannes

