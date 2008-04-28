Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965286AbYD1Srx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 14:47:53 -0400
Subject: RE: Roaming problems
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	"'John W. Linville'" <linville@tuxdriver.com>,
	"'Holger Schurig'" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1209407657.29025.21.camel@johannes.berg>
References: <009d01c8a95d$b73b0410$0b3ca8c0@gotws1589>
	 <1209407657.29025.21.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:43:28 -0400
Message-Id: <1209408208.23868.3.camel@localhost.localdomain> (sfid-20080428_204758_424215_0CFA52B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-28 at 20:34 +0200, Johannes Berg wrote:
> On Mon, 2008-04-28 at 20:28 +0200, Lars Ericsson wrote:
> > > > - Driver authenticating with new AP while having a valid 
> > > > association with and other AP.
> > > 
> > > Yes, that is the problem, we should disassociate first. If 
> > > you can come up with a patch to send a disassoc packet in 
> > > that case (and test it,
> > > preferably) that would be much welcome.
> > 
> > OK. I understood that there has been a discussion about the way the driver
> > should handle this situation and the current behaviour is according to that
> > discussion. 
> 
> Yeah but that was mostly just sidetrack.
> 
> > Is there any information document available describing the
> > selected design path or is it only the code that document the design ? 
> > I think need that information if I should be able to create the patch
> > requested above.
> 
> Unfortunately, there is nothing about mac80211's mlme other than the
> code.
> 
> > On the other hand, that patch will only keep track of 'dual association'
> > problem. 
> 
> Well, no, that would mean we disassociate first and then only have a
> single association.
> 
> > With the current wpa_supplicant, we will still have the problem
> > with the driver start an association sequence as soon as 'trig' ioctl
> > arrives. I think the wpa_supplicant need to modified to better cooperate
> > with the driver.
> 
> That would be doable as well (though I would argue it should be done in
> addition), we could use Holger's approach and delay the actual
> association sequence start until a commit wext ioctl is received or a
> timer expires. Then wpa_supplicant can call the commit explicitly after
> doing everything.

This is the best approach really; it's the one I took in the libertas
driver and turned out to work quite well.  It completely avoids issues
with iwconfig argument ordering and the timer is long enough that it'll
pick up almost everything you can throw at it programmatically as long
as you don't do something stupid like sleep(2)...

Dan

