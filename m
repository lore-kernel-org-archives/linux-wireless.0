Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48398 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbZBXHHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 02:07:12 -0500
Message-ID: <49A39C9C.7040002@lwfinger.net> (sfid-20090224_080716_250692_0C5ABCC3)
Date: Tue, 24 Feb 2009 01:07:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
References: <49A01922.1090106@lwfinger.net>	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>	 <8763j33rgq.fsf@litku.valot.fi>	 (sfid-20090222_074023_562332_D346678B) <1235441441.4455.58.camel@johannes.local>	 <49A37531.70907@lwfinger.net> <1235452576.4455.81.camel@johannes.local>
In-Reply-To: <1235452576.4455.81.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-02-23 at 22:18 -0600, Larry Finger wrote:
> 
>> No, I just wondered if it was intentional that it was changed to /70. It appears
>> that it was, therefore, at least 3 drivers must be changed as they are
>> calculating on the basis of /100. For example, my b43 is showing an iwconfig
>> Link Quality of 93/70 while the KNM applet is showing 50%.
> 
> Well that _is_ a bug, since this shouldn't have required driver changes!
> I'll take a look into why that might be happening.

Drivers b43, b43legacy, rtl8187, and p54usb all assume a Link Quality scaled to
100, which was the behavior before the commit in the subject. I don't quite
understand why as the old code had this fragment:

-       if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
-               /*
-                * cfg80211 assumes -110 to -40 dBm and clamps to that range
-                * for qual.qual, so tell userspace this is what we give it
-                * but take into account that we have to start from 0.
-                */
-               range->max_qual.qual = 70;
-               range->avg_qual.qual = 35;
-       } else {
-               /*
-                * cfg80211 just uses the level value for qual too, and it
-                * requires the level value to be 0 .. 100.
-                */
-               range->max_qual.qual = 100;
-               range->avg_qual.qual = 50;
-       }

That should have set max_qual.qual to 70 as all the drivers set
IEEE80211_HW_SIGNAL_DBM. I don't know why, but the code took the other branch,
which seems to have been some other bug.

Larry
