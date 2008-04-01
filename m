Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4293 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbYDAOdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 10:33:51 -0400
Date: Tue, 1 Apr 2008 10:25:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, abertensu@yahoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] FW: iwl3945: disassociation from AP (reason=4)
	andtimeout, a solution
Message-ID: <20080401142537.GA3994@tuxdriver.com> (sfid-20080401_153355_705056_DBA61368)
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com> <1206999696.20744.2.camel@localhost.localdomain> <1207051434.5143.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207051434.5143.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 01, 2008 at 02:03:54PM +0200, Johannes Berg wrote:
> 
> > > > After browsing the internet, I found a lot of people with the same
> > > > problem and no solution. So, I dived into the code and found a simple
> > > > solution: ignore disassociation. When a new request arrives to the
> > > > wireless, a reconnection is done automatically.
> > 
> > Ignoring the disassociation from the AP is suspect...  wouldn't the AP
> > be releasing resources associated with the station, requiring a
> > reassociate/reauth from the station?  Reason 4 seems to mean "Inactivity
> > timer expired and station was disassociated".
> 
> Indeed.
> 
> > A better solution would be to queue up a reassocation worker if the AP
> > kicked you off for reason 4, maybe?
> 
> It would think so, yes.

But would that reassociation be any more likely to succeed than the
one that the current (unpatched) code is attempting?

It seems likely to me that the patch ignoring disassociation (thereby
provoking a deauth and new assoc) is effectively hacking the MLME
state machine.  I'll take a look to see if I can figure it out --
suggestions welcome.

John
-- 
John W. Linville
linville@tuxdriver.com
