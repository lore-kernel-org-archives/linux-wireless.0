Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9564 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbcGMP0M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 11:26:12 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
Date: Wed, 13 Jul 2016 15:25:58 +0000
Message-ID: <35fedc2035a64135a4d995aca379d4e9@SC-EXCH04.marvell.com> (sfid-20160713_172820_393729_4E9AD60C)
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	<1468417703-32716-2-git-send-email-akarwar@marvell.com>
 <87y455a7u3.fsf@purkki.adurom.net>
In-Reply-To: <87y455a7u3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, July 13, 2016 8:44 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> Xinming Hu
> Subject: Re: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch adds ndo_ioctl support to mwifiex netdev handlers.
> > This will be used to download hostcmds to firmware from userspace.
> > This is needed for manufacturing mode support in mwifiex. ndo_ioctl is
> > allowed only when mfg mode is enabled via module load parameters.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v3: Add "select WIRELESS_EXT" in Kconfig to resolve kbuild test robot
> errors.
> >     WEXT_PRIV seems to have a dependency with WIRELESS_EXT.
> > v2: 1) Sequence of these two patches are changed to resolve
> compilation
> >     error seen if only 1/2 is applied.
> >     2) Add "select WEXT_PRIV" in Kconfig to resolve warnings reported
> by
> >     kbuild test robot.
> 
> Why can't you use nl80211 testmode interface?

These two patches facilitates user to configure manufacturing mode. We have a separate firmware for this mode. 
It's needed to run special WiFi conductive and radiated tests at factory. The userspace tools used for this purpose expects WEXT interface.

Regards,
Amitkumar
