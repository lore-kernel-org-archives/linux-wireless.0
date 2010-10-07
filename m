Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab0JGJio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 05:38:44 -0400
Subject: Re: Latest wireless-testing has broken scan locking.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101007093832.GD2435@redhat.com>
References: <4CAD48DA.9010208@candelatech.com>
	 <1286440488.3657.23.camel@jlt3.sipsolutions.net>
	 <20101007091839.GC2435@redhat.com>
	 <1286443486.3657.32.camel@jlt3.sipsolutions.net>
	 <20101007093832.GD2435@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 11:38:39 +0200
Message-ID: <1286444319.3657.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 11:38 +0200, Stanislaw Gruszka wrote:

> > FWIW, I've looked at the code and all we do is possibly acquire the
> > iflist_mtx (which is fine under local->mtx) and do some driver calls,
> > which should also be fine.
> > 
> > So what do you think?
> 
> Let's fix with your patch. I'm going to test it (on hw scan :/ at least).

I've tested it on hwsim already, but you won't run into this code path
at all with hw scan.

johannes

