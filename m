Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42149
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXB0PlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 10:41:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] d80211: fix sparse warnings
Date: Tue, 27 Feb 2007 16:40:21 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1172530759.3870.205.camel@johannes.berg> <1172539109.5835.28.camel@dv>
In-Reply-To: <1172539109.5835.28.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702271640.21252.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 February 2007 02:18, Pavel Roskin wrote:
> On Mon, 2007-02-26 at 23:59 +0100, Johannes Berg wrote:
> > This fixes some sparse warnings in d80211.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > ---
> > A few warnings remain:
> > 
> > net/d80211/ieee80211.c:820:37: warning: potentially expensive pointer subtraction
> 
> That's subtraction of pointers to types with sizes that are not power of
> two.  This could lead to expensive division operations.  In may cases,
> this warning indicates that using array indices instead of pointers
> would be more effective (and probably safer).

Uh, well.
I think it's this line, no?

	control->rts_rateidx = (int)(rate - tx->local->curr_rates);

The problem there is, we have a pointer into an array and we
need to get the index number into that array.
Any better way to get an index by a pointer and a basepointer?

-- 
Greetings Michael.
