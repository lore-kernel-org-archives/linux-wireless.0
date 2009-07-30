Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:58823 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZG3FY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 01:24:29 -0400
Received: by fxm28 with SMTP id 28so405815fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 22:24:28 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248904238.1216.1019.camel@rc-desk>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1248903902.8925.1.camel@johannes.local>
	 <1248904238.1216.1019.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 08:24:23 +0300
Message-Id: <1248931463.27010.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-29 at 14:50 -0700, reinette chatre wrote:
> On Wed, 2009-07-29 at 14:45 -0700, Johannes Berg wrote:
> > On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> > > From: Reinette Chatre <reinette.chatre@intel.com>
> > > 
> > > The connection monitor currently relies on probe requests paired
> > > with probe responses to ensure that a connection is alive. This is
> > > fragile in some environments where probe responses can get lost.
> > > When we receive beacons we can also consider the connection to be
> > > alive, so cancel connection poll instance when we receive a beacon.
> > > 
> > > The debug message "cancelling probereq poll due to a received beacon"
> > > is removed as part of this change as this case is hit very often after
> > > the above change and debug log receives significant number of these messages.
> > 
> > Not doing that was actually intentional -- we want to know whether or
> > not the connection is working both ways, not just whether we can receive
> > frames. This can certainly be improved, but I'm not sure this is the
> > best approach.
> 
> I'd be happy to try out other approaches because my connection is
> dropping every few minutes. 


Mine too, and it even happens when I am a meter away from the AP.
My device is 3945.

Best regards,
	Maxim Levitsky


