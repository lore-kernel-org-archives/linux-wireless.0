Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0CXQQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 12:16:01 -0400
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100324140034.6a6d91c9@dhcp-lab-109.englab.brq.redhat.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
	 <20100324140034.6a6d91c9@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 09:16:02 -0700
Message-ID: <1269447362.6935.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 14:00 +0100, Stanislaw Gruszka wrote:
> On Wed, 24 Mar 2010 10:57:42 +0800
> Zhu Yi <yi.zhu@intel.com> wrote:
> 
> > Mac80211 drivers can now pass paged SKBs to mac80211 via
> > ieee80211_rx{_irqsafe}. The implementation currently use
> > skb_linearize() in a few places i.e. management frame handling,
> > software decryption, defragmentation and A-MSDU process. 
> 
> What benefits this gives? Only driver which need non linear skbs
> is iwliwifi and nicely handle that by itself. I do not see any 
> other potential users for that. Can we wait for some other
> users before put that feature into mac stack?

Hell no. We will get more users, and even putting it into the stack now
gives us the benefit of being able to improve it -- iwlwifi doesn't
"nicely" handle it after all.

johannes

