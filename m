Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56433 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181AbXBFWSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 17:18:55 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HEYdF-0004Dh-8i
	for linux-wireless@vger.kernel.org; Tue, 06 Feb 2007 17:17:45 -0500
Subject: Re: RFT bcm43xx: Really _GOOD_ news
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <45C8E64B.1050605@lwfinger.net>
References: <45C8E64B.1050605@lwfinger.net>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 17:18:50 -0500
Message-Id: <1170800330.2613.10.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-06 at 14:34 -0600, Larry Finger wrote:
> I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
> interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
> three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
> it was the only card of the 3 thaw would work at 11Mbs. A light went on!
> 
> After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
> with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.

I'm getting a sustained 1.7 megabytes per second over FTP with 4312
(PCIe card in Dell Latitude).  The connection to a 802.11g AP was
established instantaneously.

I have never had much success with the softmac driver at all.  Now it's
working better than the d80211 driver, with waits for minutes before it
starts talking to the same 802.11g AP.

I think it's a 2.6.20.1 material, considering its gain/changes ratio.
I'm actually going to compile this kernel without debug and keep it as a
"production" kernel.

Congratulations and many many thanks!

-- 
Regards,
Pavel Roskin

