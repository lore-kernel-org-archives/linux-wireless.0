Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1AKIg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:36:58 -0500
Subject: Re: [PATCH] wl12xx: reset 5ghz num channels on hw init
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294734738.12992.45.camel@pimenta>
References: <1294693444-30807-1-git-send-email-arik@wizery.com>
	 <1294734327.3611.1.camel@jlt3.sipsolutions.net>
	 <1294734738.12992.45.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 09:36:55 +0100
Message-ID: <1294735015.3611.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 10:32 +0200, Luciano Coelho wrote:
> Hi Johannes,
> 
> On Tue, 2011-01-11 at 09:25 +0100, Johannes Berg wrote:
> > On Mon, 2011-01-10 at 23:04 +0200, Arik Nemtsov wrote:
> > > The number of 5ghz channels is set to 0 when 11a is not supported in the
> > > NVS file. When a single rmmod/insmod of wl12xx_sdio this leads to a
> > > supported band (5ghz) with 0 supported channels, which mac80211
> > > considers illegal.
> > 
> > The setting to 0 shouldn't be happening in a global structure anyway
> > since that way you can't support two different devices in the same
> > system!!
> 
> This is that hack we discussed some time ago on how to disable the 11a
> channels. [snip explanation]

You misunderstood: I do remember discussing the hack, and it's still a
hack but it works and I'm OK with it. However, you shouldn't be
modifying a _global_ struct. You should at least copy the sband struct
itself (array actually then), which can still refer to the global
channel array, but then you don't modify global shared data for
device-dependent properties like this.

johannes

