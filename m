Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:35566 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0LIOTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:19:52 -0500
Subject: Re: [PATCH 2/4] b43: set TMS to work with current band width for
 N-PHY
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTin14p=3=SA_4oVj24z+8NuS_y6hWqQmEEiXaSqr@mail.gmail.com> (sfid-20101209_151338_363925_536AF3B3)
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <1291755360-21570-3-git-send-email-zajec5@gmail.com>
	 <1291756117.27497.101.camel@maggie>
	 <AANLkTinN_12RwWiugzxn5dB1he3b6h_y7K3C=8vFPyXO@mail.gmail.com>
	 <AANLkTin14p=3=SA_4oVj24z+8NuS_y6hWqQmEEiXaSqr@mail.gmail.com>
	 (sfid-20101209_151338_363925_536AF3B3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 15:19:44 +0100
Message-ID: <1291904384.2905.2.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 15:13 +0100, Rafał Miłecki wrote: 
> W dniu 9 grudnia 2010 15:12 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > W dniu 7 grudnia 2010 22:08 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> >> On Tue, 2010-12-07 at 21:55 +0100, Rafał Miłecki wrote:
> >>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >>> ---
> >>>  drivers/net/wireless/b43/main.c       |    6 ++++++
> >>>  drivers/net/wireless/b43/phy_common.c |    7 +++++++
> >>>  drivers/net/wireless/b43/phy_common.h |    2 ++
> >>>  drivers/net/wireless/b43/phy_n.c      |    7 -------
> >>>  4 files changed, 15 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> >>> index fa48803..670fd7b 100644
> >>> --- a/drivers/net/wireless/b43/main.c
> >>> +++ b/drivers/net/wireless/b43/main.c
> >>> @@ -1150,6 +1150,12 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
> >>>
> >>>       flags |= B43_TMSLOW_PHYCLKEN;
> >>>       flags |= B43_TMSLOW_PHYRESET;
> >>> +     if (dev->phy.type == B43_PHYTYPE_N) {
> >>> +             if (b43_channel_type_is_40mhz(dev->phy.channel_type))
> >>
> >> Is channel_type already set at this time?
> >
> > Yeah, that core switching seems to be a little tricky. I didn't figure
> > it out completely yet. We may need to fix that, or fix calls to this
> > function.
> >
> > Thanks for reviewing!
> 
> In other words: it will work for now, but we need to fix that in
> future if we want to get 40 MHz channels working.

That's exactly what I was saying. ;)
To answer my original question: No, channel_type is not set, but the
code will work for non-40mhz.

This seems a bit tricky to fix, though. Maybe we should reset the
wireless core twice. Once initially and once again after the
configuration was set. The first reset would just be to be able
to access the PHY and wireless core at all to probe it.

-- 
Greetings Michael.

