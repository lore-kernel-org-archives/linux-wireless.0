Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48696 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZG3Jge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 05:36:34 -0400
Received: by bwz19 with SMTP id 19so467311bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 02:36:34 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
Date: Thu, 30 Jul 2009 11:36:39 +0200
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com> <1248903902.8925.1.camel@johannes.local>
In-Reply-To: <1248903902.8925.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907301136.40274.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 29. Juli 2009 schrieb Johannes Berg:
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

Just out of curiosity, do direct probe requests get ACKed?

If not, the hardware wouldn't have a possibility to retry the frame and the
probability of loosing a probe request frame would be much higher then of
a data frame.

Helmut
