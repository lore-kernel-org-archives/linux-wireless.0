Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2L1PEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 10:04:41 -0500
Message-ID: <1356707102.9922.26.camel@jlt4.sipsolutions.net> (sfid-20121228_160453_256371_74E8CF78)
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 28 Dec 2012 16:05:02 +0100
In-Reply-To: <20121130134311.GA19037@pandem0nium>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354111295.9345.25.camel@jlt4.sipsolutions.net>
	 <20121130134311.GA19037@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 14:43 +0100, Simon Wunderlich wrote:
> On Wed, Nov 28, 2012 at 03:01:35PM +0100, Johannes Berg wrote:
> > On Tue, 2012-11-27 at 19:50 +0100, Simon Wunderlich wrote:
> > > It can be useful to set own WMM parameters from outside, otherwise there
> > > is no way to change this in Ad-Hoc networks.
> > 
> > Having proper WMM support for IBSS doesn't seem this simple.
> > 
> > What about IBSS merging? What about adding WMM IEs? etc.
> 
> I couldn't find anything on this in the IEEE standard - it only talks
> about infrastructure mode, and that EDCA Parameter IEs should be adopted. 
> (Although I doubt that's a good idea).

In infrastructure mode the values are adopted, the IEs aren't ever
transmitted by a client...

I would argue that in order to join an IBSS you need to execute the
MLME-JOIN primitive, and that has no EDCA parameter set argument so you
should take the values from the IBSS.

Why would that be a bad idea? It seems like a much worse idea to have
different stations in an IBSS that have different EDCA parameters.

> All we want here is to locally change the parameters. Seems we are not the
> first ones who want to do that [1]. The WMM specification only says that no
> WMM IEs is in the beacon and distribution of parameters is missing, and
> therefore defaults are to be used.
> 
> Therefore, I'd like to go for the local changes only and skip WMM IEs, adoption,
> etc.
> 
> You have a point regarding IBSS merging - with this change, we would lose the
> local configuration with the merge. This could be changed for mac80211,
> not sure about other drivers (or if anyone actually cares).

Wait I'm lost -- you say you don't want to adopt the parameters from
others but then when merging ...??

It seems to me that the WMM IEs also need to be present to even tell the
peers that you're QoS capable to start with, otherwise they'll never be
able to use QoS towards you. You're not making all that much sense right
now, but maybe that's because I haven't looked at the code?

johannes

