Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3108 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965739AbXBOPis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:38:48 -0500
Date: Thu, 15 Feb 2007 10:06:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: round_jiffies for schedule_delayed_work?
Message-ID: <20070215150615.GB3310@tuxdriver.com>
References: <1171489163.6093.30.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171489163.6093.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 14, 2007 at 10:39:23PM +0100, Johannes Berg wrote:
> Hi,
> 
> I was looking through recent commits in wireless-dev and found
> e226b8aa8921b6b75dcd0142a990b8c7bc1548fd which is correct, but I was
> wondering if it may be possible to do it more efficiently.
> 
> We don't really need this code running every second after we init,
> having it run every second on average is good enough. I don't see any
> way to do this with the delayed work API though since
> schedule_delayed_work simply adds the timer at jiffies+delay.
> 
> Should we be using a timer and round_jiffies() instead?

Using round_jiffies seems reasonable.  Perhaps the delayed work API
can be extended to use it?

John
-- 
John W. Linville
linville@tuxdriver.com
