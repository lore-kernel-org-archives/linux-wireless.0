Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:54664 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXLJIUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 03:20:02 -0500
Received: by mu-out-0910.google.com with SMTP id i10so2435820mue
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 00:20:00 -0800 (PST)
Message-ID: <c85cb4470712100019x50f61ben828c0c86ee2c7141@mail.gmail.com> (sfid-20071210_082007_493187_795F2EC1)
Date: Mon, 10 Dec 2007 10:19:59 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <20071210045955.GN5698@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11972036221022-git-send-email-ron.rindjunsky@intel.com>
	 <20071210045955.GN5698@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +/* IEEE 80211.11 minimal headers length */
> > +#define IEEE80211_HDR_MIN_LEN_CTRL 16
>
> Where does this value 16 come from? It is likely the shortest length one
> would receive from hardware/firmware in normal mode, but it is not the
> shortest length for a valid IEEE 802.11 control frame. Both CTS and ACK
> frames have only 10 octets in the header (just one address). Having
> IEEE80211_HDR_MIN_LEN_CTRL defined to 16 would be a bit confusing.. CTS
> and ACK frames are received at least in monitor mode, so these frames
> with 10 octet headers will need to be processed in some cases.

this check comes after monitor interface has been fed, so it shouldn't
damage it.
My intention in the name was "min length for a frame that i want to
pass" so i see why it can cause confusion. As no good name for it
comes to my mind i think i will drop the #defines , add remarks to
explain length use, and will welcome any change for better naming
convention.

ron

>
> --
> Jouni Malinen                                            PGP id EFC895FA
