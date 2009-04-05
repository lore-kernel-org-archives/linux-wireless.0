Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39362 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbZDEKNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 06:13:18 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Sujith <Sujith.Manoharan@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904051129.38904.mb@bu3sch.de>
	<1238925174.4120.12.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 05 Apr 2009 13:13:12 +0300
In-Reply-To: <1238925174.4120.12.camel@localhost.localdomain> (Jaswinder Singh Rajput's message of "Sun\, 05 Apr 2009 15\:22\:54 +0530")
Message-ID: <87bprbif2f.fsf@litku.valot.fi> (sfid-20090405_121335_539196_E0512EEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

>> And besides that, I think one can easily remotely trigger this
>> message and flood the logs. So it should probably _also_ be
>> ratelimited.
>
> normally it prints after 120 seconds:
>
> [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request

Then there is something happening in ath9k or your AP which prevents
ath9k from receiving beacons. Try pinging your AP with 100 ms
interval. Do you see anything happening in 120 s intervals?

If ath9k can't receive beacons in a 120 s interval, I would expect to
see delays also in the data path at the same time.

-- 
Kalle Valo
