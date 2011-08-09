Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1HIJu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:50:57 -0400
Date: Tue, 9 Aug 2011 11:50:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110809095050.GD2152@redhat.com> (sfid-20110809_115100_685709_9E4BE636)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <20110808093512.GB2168@redhat.com>
 <4E404D5C.30401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E404D5C.30401@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gertjan 

On Mon, Aug 08, 2011 at 10:55:56PM +0200, Gertjan van Wingerde wrote:
> Sorry for responding this late. I just didn't find the bandwidth to look at this earlier :-(
> 
> First of all, I don't think stable should be cc-ed on this particular patch. Although the ideas
> of the patch are certainly applicable to the stable trees, this patch will simply not apply to
> 3.0 or earlier, since the code you are patching has been moved around between 3.0 and 3.1.

CCing stable mean that we want that fix in stable kernel, not that patch
have to apply cleanly. When greg-kh will be applying patch on stable tries,
I'll provide proper backport.

> Second, I think it would be appropriate to split the patch in 2, or maybe 3, parts:
> 	1. The hunk to rt2x00usb to reverse the entry flag handling and the tx dma done handling.
> 	2. The hunk that checks that the entry on which the TX status is being reported has
>            already been properly completed its TX done handling.
> 	3. The remainder, i.e. the retrying of handling a TX status report if the entry hasn't been
>            fully completed its TX done handling yet. 
> 
> The code in this area has been proven to be very fragile, so I prefer to make mini changes to it in
> small steps, so that we can properly bisect which change exactly has caused a problem.
> 
> See further down for more thoughts.

Thanks for comments. I'll repost small patch that should fix the bug
and don't do things you dislike.

Stanislaw
