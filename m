Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60166 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZG3Cjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 22:39:54 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248903902.8925.1.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1248903902.8925.1.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 04:39:51 +0200
Message-Id: <1248921591.28545.256.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

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

this patch might be a band-aid and needs improvement or a total
different solution, but it does help my disconnect problems. It makes my
connection fully stable again. So it is not a wrong approach in general,
because otherwise I have to be always close to me AP. And then using
WiFi is bloody pointless since I could just put an Ethernet cable into
the wall socket directly.

Regards

Marcel


