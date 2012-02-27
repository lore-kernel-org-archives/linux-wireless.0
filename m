Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44446 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2B0P3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:29:46 -0500
Received: by wgbdr13 with SMTP id dr13so1796714wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:29:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4X-8x=V6WZstAwM8GyicN_ds8WHv8uYz4zF8d-KdNTsg@mail.gmail.com>
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
	<CAA93jw4X-8x=V6WZstAwM8GyicN_ds8WHv8uYz4zF8d-KdNTsg@mail.gmail.com>
Date: Mon, 27 Feb 2012 16:29:43 +0100
Message-ID: <CAA93jw7Quvaj=9jbXVPXO9fk1S50DBHbCSWk91WVEZaVU0MRwA@mail.gmail.com> (sfid-20120227_162950_069024_48E58FFE)
Subject: Re: mac80211 queue handling in multi-channel
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a plot of applying queue management on top of the existing
queue structure, only one queue active, against 50 saturating streams
against a voip-like ping.

http://www.teklibre.com/~d/bloat/ping_log.ps

To explain it the first part of the plot is the start of the test,
the second part is after a brief, small rate change downwards, the
drop to 0 is the end of the first test, then it goes back and starts
another.

While the clustering at the ~60-90ms line is good and due to sfqred
doing it's job, it's connected to and unable to control the large,
floppy rubber hose of buffering beneath it, translating out to ~100ms
of jitter on more normal spiky loads under good conditions and worse
on bad.

A flaw of this particular plot is it measures intrinsic buffering on
both sides of the connection, but it's still a lot of intrinsic
latency. It would be nice to be able to apply BQL or BQL-like
techniques to this, because that white space underneath the plot gets
much more latent at lower rates.

On Mon, Feb 27, 2012 at 4:10 PM, Dave Taht <dave.taht@gmail.com> wrote:
> On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>
>> As a consequence, I'm thinking that we should redesign the mac80211 /
>> driver queue API to mirror more closely the kind of queues hardware
>> really has.
>
> I'd like the driver queues to mirror more closely the kinds of
> connections the hardware really has. I realize that this is more of an
> AP orientation than a wireless client orientation, but with wildly
> different rates between connected devices bad things happen.
>
> Secondly, my take on 802.11e QoS and wireless-n aggregation is that
> aggregation wins nearly every time; all
> 802.11e does is bloat up the buffers.
>
>> To recap: today, almost all drivers expose four queues to mac80211 for
>> the four ACs. In reality, many have many more queues, e.g. in iwlwifi:
>>  * 4 for the first vif
>>  * 4 for the second vif
>>  * 1 for CAB (content after [DTIM] beacon)
>>  * 1 for off-channel
>>
>> They are mapped as follows:
>>  * all vif ACs -> 4 ACs
>>  * off-channel -> BE
>>  * CAB         -> BE (I believe, maybe all?)
>>
>> Thus when e.g. in our driver the BE queue for the second VIF is full, we
>> stop all traffic across all VIFs. When both VIFs are on the same
>> channel, this isn't really a problem. However, when they are on
>> different channels, there could be vastly different performance
>> characteristics on those two channels due to interference etc.
>
> And even more differences based on the destination's characteristics.
>
>
>
>
> --
> Dave Täht
> SKYPE: davetaht
> US Tel: 1-239-829-5608
> http://www.bufferbloat.net



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://www.bufferbloat.net
