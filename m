Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:43849 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752997AbXDMJiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 05:38:10 -0400
Date: Fri, 13 Apr 2007 11:36:38 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev 1  PHYs
Message-ID: <20070413113638.10db9767@localhost>
In-Reply-To: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Apr 2007 11:08:53 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On PPC architecture with phy->rev == 1, machine checks occur during
> initialization of the "Extended G PHY registers". This problem was
> also seen on bcm43xx-softmac, and was fixed by conditionally skipping
> over certain reads/writes of these registers.  The same solution has been
> applied here with testing by David Woodhouse.  Note: These modifications
> are not found in the specifications, but are needed for PPC.

I don't think this patch has to be reverted, but I still think that it's
better to notice the reverse engineers team about failing operations
and understand the real problem rather than hiding it. Which works in some
cases, but sometimes just hide other bugs.

I'm almost done with rewriting the whole A/G/N setup and init routines,
following the new v4 specs. This issue could even be related.


-- 
Ciao
Stefano
