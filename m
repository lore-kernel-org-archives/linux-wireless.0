Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:38651 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZBVGpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 01:45:55 -0500
Received: by bwz5 with SMTP id 5so3830154bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 22:45:53 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Cc: "Alina Friedrichsen" <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: Give it some time to do the TSF sync
References: <20090221215202.227310@gmx.net> <200902212302.15056.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Feb 2009 08:45:51 +0200
In-Reply-To: <200902212302.15056.mb@bu3sch.de> (Michael Buesch's message of "Sat\, 21 Feb 2009 23\:02\:14 +0100")
Message-ID: <87y6vz2cm8.fsf@litku.valot.fi> (sfid-20090222_074646_186130_1E6E0410)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Saturday 21 February 2009 22:52:02 Alina Friedrichsen wrote:
>> Give slow hardware some time to do the TSF sync, to not run into an IBSS merging endless loop in some rarely situations. 
>
> It would be great to put this into a source code comment. Without
> this knowledge one immediately gets a WTF-lookalike face when seeing
> this code.

I fully agree.

>> -	if (beacon_timestamp > rx_timestamp) {
>> +	if (beacon_timestamp > rx_timestamp && rx_timestamp > 0x400000) {

And no magic numbers, please. Create a define for that.

-- 
Kalle Valo
