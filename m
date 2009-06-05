Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50253 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEMad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 08:30:33 -0400
Date: Fri, 5 Jun 2009 08:25:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
Message-ID: <20090605122503.GA2791@tuxdriver.com>
References: <200906042318.33895.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200906042318.33895.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
> From: Matthieu CASTET <castet.matthieu@free.fr>
> 
> Fix possible unaligned u32 access in b43_generate_plcp_hdr().
> Unaligned data is read/write with a u32 pointer instead of using the
> packed structure. Some versions of gcc ignore the "packed" attribute, if the
> structure element is accessed through a local pointer.
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

That seems pretty brain-dead...can you cite a source for this
information?  The patch seems like a no-op...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
