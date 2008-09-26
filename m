Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47391 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYIZBvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 21:51:07 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 18:51:07 -0700
Date: Thu, 25 Sep 2008 18:51:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Tomas Winkler <tomas.winkler@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20080926015100.GR6204@tesla> (sfid-20080926_035113_123337_0D8C43AC)
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com> <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 12:43:36PM -0700, Steven Noonan wrote:
> On Thu, Sep 25, 2008 at 12:34 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> > Re-enable aggregation by addressing skb->cb overwrites
> > after insertion into the qdisc. Aggregation was disabled
> > after the new TX multiqueue changes were introduced. Instead
> > of relying on the skb->cb we use two flags on the skb.
> >
> 
> I seem to recall that implementing aggregation was causing issues with
> ath9k 

Just ath9k, there are only two aggregation capable drivers in the
kernel right now, Intel's iwlagn and ath9k. Intel's worked just fine
in my tests.

> among others (in particular, ath9k was getting slow throughput).

Yes, but it seems this is a general throughput issue now, not just
related to aggregation. We have been working hard on trying to find
what the cause to the throughput issue is.

> How's throughput with this version of the aggregation patch?

Please test and let us know, try HT40 on 11a. We're keen on resolving
this just as with the MIB interrupt issue you say ;)

BTW you need more than this patch to get aggregation working. Below
are the patches you'll need on top of 2.6.27-rc7 to get aggregation
working (and your MIB interrupt storm fixed) with ath9k:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-09-25

  Luis
