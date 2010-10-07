Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0JGIjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 04:39:55 -0400
Subject: Re: [PATCH 1/6] iwlwifi: schedule to deprecate software scan
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101006190343.GI2472@tuxdriver.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20101006173609.GH2472@tuxdriver.com>
	 <1286387500.12594.24.camel@wwguy-ubuntu>
	 <20101006190343.GI2472@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 10:39:50 +0200
Message-ID: <1286440790.3657.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 15:03 -0400, John W. Linville wrote:

> > The current HW scan implementation was improve a lot and sw scan will
> > cause problem, especially once we introduce P2P.
> 
> What support issues are caused by supporting software scanning?
> 
> Whatever issues are caused by scanning with P2P, doesn't mac80211
> have to handle them anyway?

Technically, yes, but there are some things it doesn't handle today, and
there are some things in mac80211's scan implementation that
unfortunately make our firmware somewhat unhappy. Also, when we have two
virtual interfaces (for p2p) the firmware can get completely confused by
a software scan, especially when we were operating as a p2p-GO.

But isn't this the wrong way around -- shouldn't you be arguing why it
should be kept and dig out bug reports about the HW scan implementation
that weren't addressed? ;-)

johannes

