Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34451 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbZBXETJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 23:19:09 -0500
Message-ID: <49A37531.70907@lwfinger.net> (sfid-20090224_051913_506663_61CB7114)
Date: Mon, 23 Feb 2009 22:18:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
References: <49A01922.1090106@lwfinger.net>	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>	 <8763j33rgq.fsf@litku.valot.fi> (sfid-20090222_074023_562332_D346678B) <1235441441.4455.58.camel@johannes.local>
In-Reply-To: <1235441441.4455.58.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-02-22 at 08:39 +0200, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> I know how it works with drivers that implement their own ioctl
>>> calls for the WEXT interface; however, the 3 that I mentioned all
>>> use mac80211 and get their WEXT support through cfg80211.
>> Yes, something is wrong now. I noticed the same problem (/70 in signal
>> strength) when I was implementing rssi support for at76c50x-usb.
> 
> Ok, so what exactly is the problem here?
> 
> I intentionally changed it to be /70 rather than /100 so I didn't have
> to do *100/70 in kernel space, and tools should cope with that (and
> users too); is there a problem with how the XX (XX/70) gets calculated?

No, I just wondered if it was intentional that it was changed to /70. It appears
that it was, therefore, at least 3 drivers must be changed as they are
calculating on the basis of /100. For example, my b43 is showing an iwconfig
Link Quality of 93/70 while the KNM applet is showing 50%.

Larry
