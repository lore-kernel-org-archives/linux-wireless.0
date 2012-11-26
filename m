Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2KZJMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 04:12:50 -0500
Message-ID: <1353921196.9488.2.camel@jlt4.sipsolutions.net> (sfid-20121126_101254_882419_4949FF71)
Subject: Re: RFC[1/2]mac80211: Add Statistic to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 10:13:16 +0100
In-Reply-To: <50AF4844.2040001@posedge.com>
References: <50AF0E91.30709@posedge.com>
	  <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com>
	  <50AF1A1E.8090704@posedge.com>
	 <1353654716.10197.0.camel@jlt4.sipsolutions.net>
	 <50AF4844.2040001@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 15:26 +0530, Saravana wrote:
> Hi Johannes,
> On 11/23/2012 12:41 PM, Johannes Berg wrote:
> > On Fri, 2012-11-23 at 12:09 +0530, Saravana wrote:
> >
> >>> Also, as you're adding new statistics which are only used when debugfs
> >>> is enabled, you might want to wrap them in #ifdefs so that they're
> >>> only compiled when debugfs support is compiled.
> >
> > [...]
> >> Hence we don't need to wrap this up in #ifdef as it is already taken
> >> care during the directory creation.
> >
> > I think Julian is arguing that you should have the *counters* themselves
> > be under ifdef, and I tend to agree.
> >
> When we went through the make file of mac80211, it is seen that the only 
> when CONFIG_MAC80211_DEBUGFS macro is enabled, the files debugfs.c, 
> debugfs_sta.c, debugfs_netdev.c, debugfs_key.c are compiled in.
> 
> So it may not be required to wrap up any piece of code in these files 
> are they will not be compiled in the first place when the macro 
> CONFIG_MAC80211_DEBUGFS is disabled.

You're thinking of the wrong code -- Julian was saying the *counters*
themselves could be ifdef'ed.

I'd say you don't want to ifdef every single counter, but check which
ones could be expensive to keep etc.

johannes

