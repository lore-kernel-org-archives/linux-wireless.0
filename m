Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:52920 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbaGAIYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 04:24:00 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: thomas@fjellstrom.ca
Cc: linux-wireless@vger.kernel.org
Subject: Re: Linux iwlwifi 801.11n speeds
Date: Tue, 01 Jul 2014 10:23:43 +0200
Message-ID: <2751617.yrMEdml3a5@al> (sfid-20140701_102601_077560_D0877A02)
In-Reply-To: <2766921.O7z3bAoKY3@balsa>
References: <2766921.O7z3bAoKY3@balsa>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 June 2014 15:43:36 Thomas Fjellstrom wrote:
> Hi,
> 
> I've been doing some reasearch and testing lately, and have noticed that
> 802.11n speeds in linux on two iwlwifi devices (6300, 6205) are anywhere
> from 20 to 40mbps slower than in windows 7.
> 
> I've tried enabling swcrypto and disabling power management, and neither
> help.
> 
> While signal strength seems to be better in windows based on the signal
> meter, they may just calculate signal bars differently. I don't know.
> 
> Is there anything I can do to achieve similar speeds? I easily reach 90+
> mbps in windows, and rarely reach 70 mbps in linux.
> 
> I'm running debian sid, with the 3.14.7 and 3.14.4 debian kernels, and
> should have the latest iwlwifi firmware.
> 
> I have a dual band Ubiquity AP Pro ap connected to a Sokeris 6501-50
> firewall appliance running debian sid as well, and connected to a full GbE
> lan, which regularly achieves full speeds of 90MBps+. All settings on the
> actual network were not changed between speed tests. N was tested solely on
> the 5Ghz band, channel 36, and there is very little interference here on
> 5ghz. There is one other network visible and its on the other end of the
> 5ghz band.
> 
> Oh, and my nexus 7 (2013) also achieves 90mbps+, it may even get better, but
> I haven't managed to test local speeds, just tested with the speedtest.net
> app, and my internet is 100mbps, so it pretty much maxes it out.

Have you tried setting the module param 11n_disable=8?

I have this in my modprobe.conf:

# Enable AMPDU (otherwise there is a performance regression from 80
# Mbit/s to 20 Mbit/s). Introduced with v3.13-10103-g205e221 ("iwlwifi:
# disable TX AMPDU by default for iwldvm").
options iwlwifi 11n_disable=8

Kind regards,
Peter
https://lekensteyn.nl
