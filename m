Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1DSMgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:36:09 -0400
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet
 loss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
	 <1303129610.3588.7.camel@jlt3.sipsolutions.net>
	 <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 14:36:06 +0200
Message-ID: <1303216566.3603.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 23:44 +0300, Arik Nemtsov wrote:

> Well in a wl12xx chip we just configure some thresholds to the FW and
> it triggers the event for us. Using TX status doesn't really make
> sense since the FW has automatic rate control (so 50 tries are more
> like 50 * 8).

Yeah same for the mac80211 approach, since we take packets, not retries.

> > Also, are you sure? Do you really not get _any_ TX status?
> 
> Currently we do get TX status, but there are plans to remove it later on.

That's your choice, but I wouldn't do it. You'll have to support TX
status when requested, otherwise AP operation won't work, so you need
the code anyway.

johannes

