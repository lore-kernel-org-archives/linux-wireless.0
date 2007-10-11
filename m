Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXJKOu1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 10:50:27 -0400
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <20071011141642.GA6976@infradead.org>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <20071011141642.GA6976@infradead.org>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 10:50:34 -0400
Message-Id: <1192114234.31895.5.camel@localhost.localdomain> (sfid-20071011_155029_713240_9418F9C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-11 at 15:16 +0100, Christoph Hellwig wrote:
> On Thu, Oct 11, 2007 at 11:51:06AM +0200, Holger Schurig wrote:
> > Move wlan_postpone_association_work() and wlan_cancel_association_work()
> > from a assoc.h file to the sole user, into wext.c.
> > 
> > In passing, rename the functions to libertas_XXX.
> 
> As you seem to do some nice cleanups on libertas is there a chance
> you could get rid of this horrible wlan_ namespace abuse in the driver?

100% agree...  That's always been part of the plan, just that other
cleanups were more pressing and time always runs out.

IMHO 'libertas' is too long as a prefix for stuff, and replacing wlan_
with libertas_ is going to screw up spacing everywhere.  So, any
objections to, as part of the longer-term plan, replace the usage of
'libertas_' and 'wlan_' with the prefix "lts"?  Would look like:

wlan_set_essid -> lts_set_essid
wlan_private -> lts_private
etc

(I don't really like 'lbs' personally but I'm not that strongly against
it)

Dan


