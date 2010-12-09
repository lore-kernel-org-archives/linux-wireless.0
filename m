Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37968 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0LIOlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:41:50 -0500
Subject: Re: [PATCH 2/4] b43: set TMS to work with current band width for
 N-PHY
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTinJUsKzNO6vO8F9KupxF0uc1h97wffhAgBas1Pe@mail.gmail.com> (sfid-20101209_152344_283295_FFFFFFFFF86E6A27)
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <1291755360-21570-3-git-send-email-zajec5@gmail.com>
	 <1291756117.27497.101.camel@maggie>
	 <AANLkTinN_12RwWiugzxn5dB1he3b6h_y7K3C=8vFPyXO@mail.gmail.com>
	 <AANLkTin14p=3=SA_4oVj24z+8NuS_y6hWqQmEEiXaSqr@mail.gmail.com>
	 <1291904384.2905.2.camel@maggie>
	 <AANLkTinJUsKzNO6vO8F9KupxF0uc1h97wffhAgBas1Pe@mail.gmail.com>
	 (sfid-20101209_152344_283295_FFFFFFFFF86E6A27)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 15:41:44 +0100
Message-ID: <1291905704.2905.9.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 15:23 +0100, Rafał Miłecki wrote: 
> W dniu 9 grudnia 2010 15:19 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Thu, 2010-12-09 at 15:13 +0100, Rafał Miłecki wrote:
> >> W dniu 9 grudnia 2010 15:12 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> >> > W dniu 7 grudnia 2010 22:08 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> >> >> On Tue, 2010-12-07 at 21:55 +0100, Rafał Miłecki wrote:
> >> >>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >> >>> ---
> >> >>>  drivers/net/wireless/b43/main.c       |    6 ++++++
> >> >>>  drivers/net/wireless/b43/phy_common.c |    7 +++++++
> >> >>>  drivers/net/wireless/b43/phy_common.h |    2 ++
> >> >>>  drivers/net/wireless/b43/phy_n.c      |    7 -------
> >> >>>  4 files changed, 15 insertions(+), 7 deletions(-)
> >> >>>
> >> >>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> >> >>> index fa48803..670fd7b 100644
> >> >>> --- a/drivers/net/wireless/b43/main.c
> >> >>> +++ b/drivers/net/wireless/b43/main.c
> >> >>> @@ -1150,6 +1150,12 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
> >> >>>
> >> >>>       flags |= B43_TMSLOW_PHYCLKEN;
> >> >>>       flags |= B43_TMSLOW_PHYRESET;
> >> >>> +     if (dev->phy.type == B43_PHYTYPE_N) {
> >> >>> +             if (b43_channel_type_is_40mhz(dev->phy.channel_type))
> >> >>
> >> >> Is channel_type already set at this time?

The more I think about this, the wronger it looks to me.
Why do we care about the channel type at reset time anyway?
I guess the channel type is a parameter that can change any time on an
operating card. So just unconditionally set B43_TMSLOW_PHYCLKSPEED_80MHZ
at reset time and set the correct TMSLOW bits later when channel_type is
actually changed. That seems to be the only sane thing to do.
I guess we don't want to fully reset the device when channel_type
changes, do we?

-- 
Greetings Michael.

