Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:18329 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbYANJZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 04:25:47 -0500
Received: by py-out-1112.google.com with SMTP id u52so2990180pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2008 01:25:46 -0800 (PST)
Message-ID: <c85cb4470801140125x169067e2v456a4511bee437fb@mail.gmail.com> (sfid-20080114_092601_833374_F3ACEDD1)
Date: Mon, 14 Jan 2008 11:25:40 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 01/10] mac80211: A-MPDU Tx add session's and low level driver's API
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200261492.5887.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857491583-git-send-email-ron.rindjunsky@intel.com>
	 <1200068953.3861.180.camel@johannes.berg>
	 <c85cb4470801130717l7b455ea7pa4de50b5be2c0502@mail.gmail.com>
	 <1200261492.5887.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > It seems to me that this should be per-virtual interface instead of
> > > per-hardware? I guess ultimately it won't make a difference because the
> > > RA will be unique but I think we should still keep it per-vif where it
> > > makes sense.
> > >
> > I can pass only vif in all the API i give, and that's something that i
> > am not sure about since you introduced vif - generally all functions
> > can get hw just from having the vif, but still there are plenty of
> > places in the code that i see hw being passed back and forth. is it
> > just because API compatibility or because something else i need to
> > consider?
>
> Basically I'm thinking that everything that could in theory be
> per-interface should be getting a vif. Say you have a multi-BSS AP. I
> don't think it's really legal for a STA to associate to multiple APs at
> the same time but want to avoid the code falling over when a STA
> actually does associate to multiple of our virtual BSSes... Maybe that's
> just unnecessary.
>

I am not sure about the necessity of it myself, as once A-MPDU is
active all traffic for the RA/TID (no matter what interface usese it)
should be aggregated.
I will currently leave it this way, and if you see any problem  please
describe it specifically and i will change it either on this patch or
on top of it.
