Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:55334 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754826Ab1AGWrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:47:25 -0500
Message-ID: <20110107224723.12661.qmail@stuge.se>
Date: Fri, 7 Jan 2011 23:47:23 +0100
From: Peter Stuge <peter@stuge.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k tx lockup, ath: received PCI FATAL
	interrupt
References: <20110107215549.4053.qmail@stuge.se> <AANLkTikb2bAeB6EqVoRSVvQUWqY70F4fO5d1cWKHgbRO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="B7FF+pnjRCrp0ISR"
In-Reply-To: <AANLkTikb2bAeB6EqVoRSVvQUWqY70F4fO5d1cWKHgbRO@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--B7FF+pnjRCrp0ISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Brian Prodoehl wrote:
> Out of curiosity, what's your AP?

July 2006 Linux 2.6.17.6 madwifi-ng Mini PCI AR5212.

wlan: 0.8.4.2 (svn 1531)
ath_hal: module license 'Proprietary' taints kernel.
ath_hal: 0.9.16.16 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
ath_rate_sample: 1.2 (svn 1531)
ath_pci: 0.9.4.5 (svn 1531)
..
wifi0: mac 5.9 phy 4.3 radio 3.6
..
wifi0: Atheros 5212: mem=0xa0010000, irq=11


> I've never seen those "detected beacon loss from AP" messages.

I fully expect that this AP is not behaving perfectly, but that is of
course irrelevant in the scope of ath9k when ipw2200 ath5k orinoco_cs
can deal. If anything, the AP is valuable for debugging ath9k, which
is also why I prefer not to change the AP until it seems like all
issues have been solved.

(But I've had plenty of problems with ath9k also on various other
APs, just no logs from anything else today.)


> If you bring up a monitor-mode interface,

Then I got some new suspect messages in the kernel log. But internet
and monitor both work.

dmesg output in log8_after_iw_dev_eth1_interface_add_wmon0.txt


> do you see beacons at a sane, regular interval?

100ms, with some missing ones. (3 missing in 327 received, second
test 13 missing in 819 received over 93 seconds. Seems to match the
beacon loss messages.)


//Peter

--B7FF+pnjRCrp0ISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log8_after_iw_dev_eth1_interface_add_wmon0.txt"

[ 6454.002053] eth1: detected beacon loss from AP - sending probe request
[ 6456.004646] eth1: detected beacon loss from AP - sending probe request
[ 6456.077272] eth1: cancelling probereq poll due to a received beacon
[ 6467.002036] eth1: detected beacon loss from AP - sending probe request
[ 6467.029043] eth1: cancelling probereq poll due to a received beacon
[ 6471.002043] eth1: detected beacon loss from AP - sending probe request
[ 6471.123295] eth1: cancelling probereq poll due to a received beacon
[ 6479.002039] eth1: detected beacon loss from AP - sending probe request
[ 6479.415183] eth1: cancelling probereq poll due to a received beacon
[ 6484.004933] eth1: detected beacon loss from AP - sending probe request
[ 6484.429046] eth1: cancelling probereq poll due to a received beacon
[ 6499.002036] eth1: detected beacon loss from AP - sending probe request
[ 6505.004023] eth1: detected beacon loss from AP - sending probe request
[ 6505.411352] eth1: cancelling probereq poll due to a received beacon
[ 6517.002038] eth1: detected beacon loss from AP - sending probe request
[ 6519.002038] eth1: detected beacon loss from AP - sending probe request
[ 6521.004032] eth1: detected beacon loss from AP - sending probe request
[ 6523.004046] eth1: detected beacon loss from AP - sending probe request
[ 6526.004664] eth1: detected beacon loss from AP - sending probe request
[ 6528.004664] eth1: detected beacon loss from AP - sending probe request
[ 6530.004659] eth1: detected beacon loss from AP - sending probe request
[ 6532.004659] eth1: detected beacon loss from AP - sending probe request
[ 6534.002031] eth1: detected beacon loss from AP - sending probe request
[ 6538.002035] eth1: detected beacon loss from AP - sending probe request
[ 6538.060097] eth1: cancelling probereq poll due to a received beacon
[ 6539.002032] eth1: detected beacon loss from AP - sending probe request
[ 6539.083602] eth1: cancelling probereq poll due to a received beacon
[ 6563.004041] eth1: detected beacon loss from AP - sending probe request
[ 6584.002040] eth1: detected beacon loss from AP - sending probe request
[ 6590.004666] eth1: detected beacon loss from AP - sending probe request
[ 6590.363990] eth1: cancelling probereq poll due to a received beacon
[ 6594.004665] eth1: detected beacon loss from AP - sending probe request
[ 6596.004659] eth1: detected beacon loss from AP - sending probe request
[ 6596.196543] eth1: cancelling probereq poll due to a received beacon
[ 6603.002037] eth1: detected beacon loss from AP - sending probe request
[ 6603.055257] eth1: cancelling probereq poll due to a received beacon
[ 6611.004043] eth1: detected beacon loss from AP - sending probe request
[ 6611.343697] eth1: cancelling probereq poll due to a received beacon
[ 6621.002035] eth1: detected beacon loss from AP - sending probe request
[ 6621.476484] eth1: cancelling probereq poll due to a received beacon
[ 6625.004032] eth1: detected beacon loss from AP - sending probe request
[ 6630.004657] eth1: detected beacon loss from AP - sending probe request
[ 6630.073998] eth1: cancelling probereq poll due to a received beacon
[ 6636.004675] eth1: detected beacon loss from AP - sending probe request
[ 6636.112735] eth1: cancelling probereq poll due to a received beacon
[ 6644.002030] eth1: detected beacon loss from AP - sending probe request
[ 6644.198491] eth1: cancelling probereq poll due to a received beacon
[ 6673.144321] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 6673.144357] ath: Failed to stop TX DMA!
[ 6676.541321] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 6676.541357] ath: Failed to stop TX DMA!

--B7FF+pnjRCrp0ISR--
