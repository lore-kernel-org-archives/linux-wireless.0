Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55073 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbZHUObG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:31:06 -0400
Received: by fxm17 with SMTP id 17so497615fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 07:31:06 -0700 (PDT)
Message-ID: <4A8EAFA6.9010608@gmail.com>
Date: Fri, 21 Aug 2009 16:31:02 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Richard Farina <sidhayn@gmail.com>,
	Mike Kershaw <dragorn@kismetwireless.net>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <"damien bergamini"@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>,
	Dave Young <hidave.darkstar@gmail.com>
CC: radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
Subject: Plans for an online meeting regarding Radiotap
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radiotap is a de-facto standard for 802.11 frame injection and reception.
Up to field ID 13, it can truly considered a standard (all current 
implementations
agree on fields 1-13), but after that, implementations diverge widely.

Here is a map of how current implementations define field IDs 14 and up:

Linux (both mac80211 & madwifi, not sure about libertas) & NetBSD:
Field 14: RX flags (standardized field)
Field 15: TX flags
Field 16: RTS retries
Field 17: Data retries

FreeBSD:
Fields 14...17 skipped (incliding standardized field 14), field 18: 
Extended channel

OpenBSD:
Field 14: FCS of the frame (clashes with standard - field 14 is defined 
as RX flags!)
Field 15: Hardware queue
Field 16: RSSI

DragonFly BSD: No fields above 13 implemented.

Aircrack-ng:
Field 14: RX flags (as in the standard)
Field 15: TX flags

CACE AirPcap software:
Field 14: FCS of the frame (clashes with standard; the FCS is also appended
to the end of the packet, so this usage is unneeded)

Wireshark:
Field 14: RX flags, with option to decode FCS instead
Fields 15...17 skipped
Field 18: Extended channel

Radiotap fields 14 and up need to be sorted out to allow further 
advancements
of the standard. In the current state, essentially no fields can be 
added without
risking a collision between implementations. To remedy this, I would 
like to propose
an online mini-summit to be held on Freenode, with the goal of defining 
a standard
way to use fields 14 and up.
The summit is to be held in IRC channel #radiotap, where interested 
parties can join
the discussion and propose changes. My preferred time for this event is
August 25, 2009, 18:00 GMT; please let me know if this date is 
unsuitable for any of
you, and I will try to find a better time for the summit when everyone 
interested can attend.

My current proposal for the future standard field ordering beyond field 14:

Field 14: RX flags (as defined by the standard)
Field 15: TX flags (as used by Linux, NetBSD and aircrack-ng)
Field 16: RTS retry count (as used by Linux and NetBSD)
Field 17: Data retry count (as used by Linux and NetBSD)
Field 18: Extended channel (as used by FreeBSD and Wireshark)
Field 19: RSSI (OpenBSD's field 16 moved to field ID 19 to avoid collisions)

In addition, the following new fields may be worth addition to the standard:
RTS threshold, Fragmentation threshold, Extended rate (with MCS index 
support).
I'm deliberately not assigning field numbers to these proposed fields 
yet to prevent
early, divergent implementations of them; the field IDs for these should 
be decided
during the summit.

I'm for dropping the following fields, please let me know during the summit
if there are any use cases for them:
-FCS of the frame (if we have FCS data, then it should be appended to the
end of the frame, not put into the header)
-Hardware queue (I don't see the point of this... maybe a full QoS 
control field
would be needed instead)

Hope to see you on Freenode at the set date. Again, if the time is a 
problem,
respond, and I will try to find a better time.

Sincerely,
Gábor Stefanik <netrolller.3d@gmail.com>

