Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38665 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZBUUEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 15:04:10 -0500
Message-ID: <49A05E35.70904@lwfinger.net> (sfid-20090221_210415_626126_E0B83DC5)
Date: Sat, 21 Feb 2009 14:04:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
References: <49A01922.1090106@lwfinger.net> <1235241867.3284.44.camel@localhost>
In-Reply-To: <1235241867.3284.44.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sat, 2009-02-21 at 09:09 -0600, Larry Finger wrote:
>> I admit that I didn't follow the discussion of reporting signal quality very
>> closely; however since commit 708c57cf1709fb95, all of my wireless devices (b43,
>> p54usb, rtl8187) are reporting link quality as XX/70 rather than XX/100. I doubt
>> that this was an intended consequence of that patch. If the SIOCGIWRANGE ioctl
>> is now more correct, what changes are needed in the drivers to restore the old
>> behavior? Having written the qual calculation for 2 drivers, I understand the
>> uselessness of this number, but I also know the uproar such a change will cause
>> in the user community.
> 
> Intended.  It doesn't matter what the /X number is; it's simply the
> upper bound of what the # before the / will be.  Quality is in the range
> of [0 ... max_qual.qual].  You should be able to divide quality /
> max_qual.qual and get a reasonable number to use for pretty UI display.
> 
> Many drivers used to use something other than 100 for max quality, and
> many still do:
> 
> airo.c:		range->max_qual.qual = airo_get_max_quality(&cap_rid);
> hostap/hostap_ioctl.c:		range->max_qual.qual = 70; /* what is correct max? This was not
> hostap/hostap_ioctl.c:		range->max_qual.qual = 92; /* 0 .. 92 */
> netwave_cs.c:	range->max_qual.qual = 255;
> orinoco/wext.c:		range->max_qual.qual = 0x8b - 0x2f;
> wavelan.c:	range->max_qual.qual = MMR_SGNL_QUAL;
> wavelan_cs.c:	range->max_qual.qual = MMR_SGNL_QUAL;
> zd1201.c:	range->max_qual.qual = 128;

I know how it works with drivers that implement their own ioctl calls for the
WEXT interface; however, the 3 that I mentioned all use mac80211 and get their
WEXT support through cfg80211.

Larry
