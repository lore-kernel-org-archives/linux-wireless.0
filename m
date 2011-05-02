Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55483 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759872Ab1EBOvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 10:51:25 -0400
Received: by eyb6 with SMTP id 6so2058074eyb.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 07:51:21 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: support FW TX inactivity triggers
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110502143757.GD2544@tuxdriver.com>
References: <1303849311-8817-1-git-send-email-arik@wizery.com>
	 <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com>
	 <BANLkTinnQgZGjZOigQuUSVD0kCBTuzUE1A@mail.gmail.com>
	 <1304329855.12586.234.camel@cumari>  <20110502143757.GD2544@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 17:51:18 +0300
Message-ID: <1304347878.12586.256.camel@cumari> (sfid-20110502_165128_282413_642ECD24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-02 at 10:37 -0400, John W. Linville wrote:
> On Mon, May 02, 2011 at 12:50:55PM +0300, Luciano Coelho wrote:
> > Hi John and Arik,
> > 
> > On Sat, 2011-04-30 at 00:09 +0300, Arik Nemtsov wrote:
> > > Hey John,
> > > 
> > > Looking at the latest git, it seems you've picked up this patch
> > > (commit 47684808fd89d6809c0886e06f8ac324252499d8).
> > > This is unfortunate, since there's currently a FW bug that will cause
> > > many disconnections in STA mode with this patch.
> > > 
> > > How would we go about reverting this?
> > 
> > I have reverted this patch in the wl12xx.git tree.  This required a bit
> > of merging and we needed the revert in order to proceed with our tests.
> > 
> > So, John, please don't revert this in your tree.  My revert will come in
> > my next pull-request which will come in a couple of days, after our
> > internal test round is done.
> > 
> > Thanks!
> 
> OK, sounds good.  FWIW, this is what I meant when I said "Do the
> wl12xx guys still want this?"  Granted, that was about the other
> patch in the series, but I kinda presumed that they were related...

Yes, no problem.  I agree that sometimes it makes more sense to apply
this kind of patches together (as you did), especially when both patches
were sent as part of the same series.

The mac80211 part is ready and we thought the wl12xx was good too, but
our internal tests have shown that there are still some problems with
this in our driver, which was decreasing connection stability in
general, thus we wanted this to get reverted.  So, you didn't to
anything wrong (obviously, it was our own fault. ;)

-- 
Cheers,
Luca.

