Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40852 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0G0PzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 11:55:04 -0400
Received: by pvc7 with SMTP id 7so506705pvc.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 08:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280226169.19098.12.camel@jlt3.sipsolutions.net>
References: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
	<AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
	<AANLkTinch-sygnRmB6LKi6xLNYVKY6Ap3YL4_PMNdmKQ@mail.gmail.com>
	<AANLkTik=1LX_12ZskP5vwkSrTVFO9jH6uu8pyByGmLg6@mail.gmail.com>
	<1280226169.19098.12.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 08:54:44 -0700
Message-ID: <AANLkTi=ZbskS-7TA8Mp5SKrRMrxOpNQJLpxnCHoRs-tb@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix sw scan bracketing
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 3:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-07-27 at 02:22 -0700, Luis R. Rodriguez wrote:
>
>> > Yeap, reverting this patch alone today on wireless-testing makes me
>> > ath9k happy once again.
>>
>> So after some though and review in order to fix this we need a little
>> more time and thought. The above patch changes the order in which we
>> configure hardware upon a scan complete. It used to be we would
>> configure the hardware, configure the filter and then scan complete.
>> By then we'd be on the home channel and the filters would be set
>> correctly. ath9k's scan complete routine does a few things which
>> depend on the channel and will make hardware poo otherwise or do
>> stupid things:
>>
>>   * start TX poll routine, due to the new latency introduced to
>> configure hardware and configure the RX filter the TX polll routine
>> now has some extra work done by hardware before it actually starts
>> TXing. I don't suspect this could introduce a huge regression but it
>> is worth noting.
>
> I don't even understand why this is stopped during scan?

Good question, perhaps some scans take too long and you don't TX at
all on some set of passive channels? Its the only thing I can think
of.

>>   * ANI gets started, and the wrong channel is used if we're not yet
>> on the home channel. A simple patch to test if this may be causing the
>> disconnect issue I am seeing I just tried was to increase the delay
>> before starting ANI, this did indeed help.
>
> This really should be done when the channel is configured after scan
> anyway.

Indeed, I really prefer to do so on a new development kernel series,
think its too late in the series now.

>>   * ath_beacon_config() which I suspect means that if we now scan in
>> AP mode/IBSS mode we could potentially be leaking beacons on the last
>> channel of a scan, prior to sending them on the actual desired home
>> channel.
>
> This should be done by the driver based on mac80211's indication of
> whether it should be beaconing or not, not based on the scan callbacks.

Yeah, this is odd, I'll check with our team to see how we came up with
this here.

> I'm starting to think that it was a mistake to add these callbacks to
> start with ...

Could be.

>> To address and review all this I need more time and instead I think
>> its easier to ask for revert of this patch.
>
> I'm OK with a revert, but *ONLY* if at the same time you remove the
> double-scan-detected message from ath9k and stop claiming it's a
> mac80211 bug :-)

Deal :)

  Luis
