Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbYHSTm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 15:42:58 -0400
Subject: Re: [PATCH 3/4] libertas: check for old, unsupported hardware
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200806051402.39736.hs4233@mail.mn-solutions.de>
References: <200806051308.35863.hs4233@mail.mn-solutions.de>
	 <1212666420.25730.4.camel@localhost.localdomain>
	 <200806051402.39736.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 15:44:05 -0400
Message-Id: <1219175045.23157.25.camel@localhost.localdomain> (sfid-20080819_214302_718046_346428B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 14:02 +0200, Holger Schurig wrote:
> I got this piece of code from the 5.0.16 GPL driver, but 
> implemented it differently. I mainly put it in to find out if 
> YOU have such an old silicon. When people yell "my card isn't 
> supported, I get this kernel error" we can still add the 
> necessary support.
> 
> I don't want to add the support right now because I don't have 
> this old hardware and don't know anyone with it. So no-one could 
> test this.

So it turns out I have two of these cards, which are the ones I've been
using for testing since last year.  Which might explain why I've been
having so many problems that you're not having.  They are AmbiCom
WL54-CF rev 1.0 cards which I believe are B0 revision looking at the FCC
internal photos.  The card returns 0x10 as the revision.

> The 5.0.16 source mentions two things needed for this old 
> hardware:
> 
> * doing read-modify-write instead of just setting bits, this
>   applies to IF_CS_HOST_STATUS and IF_CS_HOST_INT_CAUSE

Any chance you could whip up a quick test patch for this one?

> * and an interrupt workaround

I'll try to figure out what needs to happen for this, lack of it might
be the cause of the hangs I've been seeing with my B0 hardware.

Dan


