Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52062
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070AbXIRSHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 14:07:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
Date: Tue, 18 Sep 2007 20:04:19 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	linux-wireless@vger.kernel.org
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <46EF5534.3030609@lwfinger.net> <20070918174202.GB1466@bougret.hpl.hp.com>
In-Reply-To: <20070918174202.GB1466@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709182004.20227.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 September 2007 19:42:02 Jean Tourrilhes wrote:
> On Mon, Sep 17, 2007 at 11:33:56PM -0500, Larry Finger wrote:
> > John,
> > 
> > Yoshifuji Hideaki reported that commit 4cf92a3c broke the bcm43xx driver. I was able to duplicate
> > the problem with WEP encryption and ifconfig control of the device. The problem does not happen with
> > WPA or when using NetworkManager with WEP.
> > 
> > This patch was supposed to be a fix for the bug reported at
> > http://bugzilla.kernel.org/show_bug.cgi?id=8686; however, it does not.
> > 
> > This commit should be reverted before 2.6.23 is released.
> > 
> > Thanks,
> > 
> > Larry
> 
> 	Larry,
> 
> 	Could you be more explicit ? Reverting the patch will just
> bring back the old bug, and the old code was obviously wrong. I don't
> like the idea of trading one bug for another bug. It looks to me like
> nobody knows what's exactly happening in the driver and we are just
> trying random fixes and see what breaks.
> 	Could you figure out what's exactly happening and make a
> proper fix ?

Indeed. The patch does fix a bug. So reverting it is not really
an option. I'm not sure how that patch can introduce such breakage, though.
It must be some special ordering of wext calls that trigger this.
It might be that there's another bug similiar to this one breaking
the state machine.
Can you monitor if all needed steps are properly done (assoc, etc...)
to get a WEP connection? If not, where does it fail?

-- 
Greetings Michael.
