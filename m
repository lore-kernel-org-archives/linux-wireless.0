Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14292 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZAaIkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 03:40:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 00:40:52 -0800
Date: Sat, 31 Jan 2009 14:10:45 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Bob Copeland <bcopeland@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Fix LED blink pattern
Message-ID: <20090131084044.GA5999@vasanth-laptop> (sfid-20090131_094103_238430_68A0B3E4)
References: <1233231739-4402-1-git-send-email-vasanth@atheros.com> <b6c5339f0901290717m760c4704x7f9df7502f772a17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0901290717m760c4704x7f9df7502f772a17@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 29, 2009 at 08:47:04PM +0530, Bob Copeland wrote:
> > +       struct delayed_work ath_led_blink_work;
> > +       int led_on_duration;
> > +       int led_off_duration;
> > +       int led_on_cnt;
> > +       int led_off_cnt;
> 
> This is something that has come up from time to time from users for
> ath5k as well.  Half of the drivers now have their own timers for
> turning leds on or off.
> 
> Can we just add a decent blink algorithm to mac80211?  Right now for
> rx it just toggles every other packet.  For tx, it's slightly smarter
> but not overly so.  It seems like this is one of those things everyone
> wants to do and we could easily make it a standard service.

ath9k maps all four led functionality (radio, assoc, rx and
tx) into a single LED, I think ath5k is also doing in the similar way.
But other drivers can map their led functionality differently in
their h/w where the pattern will differ. mac80211 is already signalling 
appropriate leds, imho it is up to the driver to define the pattern
based on the number of leds available/configured.
> 
> --
> Bob Copeland %% www.bobcopeland.com
