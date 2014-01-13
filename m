Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42707 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAMPND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 10:13:03 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21204.319.492595.58625@gargle.gargle.HOWL> (sfid-20140113_161307_178543_9DD0353E)
Date: Mon, 13 Jan 2014 20:37:43 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52D3F962.1010302@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> I have done some tests with latest wireless testing and our own rf card. 
> It seems
> that 13-15dB is the difference between nominal NF(-115) and measured -101.
> When device goes scanning and it returns back to the channel it 
> "forgets" about
> old noise histogram and sets it to default. Then all the packets will 
> have wrong
> rssi until next noise floor calibration occurs.
> Below I have a log with custom printk to show the problem.

Is this how you see the issue ?

* In station mode, associate.
* Run a scan.
* When we come back to the operating channel, reported rssi
  appears to be incorrect until a NF cal is done.

Or is it something else ?

SUjith
