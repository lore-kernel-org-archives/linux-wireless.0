Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49406
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXBENyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 08:54:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Date: Mon, 5 Feb 2007 14:53:57 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702051412.50703.mb@bu3sch.de> <1170682980.3572.16.camel@johannes.berg>
In-Reply-To: <1170682980.3572.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702051453.57919.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 14:43, Johannes Berg wrote:
> On Mon, 2007-02-05 at 14:12 +0100, Michael Buesch wrote:
> 
> > -	u16 rts_cts_duration;	/* duration field for RTS/CTS frame */
> 
> I'd think this was here for a purpose. Maybe some hardware generates the
> frame but not the duration field?
> 
> Then again, if that's the case we can always export the functions to
> calculate it as library functions.

Only rt2x00 used it to generate an rts frame with it own custom
generation function. So after switching to the d80211 RTS API
it's unneeded now.

If some driver needs the duration field in future, we should
simply export ieee80211_rts_duration().

-- 
Greetings Michael.
