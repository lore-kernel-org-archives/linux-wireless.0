Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0KXQYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:24:52 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101112030035.28522.75318.stgit@localhost6.localdomain6>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <20101112030035.28522.75318.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 17:24:50 +0100
Message-ID: <1290615890.3790.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-12 at 12:00 +0900, Bruno Randolf wrote:
> Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> signal value. Since the signal value usually fluctuates between different
> packets, an average can be more useful than the value of the last packet.
> 
> This uses the recently added generic EWMA library function.

John, please revert this patch ASAP -- it completely messed up some ABI,
and the performance discussion is also not over yet.

johannes

