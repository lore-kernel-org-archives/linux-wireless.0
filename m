Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:43515 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754877AbYJ2Vx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:53:28 -0400
Date: Wed, 29 Oct 2008 22:53:25 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
Message-ID: <20081029215325.GA14849@isilmar.linta.de> (sfid-20081029_225352_754997_B06D63C2)
References: <1225145468.1115.139.camel@rc-desk> <20081027230326.GA23250@isilmar.linta.de> <1225154823.1115.149.camel@rc-desk> <20081028194323.GA14303@isilmar.linta.de> <1225225434.1115.217.camel@rc-desk> <1225235731.1369.8.camel@johannes.berg> <1225236760.1115.245.camel@rc-desk> <20081028233841.GA12554@isilmar.linta.de> <20081029002713.GA16554@isilmar.linta.de> <1225300252.1115.266.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225300252.1115.266.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Oct 29, 2008 at 10:10:52AM -0700, reinette chatre wrote:
> On Tue, 2008-10-28 at 17:27 -0700, Dominik Brodowski wrote:
> > With CONFIG_WIRELESS_OLD_REGULATORY=y, both the old and the new firmware
> > works. Without, only the old firmware works.
> 
> (I assume you mean "only the new firmware works")

yes, sorry for the confusion.

> > I'd think that at least the error message could be clarified a bit
> > (is it really a "Microcode SW error"?)... also, it might be a corner case
> > whether the new firmware would better be called -2 because of this
> > incompatibility?
> 
> We can do away with the error message with a driver change. This patch
> should take care of it:

but could we get a more meaningful error message instead? Such as "No
regulartory information found -- therefore the microcode fails to cooperate
with you! Either use iw available at ... or recompile with
CONFIG_WIRELESS_OLD_REGULATORY set to yes." ?

Thanks,
	Dominik
