Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33356 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbcFDDyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 23:54:55 -0400
Received: by mail-oi0-f43.google.com with SMTP id k23so155543820oih.0
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2016 20:54:54 -0700 (PDT)
Date: Fri, 3 Jun 2016 22:54:52 -0500
From: David Gilman <dgilman@gilslotd.com>
To: buytenh@wantstofly.org
Cc: linux-wireless@vger.kernel.org
Subject: Troubleshooting mwl8k driver issue
Message-ID: <20160604035452.GA5925@dar.local> (sfid-20160604_055459_200020_ACA46742)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lennert, I am a user of your mwl8k driver through the OpenWRT
distribution.  When working with certain WiFi devices I get errors in
the kernel logs and network connectivity errors on the wireless device.
The dmesg logs look like this:

[539374.394607] ieee80211 phy1: Added a new stream for (BSSID MAC) 0
[539374.394650] ieee80211 phy1: Started stream for (BSSID MAC) 0
[539374.394732] ieee80211 phy1: tx rings drained
[539374.401372] ieee80211 phy1: Created a BA stream for (BSSID MAC) : tid 0

`iw event -t' logs (it looks like OpenWRT is patching the heck out of this
tool):

1465008930.594531: wlan1 (phy #1): unknown event 60
1465008930.652119: wlan1 (phy #1): unknown event 60
1465008930.653494: wlan1 (phy #1): unknown event 60
1465008930.655582: wlan1: new station (BSSID MAC)

There are a number of other users who are also experiencing the same
issue on the OpenWRT bug tracker:

https://dev.openwrt.org/ticket/21284

As I noted in the bug the driver works with some of my wireless devices
and not others which suggests that something subtle is up with some
driver in this picture.

I don't have a whole lot of experience with kernel development (pretty
much none actually) and I know absolutely nothing about how these WiFi
devices work.  However I am willing to work with you or anyone else on
the linux-wireless list (which I have CCd) to help troubleshoot this
issue.  I am using OpenWRT on this router and I can get a build
environment set up for debug kernel builds with their toolchain.  I'm
running a pretty recent kernel (4.4.7) but git log suggests this driver
hasn't been touched in a while.

-- 
David Gilman  :DG<
http://gilslotd.com
