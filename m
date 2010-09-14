Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0INOjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:39:24 -0400
Subject: Re: [PATCH 07/10] mac80211: disable beacon monitor while going
 offchannel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
In-Reply-To: <AANLkTin5Dbb+0EdY4wEmbk=ZAvFbowBj5YqH4fX9hBgc@mail.gmail.com>
References: <1284474028-3337-1-git-send-email-lrodriguez@atheros.com>
	 <1284474577.3704.8.camel@jlt3.sipsolutions.net>
	 <AANLkTin5Dbb+0EdY4wEmbk=ZAvFbowBj5YqH4fX9hBgc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 16:38:42 +0200
Message-ID: <1284475122.3704.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-14 at 07:35 -0700, Luis R. Rodriguez wrote:
> On Tue, Sep 14, 2010 at 7:29 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2010-09-14 at 10:20 -0400, Luis R. Rodriguez wrote:
> >
> >> +     del_timer_sync(&ifmgd->bcn_mon_timer);
> >>       del_timer_sync(&sdata->u.mgd.conn_mon_timer);
> >
> > This is kinda inconsistent now ... and you added both these lines in
> > your patch set :-)
> 
> Sorry, I do not follow, can you elaborate?

You use "ifmgd->", but also "sdata->u.mgd." when both should be one of
those.

johannes

