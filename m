Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1ISMUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 08:20:19 -0400
Subject: Re: [RFC 0/5] TDLS support for nl80211/mac80211 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <CA+XVXfeSMANH7Eoq+3XKY57y64szbGrMP6Y5iUgZmn7R11tQ0g@mail.gmail.com> (sfid-20110916_184921_977646_0BBA3AE0)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316177890.4130.27.camel@jlt3.sipsolutions.net>
	 <CA+XVXfeSMANH7Eoq+3XKY57y64szbGrMP6Y5iUgZmn7R11tQ0g@mail.gmail.com>
	 (sfid-20110916_184921_977646_0BBA3AE0)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:20:17 +0200
Message-ID: <1316434817.5995.20.camel@jlt3.sipsolutions.net> (sfid-20110919_142023_129308_A8CCFB7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 19:48 +0300, Arik Nemtsov wrote:

> We had some qualms about the design ourselves. This is a question
> Kalyan sent to the hostap list a while back -
> http://lists.shmoo.com/pipermail/hostap/2011-June/023311.html
> 
> The locking requirement (elaborated at the end of the email) was also
> part of the decision to make mac80211 more aware of the connection
> state. Also, eventually mac80211 will have to add some IEs of it's own
> to the setup packets.

Hmm, ok, adding the IEs would be a deal-breaker, it didn't seem
necessary though.

> wpa_supplicant needs to add some IEs to the packet (RSN, FTIE, ..).
> mac80211 will also have to add some IEs (U-APSD, HT, ...)
> Does it really matter if the packet's headers are created by usermode
> or by kernel? Even if we change the "owner" of the packet, the API
> would still remain about the same. tdls_mgmt would simply get the
> frame instead of extra IEs.

Not really. But adding the extra datapath seemed a little pointless.

> Jouni's original wpa_s TDLS code was written for a full-mac driver
> where the kernel/firmware side created the packet. wpa_supplicant only
> provided auth IEs. Keeping it this way also avoids refactoring the
> code and introducing bugs.

Yeah that's another good argument :-)

> >> Notably, this patch-set does not include locking in the data path,
> >> to switch between AP-based and direct Tx during link setup/tear-down.
> >> This will be added by a later patch-set, if/when this series is
> >> accepted. In practice it seems to work quite well without additional
> >> locking.
> >
> > That ought to work without locks if you create/destroy the station
> > entries appropriately?
> 
> I should elaborate on the locking requirement. The TDLS link setup is
> made up 3 frames - a setup request, followed by a response from the
> peer, and finally a confirm.
> This is an excerpt from the spec:
> 
> "To avoid possible reordering of MSDUs, a TDLS initiator STA shall
> cease transmitting MSDUs to the
> TDLS responder STA through the AP after sending a TDLS Setup Request
> frame, and a TDLS responder
> STA shall cease transmitting MSDUs to the TDLS initiator STA through
> the AP after sending a TDLS
> Setup Response frame indicating status code 0 (Success)."
> 
> This requires a locking mechanism similar to AP-mode buffering for
> stations in PS (since we probably don't want to stop all queues).

Ok, so the special thing is really that you need to stop after the setup
request frame. Makes sense.

johannes

