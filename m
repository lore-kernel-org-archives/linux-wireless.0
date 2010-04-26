Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56890 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0DZSAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:00:12 -0400
Date: Mon, 26 Apr 2010 13:58:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V4] ssb: Implement virtual SPROM
Message-ID: <20100426175850.GD2387@tuxdriver.com>
References: <4bac487c.j3EXBzCzHYNAd+Ky%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4bac487c.j3EXBzCzHYNAd+Ky%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 26, 2010 at 12:39:08AM -0500, Larry Finger wrote:
> Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
> from the SPROM could be included in the kernel; however, this presents
> a problem in the generation of a unique, reproducible MAC address. The
> solution is to initialize the address to a known, workable value. Thus,
> the device will work without any further code. For an address that is
> preserved across reloads or reboots, a set of udev routines has been
> prepared that detect the special address and assign a random value that
> is preserved in a second udev rule file. The random address should be
> unique except for the case where a given box has more than one of these
> cards. This case is handles by adding the DEVPATH to the recognition rules.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Do we still want this patch?  Or do we think all the cases of a
"missing" SPROM were actually a "relocated" SPROM?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
