Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45938
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966549AbXEGUuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 16:50:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: Allow sleeping in set_key op
Date: Mon, 7 May 2007 22:50:42 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200705062037.35037.mb@bu3sch.de> <200705071517.21331.flamingice@sourmilk.net>
In-Reply-To: <200705071517.21331.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200705072250.42407.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 May 2007 21:17:14 Michael Wu wrote:
> On Sunday 06 May 2007 14:37, Michael Buesch wrote:
> > Allow drivers to sleep in the setkey function, as it's rather
> > complicated to defer set_key to a workqueue in the driver
> > (error code is lost, keyconf->hw_key_idx is possibly hard
> > to get right.)
> >
> I'd rather not defer to a workqueue. That just patches over the awkward 
> locking that the sta_info code has, which is really the reason why you can't 
> sleep in set_key.

Well, but it seems nobody is fixing the locking. I was told it's
almost impossible or something like that. ;)
This is just trying to fix showstopper bugs for bcm43xx.

-- 
Greetings Michael.
