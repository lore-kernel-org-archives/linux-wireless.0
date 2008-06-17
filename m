Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45629 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbYFQRxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 13:53:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Date: Tue, 17 Jun 2008 19:52:52 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <20080617154008.883383150@localhost> <1213721067.3803.73.camel@johannes.berg> <20080617174749.GB4974@jm.kir.nu>
In-Reply-To: <20080617174749.GB4974@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806171952.53183.mb@bu3sch.de> (sfid-20080617_195329_055217_9A973810)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 June 2008 19:47:49 Jouni Malinen wrote:
> On Tue, Jun 17, 2008 at 06:44:27PM +0200, Johannes Berg wrote:
> 
> > > crypto. It is unclear whether this can be used as-is with devices that
> > > use hwaccel for crypto at least before the low-level drivers and/or
> > > firmware have been modified to cope with the possibility of CCMP being
> > > used with management frames.
> > 
> > b43 will be able to do this for sure, it doesn't care what sort of frame
> > is encrypted. The question is how drivers can indicate
> > support/non-support I guess.
> 
> One of the problems is that CCMP as defined in IEEE 802.11i for data
> frames is not compatible with CCMP as defined in IEEE 802.11w for
> management frames (there are small differences in AAD and nonce
> generation). As such, if the hardware/firmware is trying to decrypt
> received CCMP protected frames based on the IEEE 802.11i rules even if
> the frame is a management frame, the end result is not going to be very
> good..

Well, as long as the checksum will fail in that case we're OK for b43,
as the driver will notify the need for software crypto for those packets.

-- 
Greetings Michael.
