Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:38942 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab3FLTCK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 15:02:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Ben Greear <greearb@candelatech.com>, Kalle Valo <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Date: Wed, 12 Jun 2013 12:01:23 -0700
Subject: RE: [PATCH] mwifiex: Add module parameter for regdomain
Message-ID: <477F20668A386D41ADCC57781B1F70430EA268B4A3@SC-VEXCH1.marvell.com> (sfid-20130612_210214_546789_D44E087B)
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
 <877ghz3il6.fsf@purkki.adurom.net>
 <477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com>
 <8738sn2mcf.fsf@purkki.adurom.net> <51B8C41E.7050907@candelatech.com>
In-Reply-To: <51B8C41E.7050907@candelatech.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >> "iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
> >>
> >> What we need here is a *driver* hint. Furthermore, with a driver
> >> regulatory hint, the passive-scan and no-ibss flags are cleared so we
> >> can start AP with hostapd on 5G band.
> >
> > So it's a driver hint which is coming from user space via a module
> > parameter. IMHO you are abusing interfaces here. Is there any better way
> > to solve your problem?
> 
> It would be nice to have some way to do this for ath9k and other NICs
> as well.  Best I could come up with is a similar hack for ath9k.
> 
> I think part of the problem is that this config info needs to be
> available very early in the module loading/init logic, so it's
> too late to be configured using 'iw' or similar.

Exactly. regulatory_hint () needs to be called right after wiphy registration.

Thanks,
Bing

> 
> Thanks,
> Ben

