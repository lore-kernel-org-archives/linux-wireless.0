Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0CYH2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 03:28:25 -0400
Date: Thu, 25 Mar 2010 08:26:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
Message-ID: <20100325072627.GA2562@dhcp-lab-161.englab.brq.redhat.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com> <20100324140034.6a6d91c9@dhcp-lab-109.englab.brq.redhat.com> <1269447362.6935.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269447362.6935.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 09:16:02AM -0700, Johannes Berg wrote:
> > > Mac80211 drivers can now pass paged SKBs to mac80211 via
> > > ieee80211_rx{_irqsafe}. The implementation currently use
> > > skb_linearize() in a few places i.e. management frame handling,
> > > software decryption, defragmentation and A-MSDU process. 
> > 
> > What benefits this gives? Only driver which need non linear skbs
> > is iwliwifi and nicely handle that by itself. I do not see any 
> > other potential users for that. Can we wait for some other
> > users before put that feature into mac stack?
> 
> Hell no. We will get more users, and even putting it into the stack now
> gives us the benefit of being able to improve it

But wait, isn't that all just workaround for bad performing allocator,
what should be fixed in proper place not in mac80211 nor iwlwifi. What
for exactly this is needed, concretes please - that is not described in
patch changelog.

>  -- iwlwifi doesn't
> "nicely" handle it after all

Oh well, at least now we have no more bugs with that (I hope).

Stanislaw
