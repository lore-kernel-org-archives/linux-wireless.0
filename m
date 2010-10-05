Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab0JEUKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:10:09 -0400
Subject: Re: [PATCH wireless-2.6] mac80211: delete AddBA response timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286307633.3641.29.camel@jlt3.sipsolutions.net>
References: <1286307633.3641.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 22:10:08 +0200
Message-ID: <1286309408.3641.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 21:40 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We never delete the addBA response timer, which
> is typically fine, but if the station it belongs
> to is deleted very quickly after starting the BA
> session, before the peer had a chance to reply,
> the timer may fire after the station struct has
> been freed already. Therefore, we need to delete
> the timer in a suitable spot -- best when the
> session is being stopped (which will happen even
> then) in which case the delete will be a no-op
> most of the time.
> 
> I've reproduced the scenario and tested the fix.

Ok, can you add:

This fixes the crash reported at
http://mid.gmane.org/4CAB6F96.6090701@candelatech.com

to the changelog?

johannes

