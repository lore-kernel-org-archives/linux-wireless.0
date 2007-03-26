Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from che.ojctech.com ([64.198.255.2]:44547 "EHLO che.ojctech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbXCZE1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 00:27:08 -0400
Date: Sun, 25 Mar 2007 22:37:29 -0500
From: David Young <dyoung@pobox.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	Scott Raynel <scottraynel@gmail.com>
Subject: Re: RFC: radiotap discrepancy in Linux vs OpenBSD
Message-ID: <20070326033729.GG31621@che.ojctech.com>
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 25, 2007 at 11:24:16PM -0400, Pavel Roskin wrote:
> Hello!

The place to discuss this is the mailing list
radiotap@ojctech.com, which I have cc'd.  Subscribe at
<http://mail.ojctech.com/mailman/listinfo/radiotap>.  Please feel free
to circulate the URL.

> I have noticed two different incompatible changes to enum
> ieee80211_radiotap_type in ieee80211_radiotap.h.
> 
> One is found in the current wireless-2.6.git:
> 
>         IEEE80211_RADIOTAP_RX_FLAGS = 14,
>         IEEE80211_RADIOTAP_TX_FLAGS = 15,
>         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
>         IEEE80211_RADIOTAP_DATA_RETRIES = 17,

These fields are slated to become part of the standard, I just haven't got
around to updating the manual page, yet.  I have time to do that tonight.

> It was added together with Marvell Libertas USB driver.

> Another set of the flags can be found in CVS OpenBSD:
> 
>         IEEE80211_RADIOTAP_FCS = 14,
>         IEEE80211_RADIOTAP_HWQUEUE = 15,
>         IEEE80211_RADIOTAP_RSSI = 16,

These fields are not part of the standard, and they will not become part
of the standard with these numbers.  This is the first time I have ever
heard of HWQUEUE and RSSI, actually.  What are they for?

> I think Marvell developers could act gracefully and push the flags it introduces
> to higher numbers.  Doing something like that on the OpenBSD side would be
> harder.  I would also like to see joining Rx and Tx flags into one 32-bit
> value.

> But we need some coordination when new fields are added to the protocol.

Right.  People must coordinate on the radiotap list.

> Uncalibrated RSSI may also be a candidate for
> the driver-specific data if OpenBSD can be persuaded to abandon its present
> number.

OpenBSD will need to abandon its present numbers in order to stay
compatible with tcpdump and wireshark.

> It's important that presence of driver specific fields doesn't break parsing of
> the standard fields, even if new fields are made standard.  I think driver
> specific flags don't belong to the it_present bitmap, but should go to the
> beginning of the driver specific area.

You are right that the driver-specific fields cannot go in the bitmap.

Dave

-- 
David Young             OJC Technologies
dyoung@ojctech.com      Urbana, IL * (217) 278-3933
