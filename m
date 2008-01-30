Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:53462 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYA3JLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 04:11:50 -0500
Received: by rv-out-0910.google.com with SMTP id k20so144507rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 01:11:47 -0800 (PST)
Message-ID: <c85cb4470801300111j610c1cak290c6a1d07cc54fe@mail.gmail.com> (sfid-20080130_091156_409652_13F72857)
Date: Wed, 30 Jan 2008 11:11:47 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/12] mac80211: A-MPDU Tx adding qdisc support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201623169.4394.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392546-git-send-email-ron.rindjunsky@intel.com>
	 <1201167778.3454.75.camel@johannes.berg>
	 <c85cb4470801270926g1f84fc8t5905b458b4eee012@mail.gmail.com>
	 <1201623169.4394.35.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I can change this book keeping, though current solution provides us up
> > to 32 HW queues, which is really a huge amout of queues in terms of
> > HW. if needed after all, i would prefer to do it on top of this
> > series.
>
> Well you don't really need to change any code I think, only use
>
>        unsigned long qdisc_pool[BITS_TO_LONGS(NUM_TX_DATA_QUEUES_AMPDU)];
>
> instead and that way we should already be safe for future increases of
> the NUM_TX_DATA_QUEUES_AMPDU value. set_bit/clear_bit/etc. are already
> prepared to handle such an array so I'd prefer to have it right away
> just so there are less gotchas when that happens.

right, i missed your point first time, i'll change it.
