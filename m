Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52774 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbXKTAQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 19:16:28 -0500
Date: Tue, 20 Nov 2007 01:15:49 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Andreas Schwab <schwab@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
Subject: Re: [PATCH v3] remove bcm43xx
Message-ID: <20071120011549.6b04bb4d@morte> (sfid-20071120_001632_631701_4BDAB7F6)
In-Reply-To: <jed4u5esbo.fsf@sykes.suse.de>
References: <20071119202121.6ad3fa70@morte>
	<200711192300.12183.rjw@sisk.pl>
	<20071119231935.535674ba@morte>
	<jehcjheubn.fsf@sykes.suse.de>
	<20071120001329.3524494a@morte>
	<jed4u5esbo.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Nov 2007 00:19:55 +0100
Andreas Schwab <schwab@suse.de> wrote:

> Stefano Brivio <stefano.brivio@polimi.it> writes:
> 
> > This is strange. Because it has been developed mainly on PPC. Plus, if
> > you could better define "does not work"
> 
> See <http://marc.info/?l=linux-wireless&m=119356497407301&w=2>.

It looks like we don't get a valid txstatus even if the txstatus indicator
register told us we could read it. The only difference I can see between
bcm43xx and b43 here is that in bcm43xx we allowed the whole register to be
non-zero, while in b43 we check a bit only (as per v4 specs). Would you
mind to try this:

--- drivers/net/wireless/b43/main.c.orig        2007-11-20 01:12:12.186524483 +0100
+++ drivers/net/wireless/b43/main.c     2007-11-20 01:12:34.922702865 +0100
@@ -947,7 +947,7 @@

        while (1) {
                v0 = b43_read32(dev, B43_MMIO_XMITSTAT_0);
-               if (!(v0 & 0x00000001))
+               if (!v0)
                        break;
                v1 = b43_read32(dev, B43_MMIO_XMITSTAT_1);

(probably it's not the solution, I just want to see what happens then).
BTW, what firmware are you using? Michael, any clue?


-- 
Ciao
Stefano
