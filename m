Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:44178 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbXCZWpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 18:45:55 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HVxul-00005Q-K0
	for linux-wireless@vger.kernel.org; Mon, 26 Mar 2007 18:43:47 -0400
Subject: Re: RFC: radiotap discrepancy in Linux vs OpenBSD
From: Pavel Roskin <proski@gnu.org>
To: David Young <dyoung@pobox.com>
Cc: linux-wireless@vger.kernel.org,
	Scott Raynel <scottraynel@gmail.com>, radiotap@mail.ojctech.com
In-Reply-To: <20070326033729.GG31621@che.ojctech.com>
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
	 <20070326033729.GG31621@che.ojctech.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 18:45:49 -0400
Message-Id: <1174949149.28132.49.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-03-25 at 22:37 -0500, David Young wrote:

> > One is found in the current wireless-2.6.git:
> > 
> >         IEEE80211_RADIOTAP_RX_FLAGS = 14,
> >         IEEE80211_RADIOTAP_TX_FLAGS = 15,
> >         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
> >         IEEE80211_RADIOTAP_DATA_RETRIES = 17,
> 
> These fields are slated to become part of the standard, I just haven't got
> around to updating the manual page, yet.  I have time to do that tonight.

OK.  I was wrong to assume that non-standard fields were introduced on
the Linux side.

> > Another set of the flags can be found in CVS OpenBSD:
> > 
> >         IEEE80211_RADIOTAP_FCS = 14,
> >         IEEE80211_RADIOTAP_HWQUEUE = 15,
> >         IEEE80211_RADIOTAP_RSSI = 16,
> 
> These fields are not part of the standard, and they will not become part
> of the standard with these numbers.  This is the first time I have ever
> heard of HWQUEUE and RSSI, actually.  What are they for?

IEEE80211_RADIOTAP_HWQUEUE specifies the hardware queue.  This is used
in the drivers for Atheros and Intel ipw3945 to report transmitted
frames to the userspace.

In case of Atheros, the value would always be 0, but the way it's
written (HAL_TX_QUEUE_ID_DATA_MIN), I assume the value is supposed to be
hardware specific rather than a number from the 802.11e standard.  Other
values in the same enum are 6, 7, 8 and 9.

In case of the ipw3945 driver, it's always 0, but it's used as an index
in an array of size 4, so at least it a number from 0 to 3.

The description in ieee80211_radiotap.h is: "A specific hardware queue
(used by WME)" and it's one 8-bit integer.

IEEE80211_RADIOTAP_HWQUEUE is described as "A relative Received Signal
Strength Index" and it's two 8-bit integers, RSSI and max RSSI.  It's
used by many drivers and includes uncalibrated signal data.  It looks
like noise data is not included.

-- 
Regards,
Pavel Roskin

