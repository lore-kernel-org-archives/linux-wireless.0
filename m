Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56020 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaAINP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 08:15:59 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21198.40916.260973.48444@gargle.gargle.HOWL> (sfid-20140109_141602_210602_4645E3DE)
Date: Thu, 9 Jan 2014 18:40:44 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52CE934D.1020400@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> This code will always set run_agc to true. Does it mean you always have 
> to run agc cal no matter what since default is anyway true or it's just a typo?

That was the aim of the patch.

When it has been decided to do TX IQ calibration, AGC cal has to be
run. IQ cal can be done separately in the driver (pre-AR9485) or it
can be taken care of by the HW when AGC cal is triggered.

> The reason I am asking is that I have ran into problem with rssi reporting
> when calibration is ongoing.  It looks like beacon received just after IQ
> mismatch calibration is reported ~10-15 dB higher than it should. I have
> verified power with wireshark and they are ok at antenna port.  Next beacons
> are reported fine. I have tried to enable disable different antennas but it
> doesn't seem to affect the results.
> 
> It doesn't happen all the time but since iq calibration is on every time we
> are scanning it puts wrong rssi value in scan result entry. I don't have a
> proof yet but it might affect probe responses as well.

Which chip ? Is this issue seen with an older snapshot of the driver ?
(There is an IQ cal fix for AR955x which I haven't ported to ath9k yet).

Sujith
