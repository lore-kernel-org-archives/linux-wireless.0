Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56201 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2DBAC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 20:02:27 -0400
Date: Sun, 1 Apr 2012 19:24:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: sgruszka@redhat.com, linux@dominikbrodowski.net,
	linux-wireless@vger.kernel.org
Subject: Re: 3945ABG fails to connect (3.4-rc1)
Message-ID: <20120401232407.GA7962@tuxdriver.com> (sfid-20120402_020231_728613_43A110C0)
References: <20120401080419.GA5207@comet.dominikbrodowski.net>
 <20120401165230.GA2399@redhat.com>
 <20120401.172452.1589857453193260701.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120401.172452.1589857453193260701.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 01, 2012 at 05:24:52PM -0400, David Miller wrote:
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Sun, 1 Apr 2012 18:52:31 +0200
> 
> > On Sun, Apr 01, 2012 at 10:04:19AM +0200, Dominik Brodowski wrote:
> >> Somewhere in between 3.3.0 and 3.4-rc1 my notebook fails to connect to my
> >> local AP:
> >> 
> >> 02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
> >> 
> >> Snippets from dmesg:
> > [snip]
> >> [   59.605953] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> >> [   69.607344] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
> >> [   69.609931] cfg80211: Calling CRDA to update world regulatory domain
> >> [   69.612438] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
> > Most likely this is fixed by: 
> > http://marc.info/?l=linux-wireless&m=133180823427374&w=2
> > 
> > Plese test, thanks.
> 
> John, please make sure this gets to me after proper testing.

In fact, you already have it! :-)

commit e92109be7a6a04808c3ed586475ba1e5ea56ecbd
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Mar 15 11:42:49 2012 +0100

    iwlegacy: fix BSSID setting

...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
