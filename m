Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1DAU3C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 16:29:02 -0400
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
	 <1301687948.3842.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 22:28:56 +0200
Message-ID: <1301689736.3842.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 13:10 -0700, Luis R. Rodriguez wrote:

> > What if CRDA replies in order, i.e. replies to the user requested one
> > first instead of the disassoc requested one?
> 
> Are you questioning the order of udev events and how CRDA processes them?

No, no, not really.

> If CRDA is present it should get the udev event for any valid request
> and process it accordingly. If the request is bogus it'll prevent any
> further processing on cfg80211 given that we simply bail out of
> processing requests until last_request->processed is true. The fix for
> that lies in the timeout on patch 2. This patch just ensures that we
> make sure to clear out any pending requests prior to doing a restore
> of regulatory settings.
> 
> > Why do we even require crda to reply to the first in list, rather than
> > any one?
> 
> The order should not matter except that we want the queue to be
> cleared before processing core hints when doing restoration, otherwise
> the next user hint in the queue can be bogus and it will prevent a
> restore.

I'm just thinking this temporary clearing could cause us to reject a
reply from CRDA that's coming in at the same time that is due to a user
request.

johannes

