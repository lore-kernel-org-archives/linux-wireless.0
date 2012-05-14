Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48216 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab2ENSCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 14:02:49 -0400
Date: Mon, 14 May 2012 13:56:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix single queue drivers
Message-ID: <20120514175603.GB2428@tuxdriver.com> (sfid-20120514_200253_829659_A1F0FAF8)
References: <1336405529.4325.31.camel@jlt3.sipsolutions.net>
 <4FAF3AB8.90900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FAF3AB8.90900@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 12, 2012 at 11:38:16PM -0500, Larry Finger wrote:
> On 05/07/2012 10:45 AM, Johannes Berg wrote:
> >From: Johannes Berg<johannes.berg@intel.com>
> >
> >My queue management rework broke drivers that don't
> >have multiple AC queues and register a single queue
> >only, causing a warning:
> >
> >WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues
> >
> >This was due to filling the queues wrongly and then
> >noticing the error when checking later.
> >
> >Reported-and-Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
> >Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> 
> John,
> 
> I know you have been busy and that Linus is restricting the patches
> to be added after 3.4-rc7; however, this one really needs to get
> into 3.4. If it does not make it, every wireless device with only
> one hardware queue will break.
> 
> Larry

Actually, it doesn't seem to apply in 3.4.  The original commit that
causes the problem (3a25a8c8) seems to only exist in wireless-next.

Is there some other version of this patch to apply for 3.4?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
