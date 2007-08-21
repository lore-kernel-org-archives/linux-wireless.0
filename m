Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:37785 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXHUDVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 23:21:11 -0400
Date: Mon, 20 Aug 2007 20:19:55 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/20] mac80211: remove unused ioctls (2)
Message-ID: <20070821031955.GO1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145044.386019000@sipsolutions.net> <20070818040725.GG1415@jm.kir.nu> <1187601208.6090.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187601208.6090.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2007 at 11:13:28AM +0200, Johannes Berg wrote:
> On Fri, 2007-08-17 at 21:07 -0700, Jouni Malinen wrote:
> 
> > Well, maybe so. But again, some are useful for testing (e.g., allow
> > broadcast always for continuous TX tests).
> 
> Again, a case for debugfs. I've already moved the WPA testing hooks
> there previous to this patch series.

Agreed as far as debugfs is concerned. However, I thought a bit more
about the test case where this used to be helpful and I think that the
test can be implemented differently, so I'm fine with the
send-group-when-no-associated-STAs option just go away.

> > Default WEP only is useful
> > for optimizing hwaccel in some multi-SSID cases, but it seemed to have
> > already been broken before..
> 
> Could have been me, could have been elsewhere, I don't know. However,
> it's also undocumented and there's no driver that actually cares. If we
> find hardware that requires it I'm all for optimising it, but until then
> I don't much see the point. Yes, it'll require some more effort for the
> author of that driver, but at least then we'll be sure that it works as
> advertised.

This is a very good example of something that should have been
documented since it would take me some thinking to remember what exactly
was the issue ;-). I just know that there was one with a common wlan
hardware design and the optimization was quite useful for some of the
configurations we were hitting. Without knowing how the WEP keys are
used, some of the optimizations were impossible to do in hwaccel and we
had to do most of decryption in software (not a very nice thing on an AP
with just barely fast enough CPU to handle open network at full transmit
rate)..

Then again, I think I'm actually fine with removing this now and see if
anyone complains.. If nothing else, that saves me having to figure out
now what the configuration was that forced me to add this extra
information.

-- 
Jouni Malinen                                            PGP id EFC895FA
