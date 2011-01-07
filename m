Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:51985 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751711Ab1AGXnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:43:01 -0500
Message-ID: <20110107234259.20758.qmail@stuge.se>
Date: Sat, 8 Jan 2011 00:42:59 +0100
From: Peter Stuge <peter@stuge.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k tx lockup, ath: received PCI FATAL
	interrupt
References: <20110107215549.4053.qmail@stuge.se> <1294441714.12213.75.camel@jm-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294441714.12213.75.camel@jm-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> > Only ath9k (ie. neither ipw2200 nor ath5k) has ever made a
> > difference between wpa_supplicant running or not.
> 
> You won't need wpa_supplicant for an open network that has only a
> single AP and if you never get disconnected (which could happen,
> e.g., if you leave the range for a moment).

Thanks for confirming this!


> mac80211 will not be reconnecting to the network on its own
> automatically, so you need something like wpa_supplicant to do it
> for you.

Right, I had understood that to also be the case. I may not agree but
in any case that's a different topic.

However, since neither laptop nor AP is moving around much I also do
not expect to get disconnected. Let's see how life with master-2011-01-05
turns out!


> > 1. ath: received PCI FATAL interrupt
> > 
> > How can I find out more about the reason for this?
> 
> Have you looked at enabling debugging in ath9k?

Yes, and I dug around adding some code last year when I first got
started with ath9k. Unfortunately I forgot to pass debug when
loading the driver today.


> For the PCI fatal interrupt, it would be useful to have at least
> interrupt and fatal levels included.

Hold on.. OK, reloaded now with debug=0x410.


> If the output is still readable (i.e., you can still find the PCI
> fatal message), enabling more of these could end up providing more
> details, too.

ATH_DBG_INTERRUPT is spamming the kernel log with a disable/enable
IER at least every 100ms but usually much more often. A snippet:

[10654.729417] ath: disable IER
[10654.729430] ath: AR_IMR 0x918414b0 IER 0x1
[10654.729452] ath: enable IER
[10654.729462] ath: AR_IMR 0x918414b0 IER 0x1
[10654.729581] ath: disable IER
[10654.729601] ath: enable IER
[10654.729619] ath: disable IER
[10654.729633] ath: AR_IMR 0x918414b0 IER 0x1
[10654.729665] ath: enable IER
[10654.729676] ath: AR_IMR 0x918414b0 IER 0x1
[10654.729729] ath: disable IER
[10654.729749] ath: enable IER
[10654.729760] ath: AR_IMR 0x918414b0 IER 0x1
[10654.735625] ath: disable IER
[10654.735662] ath: enable IER
[10654.735674] ath: AR_IMR 0x918414b0 IER 0x1
[10654.829084] ath: disable IER
[10654.829103] ath: enable IER
[10654.829115] ath: AR_IMR 0x918414b0 IER 0x1
[10654.829176] ath: disable IER
[10654.829203] ath: enable IER
[10654.829214] ath: AR_IMR 0x918414b0 IER 0x1
[10654.829237] ath: 0xf4041171 => 0xf4041171
[10654.829244] ath: new IMR 0x918414b0
[10654.829252] ath: enable IER
[10654.829263] ath: AR_IMR 0x918414b0 IER 0x1
[10654.837973] ath: disable IER
[10654.838010] ath: enable IER
[10654.838021] ath: AR_IMR 0x918414b0 IER 0x1
[10654.940330] ath: disable IER
[10654.940374] ath: enable IER
[10654.940386] ath: AR_IMR 0x918414b0 IER 0x1
[10655.042682] ath: disable IER
[10655.042724] ath: enable IER
[10655.042737] ath: AR_IMR 0x918414b0 IER 0x1

So now my dmesg is only some 6000 lines of this, going back 30
seconds or so. Would it make sense to bump the kernel log size
significantly to have maybe several minutes?


> Have you happened to test that WLAN card in any other system or
> with any other driver?

No.


> It could be useful to make sure it is known to be working reliably
> before spending huge amount of work trying to figure out why it
> doesn't work properly with ath9k..

True. The card was brand new in ESD bag when I installed it. It comes
out of a batch of cards that ship as part of a commercial product
running in AP mode with good performance.

Your point is solid, but I have no easy way to test something else.

Would FreeBSD be a useful data point, or is some Windows the only
reliable reference in this case?


> > 2. Unworking association without wpa_supplicant after power cycle
> > 
> > How can I find out more about the reason for this?
> 
> The part where the dmesg output had "direct probe to <BSSID> timed out"
> could potentially be caused by card RX not working properly.

Hm? This message is in log2_after_wpa_supplicant_4x_trying_to_auth.txt
which is dmesg following the PCI FATAL interrupt and then running
wpa_supplicant, but before the power cycle. The issue above is rather
what can be seen in log4..log5, and going away in log6..log7 when I
try iw connect again *with* wpa_supplicant running.


> I've seen that happen in some cases (with rmmod + modprobe ath9k
> being one way of recovering from that state). Looking at the RX
> interrupt counters in ath9k debugfs and checking whether they
> increment could be of use here. In general, verifying RX registers
> (filter, descriptors) would likely follow in getting more details.

Thanks for the pointers! When I first had problems about a year ago I
did look at and post (only to ath9k-devel) interrupt counter values,
but no obvious problem showed. (Rather, there were no comments.)

I'll remember to also instrument debugfs if/when next problem hits.


//Peter
