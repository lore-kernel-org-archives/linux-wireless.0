Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:49059 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932570AbXCZDYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 23:24:17 -0400
Message-ID: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
Date: Sun, 25 Mar 2007 23:24:16 -0400
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: David Young <dyoung@pobox.com>,
	Scott Raynel <scottraynel@gmail.com>
Subject: RFC: radiotap discrepancy in Linux vs OpenBSD
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have noticed two different incompatible changes to enum
ieee80211_radiotap_type in ieee80211_radiotap.h.

One is found in the current wireless-2.6.git:

        IEEE80211_RADIOTAP_RX_FLAGS = 14,
        IEEE80211_RADIOTAP_TX_FLAGS = 15,
        IEEE80211_RADIOTAP_RTS_RETRIES = 16,
        IEEE80211_RADIOTAP_DATA_RETRIES = 17,

It was added together with Marvell Libertas USB driver.

Another set of the flags can be found in CVS OpenBSD:

        IEEE80211_RADIOTAP_FCS = 14,
        IEEE80211_RADIOTAP_HWQUEUE = 15,
        IEEE80211_RADIOTAP_RSSI = 16,

Actually, there is a reference to IEEE80211_RADIOTAP_FCS in Linux, but only in a
comment.

IEEE80211_RADIOTAP_FCS is not used in any driver (apparently, it's better to
keep FCS in the end of the frame, not in the header), but the other two flags
are used in more than one driver.

I think Marvell developers could act gracefully and push the flags it introduces
to higher numbers.  Doing something like that on the OpenBSD side would be
harder.  I would also like to see joining Rx and Tx flags into one 32-bit
value.

But we need some coordination when new fields are added to the protocol.
Radiotap is better than other wireless capture headers because it's better
documented and more extensible.  But extending it in an uncontrolled way would
ruin the standard.

We could consider introducing driver specific area in the header.  For instance,
Atheros chips may allow the userspace to specify a set of rates at which the
transmission will be attempted.  Uncalibrated RSSI may also be a candidate for
the driver-specific data if OpenBSD can be persuaded to abandon its present
number.

It's important that presence of driver specific fields doesn't break parsing of
the standard fields, even if new fields are made standard.  I think driver
specific flags don't belong to the it_present bitmap, but should go to the
beginning of the driver specific area.

--
Regards,
Pavel Roskin
