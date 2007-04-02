Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965710AbXDBTP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 15:15:56 -0400
Subject: Re: SIOCSIWAP behavior question
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1175533095.23438.79.camel@johannes.berg>
References: <1175521655.9859.15.camel@localhost.localdomain>
	 <1175533095.23438.79.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 15:19:20 -0400
Message-Id: <1175541560.11325.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-02 at 18:58 +0200, Johannes Berg wrote:
> On Mon, 2007-04-02 at 09:47 -0400, Dan Williams wrote:
> > Should setting a BSSID trigger a disconnection event from the driver?
> > Obviously a disconnect event shouldn't be triggered if the BSSID being
> > set is the same BSSID the card is already associated with.  Or does that
> > mean "reassociate unconditionally" ?
> 
> IMHO (answering your rephrased question with "always") it should unless
> the BSSIDs are really identical. After all, one disassociates from one
> BSS before associating to the other.

So it appears that you and Jouni have opposite views here?  I think a
pure & consistent approach would issue disconnect every time the driver
disassociated.  But I'm not sure that would actually work in practice
for all cases.  But I don't have a good idea of all the specifics or
implications.

I tend to think thought that Jouni's right and that within the same ESS
we shouldn't send disconnect events if you're just changing BSSID.

Dan

> > The libertas driver currently does this; it sometimes confuses
> > wpa_supplicant and is arguably wrong behavior because drivers don't
> > issue disconnection events when auto-roaming from BSSID to BSSID in the
> > same ESS.
> 
> Is there a way to trigger such events when auto-roaming? :)
> 
> > Thoughts?  I guess I vote for not sending disconnect events if that
> > BSSID has the same capabilities and the same SSID as the current
> > association BSS.
> 
> I think that just makes things unnecessarily complex -- we'd have to try
> to see if two things are really the same ESS in the driver/stack/...
> 
> johannes

