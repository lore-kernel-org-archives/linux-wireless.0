Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:55605 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab3FLRoF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 13:44:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Date: Wed, 12 Jun 2013 10:43:19 -0700
Subject: RE: [PATCH] mwifiex: Add module parameter for regdomain
Message-ID: <477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com> (sfid-20130612_194409_936058_CB803598)
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
 <877ghz3il6.fsf@purkki.adurom.net>
In-Reply-To: <877ghz3il6.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> > From: Avinash Patil <patila@marvell.com>
> >
> > Allow a regulatory domain country code to be specified at boot
> > using a module argument.  This overrides the firmware regulatory
> > mode.
> >
> > This patch also enables uAP to operate in 11a mode with hostapd.
> >
> > Signed-off-by: Avinash Patil <patila@marvell.com>
> > Signed-off-by: Paul Stewart <pstew@chromium.org>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> 
> This looks ugly. Why can't you use the proper nl80211 interface and
> instead want to add a driver specific hack?

"iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
What we need here is a *driver* hint.
Furthermore, with a driver regulatory hint, the passive-scan and no-ibss flags are cleared so we can start AP with hostapd on 5G band.

Thanks,
Bing

> 
> --
> Kalle Valo
