Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:57378 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0CBVx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 16:53:27 -0500
Date: Wed, 3 Mar 2010 10:55:26 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
In-Reply-To: <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003031006390.10063@kauri>
References: <4B8C3A21.2050105@openwrt.org>  <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>  <4B8D25DC.8070502@openwrt.org> <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-716154148-1267565278=:10063"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-716154148-1267565278=:10063
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1003031029321.10063@kauri>

On Tue, 2 Mar 2010, Björn Smedman wrote:
(lots deleted)
>
> The reason I'm so interested in this subject is I've tried to tweak
> the ath9k rate control to behave reasonably for me. This has taken a
> lot of time and the result is rather poor. Also, these tweaks are not
> general enough to even be contributed back as patches. My feeling is
> that the reason it is so difficult to get a rate control algorithm to
> work for all use-cases is that the underlying model is just plain
> wrong. Radio environments are very varied and complex. Add to that all
> the other variability, such as ANI dynamically adjusting radio chain
> parameters and it's very very difficult to know what is "incorrect but
> good enough".

Some years ago, my colleagues and I set out to write a rate control 
algorithm for madwifi. At that time, the existing rate control algorithms 
were best described as "junk". Manual adjustment of the rates at either 
end of a link would often double the throughput.
--After some thought - we realised that the rate control algorithm had to 
use good data, and make the correct decision on the data.
And so an EWMA based approach was devised which only looked at the success 
probability of packets to determine which rate to use in the future.
In other words, "select a rate that we know works, and have recently 
tested and verified to work".

This approach worked. When the hardware/driver selected a bad ani setting,
manual adjustment of the rate, or using the ewma based approach -
the throughput was the same (as good as can be achieved).

Even when there were issues in the firmware (ramping, or transmission 
delay) manual adjustment of the rate, or using the ewma based approach -
the throughput was the same (as good as can be achieved).

And the rate control algorithm that we wrote was called minstrel.
Felix has taken this on and done wonders to get it to mac80211 and 
accepted as the default rate algorithm.
==================

if you look on linux wireless,
http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211_rate_control_algorithms
and read up on rate control algorithms you will find docs for PID and 
minstrel.

Where are the docs for the ath9k rate control algorithm?

PID got it wrong - implicit in PID is the assumption that the rates can be 
ordered in terms of more successful / less successful - and the ordering 
follows the speed (faster speed=less successful).

Since very slow rates are subject to interference loss (imagine there is a 
60hz transmitter out there) packets that take a long time to transmit are 
far more likely to be shot down, stepping down a rate is going to increase 
the loss rate.

*Going on messages like:
   http://osdir.com/ml/linux-wireless/2009-11/msg00952.html
*the absence of any docs,
*reliance on RSSI (which is a misleading figure)
I would say your efforts in working on the ath9k rate algorithm were 
doomed to failure.

=================================================

> My feeling is that the reason it is so difficult to get a rate control 
> algorithm to work for all use-cases is that the underlying model is just 
> plain wrong.
yes. minstrel has a very very good model, and works very very well. 
Minstrel's model needs to be used in ath9k - and so the work of Felix to 
port Minstrel is valuable and appreciated.

> Radio environments are very varied and complex.
Yes, radio environments are varied and complex. If you have a good model 
for the rate control algorithm, your rate control algorithm will work well.

> Add to that all the other variability, such as ANI dynamically adjusting 
> radio chain parameters and it's very very difficult to know what is 
> "incorrect but good enough".
The best measure of a rate control algorithm was hinted at above. I will 
state it clearly here:
Take 2 nodes.
use your rate control algorithm on the 2 nodes.
a)measure the throughput between them.
Change to using manually adjust fixed rate.
b)Manually adjust the tx rate of either node until you achieve the best
   throughput.
Compare the throughput from a) and b)

If ANI (or whatever else you can think of) is reducing throughput, the 
above simple test should still give the same result. The throughput for a) 
and b) should still be the same.

Derek.
  -- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"The only thing IE should be used for is to download Fire Fox"

"My favorite language is call STAR. It's extremely concise. It has
  exactly one verb '*', which does exactly what I want at the moment."
     --Larry Wall
--0-716154148-1267565278=:10063--
