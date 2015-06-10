Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59976 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbFJTzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 15:55:24 -0400
Message-ID: <1433966120.3145.15.camel@sipsolutions.net> (sfid-20150610_215528_610530_236484E2)
Subject: Re: Allowing station to over-ride default VHT-oper element?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jun 2015 21:55:20 +0200
In-Reply-To: <5578901C.60502@candelatech.com> (sfid-20150610_212943_327894_FFEA768B)
References: <5578901C.60502@candelatech.com>
	 (sfid-20150610_212943_327894_FFEA768B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 12:29 -0700, Ben Greear wrote:

> First, is this even a valid thing to do, or does VHT imply
> that stations are always available to do 80Mhz?

According to the spec, a VHT STA must support 80 MHz:

802.11ac-2013, 22.1.1:

	A VHT STA shall support the following features:
		[...]
		- 20 MHz, 40 MHz, and 80 MHz channel widths

Consequently, there's no bit indicating whether or not 80 MHz bandwidth
is supported (like there is, for VHT, indicating 40 MHz is supported or
not.)

Also it is invalid to advertise a VHT capabilities IE and an HT
capabilities IE without 40 MHz.

johannes

