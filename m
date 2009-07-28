Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx76.mail.ru ([94.100.176.91]:49177 "EHLO mx76.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZG1OSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 10:18:00 -0400
Subject: Re: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248787142.8113.10.camel@johannes.local>
References: <1248784603.29068.44.camel@sunlight>
	 <1248787142.8113.10.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 18:17:58 +0400
Message-Id: <1248790678.29068.94.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hmm. Passing up *all* control frames wouldn't really be good -- think of
> all the ACK frames. Do you have filters per frame type?
> 
> Maybe we should introduce a FIF_PSPOLL flag?
> 
> johannes

As I see from the rt2x00 source code, older Ralink devices have common
filter for all control frames. Newer devices (including rt73usb one) can
filter ACK/CTS and other control frames separately. And the rt2800
device has a separate filter for PS Poll frames.

I agree, we should filter out the ACK frames where it is possible.

And in case we introduce the FIF_PSPOLL flag, what the exact semantics
will it have? When the FIF_CONTROL flag is passed to a driver, but the
FIF_PSPOLL one isn't, should the driver filter out PS Poll frames (a) or
not (b)?

May be it would be better to take into account the FIF_PSPOLL flag when
the FIF_CONTROL one isn't passed only (choice b) to be compatible with
the current implementation? I.e. the device should receive PS Poll
frames if either FIF_CONTROL or FIF_PSPOLL is passed (or both of them,
of course).


