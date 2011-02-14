Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1BNMbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:31:38 -0500
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110214122818.GA6712@jm.kir.nu>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
	 <1297678357.3785.14.camel@jlt3.sipsolutions.net>
	 <20110214122818.GA6712@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:31:34 +0100
Message-ID: <1297686694.3785.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 14:28 +0200, Jouni Malinen wrote:
> On Mon, Feb 14, 2011 at 11:12:37AM +0100, Johannes Berg wrote:
> > The real question though is -- do we want/need this? I can only find
> > reference to this behaviour in the WMM spec.
> 
> Yes, we do want and need it. Peer capability discovery in RSN IBSS
> depends on this (or a potentially long wait on receiving Beacon frame
> from the specific STA). IEEE 802.11REVmb clarifies the rules for IBSS in
> 10.4.4.3.2 which has the following statement on this: "A STA in an IBSS
> shall respond to Probe Request frames sent to the individual address of
> the STA." after the sentence that limits responding to just the STA
> that transmitted the last Beacon frame.

Ok, good. I submitted the patch, maybe I should resubmit with this
information, but I guess it doesn't matter much.

The next question ends up being under which circumstances we should
_send_ a unicast probe request. Currently, I don't think we ever do.

johannes

