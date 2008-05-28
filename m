Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2615 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYE1T2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 15:28:23 -0400
Date: Wed, 28 May 2008 15:12:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Fix controller restart crash
Message-ID: <20080528191224.GB25770@tuxdriver.com> (sfid-20080528_212842_407066_ECA9ABF7)
References: <200805221706.37185.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805221706.37185.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 05:06:36PM +0200, Michael Buesch wrote:
> This fixes a kernel crash on rmmod, in the case where the controller
> was restarted before doing the rmmod.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Stefano, this is untested. Please test by doing
> echo -n 1 >/debug/b43legacy/phy*/restart
> rmmod b43legacy
> It should not crash anymore at the rmmod (actually the restart should
> also hang in b43legacy, as it has a deadlock, which this patch also fixes).

Anyone get a chance to test this one?

John
-- 
John W. Linville
linville@tuxdriver.com
