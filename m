Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3367 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab2HQRip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 13:38:45 -0400
Message-ID: <502E819D.3000203@broadcom.com> (sfid-20120817_193849_695239_D0AC30B8)
Date: Fri, 17 Aug 2012 10:38:37 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Dani Camps" <danicamps81@yahoo.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Forcing wi-fi chipset to sleep from bcm4329 driver
References: <1345115328.54417.YahooMailNeo@web29702.mail.ird.yahoo.com>
 <502D33E6.4050106@broadcom.com>
 <1345187963.23828.YahooMailNeo@web29704.mail.ird.yahoo.com>
In-Reply-To: <1345187963.23828.YahooMailNeo@web29704.mail.ird.yahoo.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/17/2012 12:19 AM, Dani Camps wrote
> I am working on a research project, and our intention is to study the effect that the Wi-Fi radio has on the battery life of an Android mobile phone. In particular we would like to be able to configure the wi-fi radio to stay "awake" for a certain time period and "sleeping" for other time periods, and then study how the length of these intervals affects battery lifetime. From your answer, I understand that we cannot control exactly the power state of the chipset, but I wanted to check with you whether the following approach might work:
>
> 0- We let the mobile device associate with an Access Point.
> 1- When we want the chipset to stay awake, we send from the driver a PM_OFF configuration command to the chipset. What I expect it would happen is that the chipset sends a packet to the AP with PM=0, and stays awake all the time.
> 2- When we want to send the chipset to sleep, we send from the driver a PM_MAX configuration command to the chipset. What I expect it would happen is that the chipset sends a packet to the AP with PM=1, and goes to sleep. Now, IF we can guarantee that there is no traffic to/from the mobile device during the time that we want the chipset to be sleep, then the chipset will indeed be sleeping *most* of the time. The only exception will be that the chipset will regularly wake up to catch a Beacon frame, but probably it is also possible to configure how often that happens, and thus the effect on our measurements is not large.
>
> Do you think the previous method is sound?
>

Your approach looks good. I think that's the best we can do. ;)

Franky


