Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21035 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYE3WjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 18:39:05 -0400
Subject: Re: [PATCH] b43legacy: Fix controller restart crash
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <20080528191224.GB25770@tuxdriver.com>
References: <200805221706.37185.mb@bu3sch.de>
	 <20080528191224.GB25770@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 30 May 2008 18:39:02 -0400
Message-Id: <1212187142.18496.19.camel@dv> (sfid-20080531_003908_825724_817AFD1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-28 at 15:12 -0400, John W. Linville wrote:

> > Stefano, this is untested. Please test by doing
> > echo -n 1 >/debug/b43legacy/phy*/restart
> > rmmod b43legacy
> > It should not crash anymore at the rmmod (actually the restart should
> > also hang in b43legacy, as it has a deadlock, which this patch also fixes).
> 
> Anyone get a chance to test this one?

Yes, the patch is fine.

Unloading b43legacy hangs without the patch and works properly with the
patch.

-- 
Regards,
Pavel Roskin
