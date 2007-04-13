Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4270 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXDMApZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 20:45:25 -0400
Date: Thu, 12 Apr 2007 20:09:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev 1 PHYs
Message-ID: <20070413000950.GC3470@tuxdriver.com>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2007 at 11:08:53AM -0500, Larry Finger wrote:
> On PPC architecture with phy->rev == 1, machine checks occur during
> initialization of the "Extended G PHY registers". This problem was
> also seen on bcm43xx-softmac, and was fixed by conditionally skipping
> over certain reads/writes of these registers.  The same solution has been
> applied here with testing by David Woodhouse.  Note: These modifications
> are not found in the specifications, but are needed for PPC.

I added this patch to the Fedora rawhide kernels, but our Fedora QA
lead reports that he still has this crash:

	http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233011

I had diagnosed this to be the same crash as this patch was supposed
to address.  Was I in error?

He also reports that the problem still occurs on my FC7 test kernels,
which are very close to the current rawhide kernels but with the most
recent round of wireless-dev updates added.

	http://people.redhat.com/linville/kernels/fc7/

Any thoughts?

John
-- 
John W. Linville
linville@tuxdriver.com
