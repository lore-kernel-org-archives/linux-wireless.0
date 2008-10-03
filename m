Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:5775 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYJCVdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 17:33:07 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1822911wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 14:33:06 -0700 (PDT)
Subject: Re: [PATCH 3/8] b43: remove b43_radio_{read|write}16 from lo.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810032317.19971.mb@bu3sch.de>
References: <1223066926.6512.28.camel@brick>
	 <200810032317.19971.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 14:33:04 -0700
Message-Id: <1223069584.6512.42.camel@brick> (sfid-20081003_233311_411949_581122B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-03 at 23:17 +0200, Michael Buesch wrote:
> On Friday 03 October 2008 22:48:46 Harvey Harrison wrote:
> > Mostly by using the mask/set helpers. Some temporary variables have
> > also been eliminated.
> 
> I already told you two times that I do not like these patches.
> I also explained in great detail why this is the case.
> 
> Please drop these patches!
> If you send them one more time, I will immediately add your email address to
> my exim blacklist.
> 

OK, but you should still look at patch 1 for the unaligned access
helpers.

Patch 2 is small and easy to verify (only two lines), but fair enough.

Patch 3 makes the code flow a lot more obvious rather than relying on
a tmp variable to compose the masking/setting.

The rest I'll kick to the bitbucket...although I think you should look
at the portion of patch 5 that touches the function b43_radio_init2060
as it points out the _one_ place where a register is masking the value
of some other register...which is absolutely impossible to see unless
you do a series of patches like this.

It may be that it is intentional, and it has been this way as far back
in the git history as I can find, but at least now it can be seen.

-       b43_radio_write16(dev, 0x0005,
-                         (b43_radio_read16(dev, 0x0081) & ~0x0008) | 0x0008);

Cheers,

Harvey

Just for kicks, a combined diffstat:
 drivers/net/wireless/b43/lo.c          |  110 +++++--------
 drivers/net/wireless/b43/main.c        |   58 ++-----
 drivers/net/wireless/b43/phy_a.c       |  219 ++++++++++---------------
 drivers/net/wireless/b43/phy_common.c  |   10 +-
 drivers/net/wireless/b43/phy_common.h  |    2 -
 drivers/net/wireless/b43/phy_g.c       |  285 ++++++++++++++------------------
 drivers/net/wireless/b43/phy_n.c       |   62 ++++----
 drivers/net/wireless/b43/tables_nphy.c |    2 +-
 drivers/net/wireless/b43/wa.c          |    5 +-
 9 files changed, 300 insertions(+), 453 deletions(-)

