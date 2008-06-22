Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37557 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYFVRXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 13:23:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH stable] b43legacy: Fix possible NULL pointer dereference in DMA code
Date: Sun, 22 Jun 2008 19:23:24 +0200
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
References: <200806201146.12984.mb@bu3sch.de> <20080622165959.GA18163@kroah.com>
In-Reply-To: <20080622165959.GA18163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806221923.24856.mb@bu3sch.de> (sfid-20080622_192337_302923_0606710D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 June 2008 18:59:59 Greg KH wrote:
> On Fri, Jun 20, 2008 at 11:46:12AM +0200, Michael Buesch wrote:
> > This fixes a possible NULL pointer dereference in an error path of the
> > DMA allocation error checking code.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > This patch is not merged to an upstream tree, yet, but is sent to John.
> 
> In the future, if you want patches to get automatically added to stable
> when they go into Linus's tree, just add:
> 	Cc: stable <stable@kernel.org>
> 
> to the "Signed-off-by:" area and we will get notified of it at merge
> time, so you don't have to resend it after it gets applied.

Ok, however often enough it is not trivial to port patches from head to stable.
A bug introduced by a stable port isn't something we really want to risk, I
think. So I'd like to test all stable patches in their final state before they
get submitted to stable.
So for this trivial patch I could probably have used the CC magic, however.

-- 
Greetings Michael.
