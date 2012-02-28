Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2B1Omt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:42:49 -0500
Subject: Re: Occasional truncated scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F4CE4D6.6020108@raritan.com> (sfid-20120228_152950_864254_C21F9143)
References: <4F4CE4D6.6020108@raritan.com>
	 (sfid-20120228_152950_864254_C21F9143)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 15:42:46 +0100
Message-ID: <1330440166.3368.7.camel@jlt3.sipsolutions.net> (sfid-20120228_154253_156335_FE984F06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> After some playing with different wireless devices I discovered that 
> this is not limited to specific drivers so I digged a bit in the scan 
> code in net/wireless/scan.c and found the culprit: The scan result is 
> put together with the iwe_stream_* functions that place data into a 
> provided buffer if enough space is available in the buffer. Otherwise 
> the functions do just nothing. Before a BSS is added there is a check if 
> some minimum space is available but after the BSS has been added it is 
> not clear how many data actually has been placed into the buffer. So 
> especially (but not neccessarily only) the last BSS is prone to be 
> incomplete. I my case all the IEs were missing and this was persistent 
> over some time (the persitence behavior seems to differs between drivers 
> - probably depends on how the scanning is implemented).
> 
> Currently I implemented a heuristic that checks if some minimum space 
> (currently 256 bytes) is still free _after_ adding a BSS and otherwise 
> return -E2BIG so the user space can provide a larger buffer but this is 
> a crappy hack.
> 
> Can the code be changed in some way to more reliably detect if some data 
> did not fit into the buffer and report this to user space?

Unfortunately not. The maximum buffer size userspace can provide is
limited to 64k. In busy environments, this size can be exceeded. As a
result, if we do this, you can't get *any* scan results in such
environments. I believe the current code is almost the best we can do
for wireless extensions, but it may be possible to implement never
truncating a single BSS entry.

That said, there's a very simple fix for this. Since you're talking
about net/wireless/scan.c, you're obviously using a driver with cfg80211
support. Ditch wireless extensions completely and use nl80211 instead,
you'll be much happier overall as it has no such limitations and more
features.

johannes

