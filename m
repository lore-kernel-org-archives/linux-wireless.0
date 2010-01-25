Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:58807 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0AYWKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:10:10 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] mac80211: move control.hw_key assignment
Date: Mon, 25 Jan 2010 23:07:58 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
References: <20100117004754.624627000@sipsolutions.net> <201001231622.03394.rossi.f@inwind.it> <1264332591.23766.21.camel@johannes.local>
In-Reply-To: <1264332591.23766.21.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <201001252307.58884.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 January 2010 12:29:51 Johannes Berg wrote:

> Hi,
> 
> On Sat, 2010-01-23 at 16:22 +0100, Fabio Rossi wrote:
> > this patch breaks my wireless connection. I'm able to authenticate and
> > associate to my AP but I can't use the connection, a simple ping towards
> > my AP doesn't work. I bisected the problem and your patch is the bad
> > commit.
> >
> > I have the latest wireless-testing.git (v2.6.33-rc5-47285-g96ada3c).
> > After having removed all the commits related to this patch, i.e.
> >
> > - commit f12553ebe045a8a40ab33fa500fb57d10706e226
> > - commit e4fca007b06165900d0e44e8d5e251376819bf5d
> > - commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
> >
> > the connection is working again.
> 
> Hmm. Are you using hw crypto?

Yes, from what I have understood it should be the default using ath5k. 
Anyway I added your last patch

	[PATCH] mac80211: fix sw crypto

fixing my problem.

Thanks,
Fabio
