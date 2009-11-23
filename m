Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:43922 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbZKWLCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:02:07 -0500
Date: Mon, 23 Nov 2009 12:02:11 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mwl8k: split driver by chipset
Message-ID: <20091123110211.GS20214@mail.wantstofly.org>
References: <1258931158.12095.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258931158.12095.33.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,


On Sun, Nov 22, 2009 at 03:05:58PM -0800, Dan Williams wrote:

> No functional changes, but split the code up to make it
> easier to add support for other Libertas softmac chipsets
> like the 88w8361, which has slightly different RX and TX
> descriptors and some slightly different commands.

As to RX/TX desc layout, see below.


> Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> ---
> Note: patch is large (code reshuffle) so in case it gets rejected:
> 
> http://bigw.org/~dan/mwl8k-split.patch

I've been thinking about splitting up mwl8k.c for a while as well
now, but I've resisted it so far, as I wasn't sure what the split
would have to look like after support for more device types would
be added.

The interface with the wireless chip is almost entirely defined
by the firmware running on it, and not by the actual wireless chip
itself.  So e.g. putting the RX desc handling in files named after
the chip is somewhat confusing (but I guess it's my fault for naming
the rxd ops like that in the first place).

This isn't just a theoretical issue: there are generally two different
firmware branches for the chips that mwl8k supports (AP firmware and
STA firmware), and the rxd format depends on which firmware you use.
So e.g. if you put a STA firmware image on, say, the 8366, you'll end
up having to use the rxd ops that are currently marked as being for
the 8687, and not the "8366" ones.  (I only found this out after
submitting that round of patches.)

I was wondering if we should really make the support for each chip a
different kernel module as you did in your patch, but then I figured
that this might be a good way to let the user choose whether to load
AP or STA firmware if we have both available, which was still one of
the unsolved problems.  I.e., make mwl8366_ap and mwl8366_sta, and
then let the user choose which one to load.  Or is there a better way
of doing this?


> Note #2: I've tested firmware loading and up to GET_HW_SPEC with an
> 8361 card and I assume since there are no functional changes it will
> continue to work with 8687 and 8366.

You mentioned that there are slightly different commands on the 8361
firmware you have -- can you give some examples?


thanks,
Lennert
