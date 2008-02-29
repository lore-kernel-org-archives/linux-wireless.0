Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:31794
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946AbYB2XtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:49:16 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: FIF_ filter flags
Date: Fri, 29 Feb 2008 23:39:27 +0000
Cc: "Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802292339.27174.linux@baker-net.org.uk> (sfid-20080229_234920_378694_469ECF42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've spotted something in the way rt2x00 handles the filter setting flags that 
doesn't seem to match the documentation. I suspect it makes no difference in 
practice but there is a change needed in that area anyway so I'd like to get 
it right in the patch.

The documentation says a driver should clear any flags for data which it can't 
provide but makes no mention of doing anything about unrequested data that it 
does provide. The current rt2x00 implementation will set the relevant flag if 
it can't help providing something that wasn't asked for.

For example rt2x00 devices only have one promiscuous mode that covers traffic 
in the same and other BSSes therefore if either of FIF_PROMISC_IN_BSS or 
FIF_OTHER_BSS are set then the driver will set both of them in the returned 
flags value.

It will also for some devices set the FIF_ALLMULTI flag if mc_count is non 
zero.

If this behaviour is considered desirable then I'll keep it working when 
making the change but if not I'll remove it.

Thanks

Adam
