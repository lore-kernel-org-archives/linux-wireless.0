Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36571 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZG2Vui (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:50:38 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248903902.8925.1.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1248903902.8925.1.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 14:50:38 -0700
Message-Id: <1248904238.1216.1019.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-29 at 14:45 -0700, Johannes Berg wrote:
> On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> > From: Reinette Chatre <reinette.chatre@intel.com>
> > 
> > The connection monitor currently relies on probe requests paired
> > with probe responses to ensure that a connection is alive. This is
> > fragile in some environments where probe responses can get lost.
> > When we receive beacons we can also consider the connection to be
> > alive, so cancel connection poll instance when we receive a beacon.
> > 
> > The debug message "cancelling probereq poll due to a received beacon"
> > is removed as part of this change as this case is hit very often after
> > the above change and debug log receives significant number of these messages.
> 
> Not doing that was actually intentional -- we want to know whether or
> not the connection is working both ways, not just whether we can receive
> frames. This can certainly be improved, but I'm not sure this is the
> best approach.

I'd be happy to try out other approaches because my connection is
dropping every few minutes. 

Reinette


