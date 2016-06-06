Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([138.201.34.84]:33838 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcFFG7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 02:59:41 -0400
Date: Mon, 6 Jun 2016 09:51:46 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Gilman <dgilman@gilslotd.com>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160606065146.GK8402@wantstofly.org> (sfid-20160606_085944_398070_D24A4166)
References: <20160604035452.GA5925@dar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160604035452.GA5925@dar.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2016 at 10:54:52PM -0500, David Gilman wrote:

> Lennert, I am a user of your mwl8k driver through the OpenWRT
> distribution.  When working with certain WiFi devices I get errors in
> the kernel logs and network connectivity errors on the wireless device.
> The dmesg logs look like this:
> 
> [539374.394607] ieee80211 phy1: Added a new stream for (BSSID MAC) 0
> [539374.394650] ieee80211 phy1: Started stream for (BSSID MAC) 0
> [539374.394732] ieee80211 phy1: tx rings drained
> [539374.401372] ieee80211 phy1: Created a BA stream for (BSSID MAC) : tid 0

These are not (necessarily) errors, just debug messages


> There are a number of other users who are also experiencing the same
> issue on the OpenWRT bug tracker:
> 
> https://dev.openwrt.org/ticket/21284

There's a bunch of bad-looking stuff in the posted dmesgs, such as:

[ 10.983657] pci 0000:00:01.0: enabling device (0140 -> 0142)
[ 11.972069] ieee80211 phy0: Command RF_ANTENNA error 0x2
[ 11.977455] ieee80211 phy0: failed to set # of RX antennas
[ 11.993318] ieee80211 phy0: Command RF_ANTENNA error 0x2
[ 11.998713] ieee80211 phy0: failed to set # of TX antennas
[ 12.004243] ieee80211 phy0: 88w8366 v48, c8d719177244, STA firmware 4.1.0.3

And:

[ 22.517451] 0000:02:00.0: unable to load firmware helper image
[ 22.523399] ieee80211 phy1: Cannot start firmware
[ 22.528230] ieee80211 phy1: Trying to reload the firmware again
[ 23.016669] ieee80211 phy1: 88w8366 v7, c8d719177246, AP firmware 5.2.8.17


> As I noted in the bug the driver works with some of my wireless devices
> and not others which suggests that something subtle is up with some
> driver in this picture.

Is the behavior consistent per device across boots?  I.e. does device
X always work on every boot while device Y never works at all?


> I don't have a whole lot of experience with kernel development (pretty
> much none actually) and I know absolutely nothing about how these WiFi
> devices work.  However I am willing to work with you or anyone else on
> the linux-wireless list (which I have CCd) to help troubleshoot this
> issue.  I am using OpenWRT on this router and I can get a build
> environment set up for debug kernel builds with their toolchain.  I'm
> running a pretty recent kernel (4.4.7) but git log suggests this driver
> hasn't been touched in a while.

For starters, could you post lspci -n output?

Also, do you see the same behavior with older kernels, or have you
only tried 4.4?
