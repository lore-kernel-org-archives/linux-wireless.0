Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56201 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZDFKX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 06:23:59 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<87bprbif2f.fsf@litku.valot.fi>
	<200904060914.32245.helmut.schaa@gmail.com>
	<200904061217.31134.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 06 Apr 2009 13:23:53 +0300
In-Reply-To: <200904061217.31134.mb@bu3sch.de> (Michael Buesch's message of "Mon\, 6 Apr 2009 12\:17\:30 +0200")
Message-ID: <87tz52xepy.fsf@litku.valot.fi> (sfid-20090406_122408_084300_A898C6A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

>> NetworkManager typically scans every 120 seconds and I can also trigger
>> the messages by a manual scan with iwlist. I did not dig any further but
>> the messages seem to appear right at the end of the scan. Tried with iwlagn
>> and both sw_scan and hw_scan.
>
> Yeah OK. While scanning it's expected to lose some frames.
>
> However, the driver should probably protect against this by using the
> scan notification callbacks. It could disable beacon-loss reporting
> while scanning.

That case is already covered. In sw_scan mac80211 will disable power
save and hence beacon filter is also disabled. With hw_scan the firmware
should be clever enough to not emit beacon loss events when scanning.

But ath9k nor iwlwifi don't support beacon filtering and this is a
problem in mac80211. We need to disable the beacon loss check in
mac80211, most probably by stopping the associated timer whenever
scanning.

-- 
Kalle Valo
