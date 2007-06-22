Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37710
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXFVJqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 05:46:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: kill antenna select ioctls
Date: Fri, 22 Jun 2007 11:45:37 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1182499821.21939.62.camel@johannes.berg> <200706221132.30211.mb@bu3sch.de> <200706221128.50091.IvDoorn@gmail.com>
In-Reply-To: <200706221128.50091.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706221145.38155.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 22 June 2007 11:28:49 Ivo van Doorn wrote:
> On Friday 22 June 2007 11:32, Michael Buesch wrote:
> > On Friday 22 June 2007 10:10:20 Johannes Berg wrote:
> > > Not used anywhere.
> > 
> > It's used in bcm43xx.
> > Though, I'm not sure anybody in userspace actually calls this strange ioctl.
> 
> rt2x00 uses these antenna_sel_{t,r}x fields,
> but they are also set within the rate selection.
> So with the ioctls taken out, the fields itself
> will still be changed.

Oh, ok. Then I remembered it incorrectly. I thought
the values were dead and always 0 now. So I'm OK with this patch,
as long as no userspace program calls it.

-- 
Greetings Michael.
