Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0JNNtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 09:49:23 -0400
Subject: Re: [PATCH 4/6] Add a bitrate threshold config hook in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=PDnooPN9kmgHo0Sh7s3p8cMfpvbkkoAbCsF3_@mail.gmail.com>
References: <20101013224851.D58252094C@glenhelen.mtv.corp.google.com>
	 <1287040708.4641.10.camel@jlt3.sipsolutions.net>
	 <AANLkTi=PDnooPN9kmgHo0Sh7s3p8cMfpvbkkoAbCsF3_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 15:50:03 +0200
Message-ID: <1287064203.4641.433.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[list added back]

On Thu, 2010-10-14 at 06:42 -0700, Paul Stewart wrote:

> >> +     u32 cqm_bitrate_thold;
> >
> > Since there's no way for drivers to utilise this, don't add it in public
> > API.
> 
> I disagree here.  I don't see a reason why a other drivers would not
> be able to take advantage of this feature, much the same as some of
> them support rssi thresholds.  They can calculate their own last
> transmitted bitrate and trigger cqm events using cfg80211 just as well
> as mac80211 can.

No, they can't, for one they don't have access to the netdev. So at
least mac80211 would have to provide wrappers. And there would also have
to be capability bits so that mac80211 doesn't actually do all of this
in software when the driver does it, avoiding double notifications and
overhead.

johannes

