Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49161 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0LVSbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:31:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:31:17 -0800
Date: Wed, 22 Dec 2010 13:31:29 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>
Subject: Re: [PATCH] ath9k: fix aphy / wiphy idle mismatch
Message-ID: <20101222183129.GA8384@tux>
References: <1292862599-26335-1-git-send-email-lrodriguez@atheros.com>
 <20101222182851.GC10046@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101222182851.GC10046@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 10:28:51AM -0800, John W. Linville wrote:
> On Mon, Dec 20, 2010 at 11:29:59AM -0500, Luis R. Rodriguez wrote:
> > ath9k supports its own set of virtual wiphys, and it uses
> > the mac80211 idle notifications to know when a device needs
> > to be idle or not. We recently changed ath9k to force idle
> > on driver stop() and on resume but forgot to take into account
> > ath9k's own virtual wiphy idle states. These are used internally
> > by ath9k to check if the device's radio should be powered down
> > on each idle call. Without this change its possible that the
> > device could have been forced off but the virtual wiphy idle
> > was left on.
> > 
> > Cc: stable@kernel.org
> > Cc: Paul Stewart <pstew@google.com>
> > Cc: Amod Bodas <amod.bodas@atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> > 
> > I'm not yet sure if this actually fixes an issue but it
> > certainly is a proper ammendment to the other idle fix
> > submitted for stable for suspend/resume.
> 
> Can you refresh me on which patch that is?

Sure, its:

    ath9k: fix assumptions for idle calls on suspend/resume

  Luis
