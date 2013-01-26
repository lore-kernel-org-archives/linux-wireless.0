Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:40277 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab3AZRPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 12:15:21 -0500
Date: Sat, 26 Jan 2013 18:15:40 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"andihartmann@01019freenet.de" <andihartmann@01019freenet.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
Message-ID: <20130126171540.GC5834@localhost.localdomain> (sfid-20130126_181525_017942_F2A94BFB)
References: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com>
 <201301171816.15309.chunkeey@googlemail.com>
 <13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com>
 <201301251853.24699.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201301251853.24699.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 06:53:23PM +0100, Christian Lamparter wrote:
> On Thursday 17 January 2013 19:42:52 Gertjan van Wingerde wrote:
> > On 17 jan. 2013, at 18:16, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > > On Thursday, January 17, 2013 05:34:32 PM Helmut Schaa wrote:
> > >> Since rt2800 hardware isn't capable of reporting the TX status of
> > >> BlockAckReq frames implement the TX status handling of BARs in
> > >> rt2x00lib. We keep track of all BARs that are send out and try to
> > >> match incoming BAs to the appropriate BARs. This allows us to report a
> > >> more or less accurate TX status for BAR frames which in turn improves
> > >> BA session stability.
> > > ---
> > > What about:
> > >> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
> > >> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > >> Date:   Mon Dec 3 12:56:33 2012 +0100
> > >> mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> > > 
> > > Should it be kept or dropped (as no driver uses it anymore?)
> > 
> > I guess it should be dropped. I guess we could create a revert patch for that once
> > this patch has been merged.
> Looks like the rt2x00 patch has been accepted :)
> John, do you still want to remove the workaround, or
> can we keep it?
I'll post patch with revert.

Stanislaw
