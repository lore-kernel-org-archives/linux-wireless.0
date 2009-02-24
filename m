Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:39574 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZBXSg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:36:27 -0500
Received: by fxm11 with SMTP id 11so3034930fxm.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 10:36:24 -0800 (PST)
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163738.20939.25890.stgit@tikku>
	<1235442058.4455.71.camel@johannes.local>
	<20090224090137.GB10851@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 20:36:03 +0200
In-Reply-To: <20090224090137.GB10851@jm.kir.nu> (Jouni Malinen's message of "Tue\, 24 Feb 2009 11\:01\:37 +0200")
Message-ID: <87k57fy964.fsf@litku.valot.fi> (sfid-20090224_193631_044113_56003DA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Mon, Feb 23, 2009 at 06:20:58PM -0800, Johannes Berg wrote:
>
>> We used to go through a probe request cycle once to make sure, but I'm
>> not sure there's a point in that. Just pointing out the change here.
>
> Having seen some hardware implementations of Beacon miss getting out of
> sync with the AP timing and causing way too frequent disconnections, I
> would think that there may well be good reasons to check in software
> that report was indeed correct, e.g., by sending the probe request
> before giving up on the AP.

I see your point, I also have had to suffer because of buggy APs
having unstable TBTT. But the cost for this is high, currently it
increases two seconds the time to signal a lost connection to the user
space. I would hope to have something faster.

>> The code looks pretty good, but this will lead to an interesting
>> situation where "iwlist wlan1 scan last" ("iw dev wlan1 scan dump") will
>> not show _any_ BSS, which will probably trip up NM; this happens because
>> the BSS will not be updated and expire after 10 seconds. I think we need
>> a way to "hold on" to the BSS.
>
> Dropping the BSS is not good.. The scan results should always include
> the current BSS so that information from it is available for things like
> 4-way handshake (WPA/RSN IE is needed from Beacon/ProbeResp).

Understood. Thanks for bringing this up.

-- 
Kalle Valo
