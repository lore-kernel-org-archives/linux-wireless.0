Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23483 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1AES0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 13:26:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 10:26:04 -0800
Date: Wed, 5 Jan 2011 10:26:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Paul Stewart <pstew@google.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amod Bodas <amod@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
Message-ID: <20110105182617.GB10391@tux>
References: <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
 <1292501047.3612.9.camel@jlt3.sipsolutions.net>
 <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
 <1292502934.3612.15.camel@jlt3.sipsolutions.net>
 <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
 <1292504020.3612.17.camel@jlt3.sipsolutions.net>
 <AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
 <20101216174410.GB5677@tux>
 <AANLkTinvrdj4jbzH3COVZ9gW8W0h0em7uD6DBWBEXUp=@mail.gmail.com>
 <AANLkTikDP_uF_jGh5bNyMv17VoZB=9u-SrdWRUQ15gRb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTikDP_uF_jGh5bNyMv17VoZB=9u-SrdWRUQ15gRb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 04, 2011 at 02:29:53PM -0800, Paul Stewart wrote:
> On Tue, Jan 4, 2011 at 10:19 AM, Paul Stewart <pstew@google.com> wrote:
> > On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> Try this:
> >
> > Happy new year.  I've tried this patch, and the system continues to
> > suspend and resume successfully (i.e, the fix from the earlier patches
> > continues to alleviate the original problem), however the system
> > continues to be "deaf" to beacons at resume time if the system
> > suspends and resumes while associated.  You don't need a ChromeOS
> > system to reproduce this issue.  Just associate to the network and
> > suspend/resume.  On resume the system believes it should be
> > associated, but then the beacon loss timer kicks in and we
> > disassociate, since we are never successful in receiving a response.
> 
> Whoops.  I didn't apply that change correctly.  Actually, I think this
> change works.  I think I may have spotted a couple of unrelated
> anomalies I'll trace down and address separately.

Great, I think this patch got sucked up already, I'll check.

  Luis
