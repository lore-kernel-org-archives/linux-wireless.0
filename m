Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZHQPf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:35:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 08:35:30 -0700
Date: Mon, 17 Aug 2009 08:35:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 10/34] wireless: group Broadcom drivers on kconfig
Message-ID: <20090817153528.GD4352@mosca>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
 <1250281559-13041-11-git-send-email-lrodriguez@atheros.com>
 <69e28c910908150509i158bf2a6r33de5899cdc8bd13@mail.gmail.com>
 <43e72e890908151505s6cd9fea0p722de5a781a8ba8b@mail.gmail.com>
 <69e28c910908160615r7bcb3966s9c09319f607f64b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <69e28c910908160615r7bcb3966s9c09319f607f64b1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 16, 2009 at 06:15:43AM -0700, Gábor Stefanik wrote:
> 2009/8/16 Luis R. Rodriguez <lrodriguez@atheros.com>:
> > 2009/8/15 Gábor Stefanik <netrolller.3d@gmail.com>:
> >> On Fri, Aug 14, 2009 at 10:25 PM, Luis R.
> >> Rodriguez<lrodriguez@atheros.com> wrote:
> >>> This moves Broadcom wireless drivers into their own menu.
> >>> There are only 2 Broadcom specific drivers so we group
> >>> them into a menu which can expand. Although rndis_wlan
> >>> also supports Broadcom devices, RNDIS is a spec and other
> >>> vendors could technically implement solutions with it
> >>> as well so we keep that separate as users most likely
> >>> won't look for those devices under a Broadcom tag.
> >>>
> >>> Cc: Michael Buesch <mb@bu3sch.de>
> >>> Cc: Gábor Stefanik <netrolller.3d@gmail.com>
> >>> Cc: Johannes Berg <johannes@sipsolutions.net>
> >>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >>> ---
> >>>  drivers/net/wireless/Kconfig |   13 +++++++++++++
> >>>  1 files changed, 13 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> >>> index c2e88dc..150565d 100644
> >>> --- a/drivers/net/wireless/Kconfig
> >>> +++ b/drivers/net/wireless/Kconfig
> >>> @@ -561,8 +561,21 @@ source "drivers/net/wireless/iwmc3200wifi/Kconfig"
> >>>  endif # INTEL_80211
> >>>
> >>>  source "drivers/net/wireless/hostap/Kconfig"
> >>> +
> >>> +config BROADCOM_80211
> >>> +       bool "Broadcom"
> >>> +       depends on WLAN_80211
> >>> +       ---help---
> >>> +         This will enable the support for Broadcom wireless drivers. This
> >>> +         includes b43 driver, b43legacy driver and the rndis_wlan driver.
> >>
> >> NAK. Again, rndis_wlan is Microsoft, not Broadcom.
> >
> > Yes, the patch does not group rndis with broadcom, please re-read the patch.
> >
> >  Luis
> >
> 
> But it does say "This includes b43 driver, b43legacy driver and the
> rndis_wlan driver.", which is wrong.

Ah indeed. Thanks for the review.

  Luis
