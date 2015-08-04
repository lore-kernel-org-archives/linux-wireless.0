Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63893 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbbHDSLh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 14:11:37 -0400
From: Chor Teck Law <ctlaw@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	"mbizon@freebox.fr" <mbizon@freebox.fr>
CC: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v5] Add new mac80211 driver mwlwifi.
Date: Tue, 4 Aug 2015 18:11:29 +0000
Message-ID: <db9a0d4afa9b435d8efa380715955bee@SC-EXCH03.marvell.com> (sfid-20150804_201140_279902_EC02D84E)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, August 04, 2015 10:02 AM
> 
> Maxime Bizon <mbizon@freebox.fr> writes:
> 
> > On Fri, 2015-07-03 at 06:10 +0000, David Lin wrote:
> >
> > Hello,
> >
> >> The Linux driver for WRT1900AC. The work was initially developed as
> >> part of openwrt effort and maintained on
> >> https://github.com/kaloz/mwlwifi.
> >
> > I see *massive* code duplication with the mwl8k driver.
> 
> I haven't looked at the driver myself yet. Do you have any estimates
> how much duplication there is?
> 

mwl8k was a driver for chips few generations older sponsored by Marvell. We did leverage part of driver framework that is still applicable. However, for the current development, the firmware API specs, chip capabilities and bandwidth requirements have changed in order to handle newer technologies and features.

> > This is, I guess, not a surprise since the supported chipset are an
> > evolution of the ones supported by mwl8k, just look at how
> > close/similar the descriptor format is.
> >
> > The problem is that each new Marvell chipset comes with a new
> firmware
> > version, and there is no effort to have a common firmware API or code
> > base that supports multiple chipsets.
> >
> > That pushes the bloat on the kernel side, do we really agree on that
> ?
> 
> That is a very good question. The kernel should not be a dumping ground
> for random drivers which duplicate lots of code but this is a sort of
> gray area and depends on the case.
>

No, we are not treating the submission as dumping! We would not have responded with effort to meet the requests/feedback if so. We appreciate and have taken the feedbacks seriously to complete to patch6. In fact the submission was requested by some community members who has seen the benefit of its evolvement on openwrt github, and they would like to see the new driver consolidated into the wireless mainline.

Due to hardware, firmware, specs and requirements change over time, it is not feasible for us to revisit generations old products or making sure new changes are backward compatible with it. (If desired, we welcome the community to take any new useful changes that are independent of chip rev to other similar branches.)

Lastly, I do not think we are creating a precedence with different generation of drivers supporting different families of chips. 
 
>
> Did Marvell reply to this? I didn't find any comments about this.
>

Sorry, we have missed that email earlier... I hope the above response will suffice to get accepted. Best regards,



 
> --
> Kalle Valo
