Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:9169 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbYCaMvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 08:51:47 -0400
Received: by ug-out-1314.google.com with SMTP id z38so428503ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 05:51:44 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
Date: Mon, 31 Mar 2008 14:51:22 +0200
Cc: Bas Hulsken <bhulsken@hotmail.com>, linux-wireless@vger.kernel.org
References: <1206801246.24689.19.camel@Bas> <200803291801.17068.IvDoorn@gmail.com> <1206964876.5468.12.camel@johannes.berg>
In-Reply-To: <1206964876.5468.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803311451.23388.IvDoorn@gmail.com> (sfid-20080331_135215_255202_7FE7A35D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Thanks for helping debug this. I haven't had a chance to run hostapd
> again, been far too busy. As it stands, I'm not sure when I can possibly
> get to that.
> 
> > > rt2500pci filter_flags: 2
> > > rt2500pci MAC changed: 00:0c:f6:14:05:19
> > 
> > Packet filter flags of 2 sounds a bit restrictive.
> > 
> > Johannes, for Master mode shouldn't the following flags be set as well:
> > FIF_PROMISC_IN_BSS
> > FIF_CONTROL
> > 
> > Or should the driver enable those automatically when master mode is enabled?
> 
> The driver most definitely shouldn't do anything, but neither of those
> flags should be needed. In a BSS, all frames from the stations are
> addressed to the BSS-MAC, i.e. to the AP, so the regular MAC filter
> should allow them through without any sort of promisc. And control
> frames aren't needed, those are just ack/cts/... frames.

Ok, I think I found the problem. The packet filter in all Ralink devices have a
TODS filter. Currently I had this only enabled when FIF_PROMISC_IN_BSS was set.
I'll change this to a check that determines if master mode is enabled.

Ivo
