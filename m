Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46019 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbZLHQPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 11:15:06 -0500
Date: Tue, 8 Dec 2009 11:06:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	Shahar Or <mightyiampresence@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860
	LED
Message-ID: <20091208160659.GG15172@tuxdriver.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com> <20091204192315.GA5786@tuxdriver.com> <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com> <20091207215903.GC18939@tuxdriver.com> <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com> <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 08, 2009 at 08:01:52AM -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 8, 2009 at 6:57 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Mon, Dec 7, 2009 at 4:59 PM, John W. Linville <linville@tuxdriver.com> wrote:
> >> On Mon, Dec 07, 2009 at 12:05:54PM +0200, Shahar Or wrote:
> >>> Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.
> >>>
> >>> Signed-off-by: Shahar Or <shahar@shahar-or.co.il>
> >>> ---
> >>> I hope this one is perfect.
> >
> > Thanks for the patch.  As for getting a better solution to LEDs, I
> > trolled through the ACPI spec and code, and while various modules
> > do set up LED pins, there doesn't seem to be a way to generally
> > get that information from another module and it appears different
> > between each vendor.  I am by no stretch expert in ACPI stuff
> > though.
> >
> > Luis, I've asked this before but maybe you know better now or know
> > whom to ask on your side.  Atheros must have a way on Windows to
> > figure out the LED pin/polarity -- do you have any idea?  Ath9k
> > uses the SREV but that seems to be insufficient for ath5k judging
> > by all the quirks.
> 
> IIRC this is all mapped in the INF file, I thought I had released an
> INF file under the ISC license but it seems that's not the case, I can
> try to do that if it helps. Anyway, if we can move this sort of map to
> userspace it'd be neat as you'd just need a userspace file update.
> Only thing is how to do this in a generic way for all wireless drivers
> and if this is indeed useful for other drivers.

Export something through sysfs and use a udev rule?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
