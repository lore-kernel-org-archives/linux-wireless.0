Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44085 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbZJGXJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 19:09:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
Date: Thu, 8 Oct 2009 01:08:25 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net> <1254955015.3713.9.camel@johannes.local> <4ACD1998.5020902@lwfinger.net>
In-Reply-To: <4ACD1998.5020902@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910080108.27024.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 October 2009 00:43:36 Larry Finger wrote:
> Johannes Berg wrote:
> > This is because when stopping polling we need to cancel the work and
> > sync on it, but when starting it's completely async so starting can be
> > in any context.
> 
> Does that mean that start could be moved outside the mutex_lock so
> that the start and stop would look symmetrical in b43?

I think it's already complicated enough what's safe in b43 to do
outside of the locks. Let's not complicate it further. The simple rule is:
Do it locked. The only exception really are syncing functions which sync
for code holding the same lock.

-- 
Greetings, Michael.
