Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49480 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0AJNum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:50:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: flush workqueue before calling driver ->stop() method
Date: Sun, 10 Jan 2010 14:50:34 +0100
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20100110130752.GG1735@mail.wantstofly.org> <201001101443.38872.mb@bu3sch.de> <1263131158.7773.17.camel@johannes.local>
In-Reply-To: <1263131158.7773.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001101450.37204.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 January 2010 14:45:58 Johannes Berg wrote:
> On Sun, 2010-01-10 at 14:43 +0100, Michael Buesch wrote:
> > On Sunday 10 January 2010 14:40:39 Johannes Berg wrote:
> > > See, it's not strictly forbidden to queue work, there's just no
> > 
> > Ok, well. Lennert's mail sounded different to me.
> 
> Ok. But would you agree with my assertion? I don't see what flushing it
> again would buy us since after stop, it doesn't seem to matter when it
> gets executed.

Yeah, well. I was just thinking about possible existing driver bugs that depended
on the current behavior to flush the workqueue after stop. Those would probably
silently blow up.
And as I thought (I might have been wrong) that there was a constraint on drv_stop
callbacks to not being allowed to queue work, I thought it was a good idea to assert that.
In my experience work flush bugs are hard to track down and debug, so...

Well, not that this is important, but well...

-- 
Greetings, Michael.
