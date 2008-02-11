Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43196 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYBKOYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 09:24:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] zd1211rw: Fix beacon filter flags thinko
Date: Mon, 11 Feb 2008 15:23:39 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <200802101603.56095.mb@bu3sch.de> <1202734431.11481.80.camel@johannes.berg>
In-Reply-To: <1202734431.11481.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802111523.39625.mb@bu3sch.de> (sfid-20080211_142420_696386_6E32A9F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 February 2008 13:53:51 Johannes Berg wrote:
> 
> On Sun, 2008-02-10 at 16:03 +0100, Michael Buesch wrote:
> > We must not clear the FIF_BCN_PRBRESP_PROMISC bit in the
> > new_flags. The zd-driver does support sending beacons and
> > probe responses to the host. What the flag does is say "Send me
> > all beacons and probe responses". And we actually do that. We always
> > do that, so we ignore the case when the bit is disabled. But that is
> > fine. But we must not clear the flag, as that tells mac80211 that
> > we do not support passing beacons and probe responses to the stack.
> > And that's not true.
> 
> Good explanation. Maybe it's needed with the filter flags defines/the
> config_filter callback description?

Yeah, I think so. Recent patches show that other people get it wrong, too. :)
I think I will submit a patch later.

-- 
Greetings Michael.
