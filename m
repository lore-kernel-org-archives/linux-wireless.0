Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37867 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZDAD05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 23:26:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 20:26:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18898.56829.104723.601609@gargle.gargle.HOWL> (sfid-20090401_052705_213793_F6E53B26)
Date: Wed, 1 Apr 2009 08:52:37 +0530
To: Kalle Valo <kalle.valo@iki.fi>
CC: Vivek Natarajan <vivek.natraj@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 11/17] ath9k: Remove TIM from the interrupt mask
In-Reply-To: <87eiwdsxlz.fsf@litku.valot.fi>
References: <18896.38867.997551.983464@gargle.gargle.HOWL>
	<8763hqnccb.fsf@litku.valot.fi>
	<8e92b4100903302322t531f5badt84fab14eeab943ff@mail.gmail.com>
	<87eiwdsxlz.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Vivek Natarajan <vivek.natraj@gmail.com> writes:
> 
> >> This might be useful for beacon filtering. Does the hardware know to
> >> parse the beacons in more detail, for example ERP protection or WMM
> >> settings?
> >
> > After a quick glance into the datasheet, I understand that the
> > current version of hardware supports reading TIM, TSF and some more
> > bits related to DTIM from a beacon.
> 
> Is the datasheet available somewhere?

Sorry, the datasheets are not available outside. :)

> > As far as this patch is concerned, since ath9k can use mac80211 for
> > sending a null data frame, it is quite redundant to enable the TIM
> > interrupt as it can be parsed in mac80211 itself.
> 
> Sure. But I was thinking the possibility of having beacon filtering in
> ath9k and then mac80211 wouldn't receive the beacons.

Atheros HW can't currently support beacon filtering, so there is no
need to handle TIM interrupt anyway.

Sujith
