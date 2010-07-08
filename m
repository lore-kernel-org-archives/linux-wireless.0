Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from colo4.heeltoe.com ([207.210.93.145]:46454 "EHLO
	colo4.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0GHPfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 11:35:06 -0400
To: Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH] Added support for host sleep feature
From: Paul Fox <pgf@laptop.org>
cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-reply-to: <1278551628.3339.7.camel@localhost.localdomain> (sfid-20100708_024419_276276_7B25A76B)
References: <1278551628.3339.7.camel@localhost.localdomain> (sfid-20100708_024419_276276_7B25A76B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 08 Jul 2010 11:11:32 -0400
Message-ID: <8674.1278601892@foxharp.boston.ma.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amitkumar wrote:
 > From: Amitkumar Karwar <akarwar@marvell.com>
 > 
 > Existing "ethtool -s ethX wol X" command configures hostsleep
 > parameters, but those are activated only during suspend/resume,
 > there is no way to configure host sleep without actual suspend.

as background, can you expand on how this is useful?  i just spent
a bunch of time debugging issues with HOST_SLEEP_CFG and
HOST_SLEEP_ACTIVATE (which doesn't work on an 8388) on the XO-1
OLPC laptop, and i'm wondering whether or how this would have
helped.

as an aside, since i know you've helped OLPC with some of these
issues in the past, the pertinent results of my debugging are:
 http://dev.laptop.org/git/olpc-2.6/commit/?h=olpc-2.6.31&id=515dc7313c37218fa02888eb19fba065ca0ab63c
and
 http://dev.laptop.org/git/olpc-2.6/commit/?h=olpc-2.6.31&id=8db05fd8301980cf48ff10f61c977256e1f136b5

other nearby commits, all dated 6/22/2010, are related, but were
less central to the problems we were having.)

paul

 > 
 > This patch adds debugfs command to enable/disable host sleep based on
 > already configured host sleep parameters using wol command.
 > 
 > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
 > Signed-off-by: Kiran Divekar <dkiran@marvell.com>
 > ---
 >  drivers/net/wireless/libertas/README    |   12 ++++++
 >  drivers/net/wireless/libertas/cmd.c     |   61 ++++++++++++++++++++++++++++-
 >  drivers/net/wireless/libertas/cmd.h     |    2 +
 >  drivers/net/wireless/libertas/debugfs.c |   66 +++++++++++++++++++++++++++++++
 >  drivers/net/wireless/libertas/main.c    |   34 +---------------
 >  5 files changed, 142 insertions(+), 33 deletions(-)
 > 
....

=---------------------
 paul fox, pgf@laptop.org
