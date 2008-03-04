Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:62823 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbYCDKGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 05:06:07 -0500
Received: by rv-out-0910.google.com with SMTP id k20so430781rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2008 02:06:06 -0800 (PST)
Message-ID: <c85cb4470803040206t5bac2d42r9507ebc83bce0761@mail.gmail.com> (sfid-20080304_100613_018321_A918212C)
Date: Tue, 4 Mar 2008 12:06:06 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: STA info size
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Felix Fietkau" <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203693353.7082.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203675307.26341.29.camel@johannes.berg>
	 <20080222143409.GA3067@tuxdriver.com>
	 <1203693353.7082.28.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > STA info struct currently (after my reorg) takes 2432 bytes. Almost 2000
> > > of those are in struct sta_ampdu_mlme which is most likely not used for
> > > most STAs.
> > >
> > > Do you think that is too much memory per station? It'd probably be
> > > possible to allocate the sta_ampdu_mlme dynamically when needed, no?
> >
> > My count was closer to 1.5k, but I may have missed something.
>

I did the check myself and your numbers are correct. i also think
dynamic allocation is the way to go. unless something i skipped will
pop up i'll do the changes.

Ron
