Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:60634 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYBDFxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 00:53:13 -0500
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: cfg80211 API changes
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
	<1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>
	<1202049444.4188.125.camel@johannes.berg>
	<1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 04 Feb 2008 07:52:44 +0200
In-Reply-To: <1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com> (ext Tomas Winkler's message of "Sun\, 3 Feb 2008 16\:51\:27 +0200")
Message-ID: <87ve55b74j.fsf@nokia.com> (sfid-20080204_055316_931325_EB4A85F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>> TBH, that confused me completely since the rate scale algorithm tells
>> the hardware what rate to use so why does the hw need to assign a
>> different rate in the tx status?
>
> I see.  Rate scale algorithm only tels FW from what rate to start
> transmission. FW is responsible to do downscaling.  Which is quite
> reasonable as retransmission is real time process. Instead of
> retransmitting on the same rate FW downscales. T X response provides
> to the rate scaling algorithm the successful rate.

I just want to point out this is an important feature when the bus is
very slow, for example SPI bus in embedded devices. Retransfering
frames through SPI for every rate restransmit would make such a device
extremely slow.

-- 
Kalle Valo
