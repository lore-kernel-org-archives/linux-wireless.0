Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18242 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbcGMQAT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 12:00:19 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
Date: Wed, 13 Jul 2016 15:59:46 +0000
Message-ID: <d379084a0b6d48278b5041e07ff9f3c5@SC-EXCH04.marvell.com> (sfid-20160713_180214_111010_0F30249D)
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	<1468417703-32716-2-git-send-email-akarwar@marvell.com>
	<87y455a7u3.fsf@purkki.adurom.net>
	<35fedc2035a64135a4d995aca379d4e9@SC-EXCH04.marvell.com>
 <87inw9zghp.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87inw9zghp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, July 13, 2016 9:18 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> Xinming Hu
> Subject: Re: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Kalle,
> >
> >> -----Original Message-----
> >> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> >> Sent: Wednesday, July 13, 2016 8:44 PM
> >> To: Amitkumar Karwar
> >> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> >> Xinming Hu
> >> Subject: Re: [PATCH v3 2/2] mwifiex: add hostcmd wext ioctl support
> >>
> >> Amitkumar Karwar <akarwar@marvell.com> writes:
> >>
> >> > From: Xinming Hu <huxm@marvell.com>
> >> >
> >> > This patch adds ndo_ioctl support to mwifiex netdev handlers.
> >> > This will be used to download hostcmds to firmware from userspace.
> >> > This is needed for manufacturing mode support in mwifiex. ndo_ioctl
> >> > is allowed only when mfg mode is enabled via module load
> parameters.
> >> >
> >> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> >> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >> > ---
> >> > v3: Add "select WIRELESS_EXT" in Kconfig to resolve kbuild test
> >> > robot
> >> errors.
> >> >     WEXT_PRIV seems to have a dependency with WIRELESS_EXT.
> >> > v2: 1) Sequence of these two patches are changed to resolve
> >> compilation
> >> >     error seen if only 1/2 is applied.
> >> >     2) Add "select WEXT_PRIV" in Kconfig to resolve warnings
> >> > reported
> >> by
> >> >     kbuild test robot.
> >>
> >> Why can't you use nl80211 testmode interface?
> >
> > These two patches facilitates user to configure manufacturing mode. We
> > have a separate firmware for this mode. It's needed to run special
> > WiFi conductive and radiated tests at factory.
> 
> This is exactly what nl80211 testmode is for.
> 
> > The userspace tools used for this purpose expects WEXT interface.
> 
> So convert them to use nl80211. I have done that myself, multiple times
> actually.
> 
> And for wireless extensions, from my point of view it's dead and buried.
> I'm not going to take any new wireless extension related code.

Thanks for your feedback. We will change the tools and prepare driver patch using nl80211 testmode.

Regards,
Amitkumar
