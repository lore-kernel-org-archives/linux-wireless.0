Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50885 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaJVOQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 10:16:42 -0400
Message-ID: <1413987394.28927.5.camel@jlt4.sipsolutions.net> (sfid-20141022_161645_783014_02D124F3)
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Wed, 22 Oct 2014 16:16:34 +0200
In-Reply-To: <20141022141547.GB29537@magnum.frso.rivierawaves.com> (sfid-20141022_161551_566780_F7C38129)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
	 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
	 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
	 <20141020153421.GC7691@magnum.frso.rivierawaves.com>
	 <1413833597.32358.6.camel@jlt4.sipsolutions.net>
	 <20141021152658.GA14839@magnum.frso.rivierawaves.com>
	 <1413917246.1998.7.camel@jlt4.sipsolutions.net>
	 <20141022135438.GA29537@magnum.frso.rivierawaves.com>
	 <1413986851.28927.4.camel@jlt4.sipsolutions.net>
	 <20141022141547.GB29537@magnum.frso.rivierawaves.com>
	 (sfid-20141022_161551_566780_F7C38129)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 16:15 +0200, Karl Beldan wrote:

> > Wait, are you saying it *is* out of bounds when VHT isn't turned on?
> > 
> 
> The smatch warning pops on
> {
> if (!(mi->groups[i].supported & BIT(j)))
> 	continue;
> 	...
> else if (i >= MINSTREL_VHT_GROUP_0)
> }
> 
> MINSTREL_VHT_GROUP_0 is out of bonds (not i which remains <
> ARRAY_SIZE(mi->groups)).

Ah, ok, right.

johannes

