Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64581 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbXIWP1o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 11:27:44 -0400
Date: Sun, 23 Sep 2007 17:27:43 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211: Fix crashes with NULL mac addresses (monitor mode)
Message-ID: <20070923152743.GA23532@deine-taler.de>
References: <200709231626.22446.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709231626.22446.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:


> This fixes NULL pointer dereferences.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Michael, there is a patch in my development tree (branch
zd1211rw-dev), which fixes the MAC address handling. It ensures
that the mac address is not accessed over a NULL pointer. It also
ensures that a MAC address, which is different from the address
from the device EEPROM can be set. Additionally it introduces an
open flag, which might be helpful to handle the channel setting
problem.

Your patch solves the issue of NULL pointer accesses, but not the
real cause of the problem.

Look at this gitweb output:

http://deine-taler.de/git-bin/gitweb.cgi?p=zd1211rw.git;a=shortlog;h=zd1211rw-dev

The patch is called "Fixed: MAC address handling".

The git URL is:

git://deine-taler.de/git/zd1211rw.git

Daniel is normally reviewing my patches and forwards them to
linux-wireless. This is our way to ensure quality control before
the patches hit John's tree.

-- 
Uli Kunitz
