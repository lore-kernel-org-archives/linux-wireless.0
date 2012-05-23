Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1528 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2EWJa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 05:30:56 -0400
Message-ID: <4FBCAE3E.6050206@broadcom.com> (sfid-20120523_113100_802668_8909AD60)
Date: Wed, 23 May 2012 11:30:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: BCM4331 tx failures after S3
References: <20120522165251.GA31347@thinkpad-t410>
In-Reply-To: <20120522165251.GA31347@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2012 06:52 PM, Seth Forshee wrote:
> Hi Arend,
> 
> I've inquired about this issue on the list once before, but I thought
> I'd try once again to see if Broadcom can offer any suggestions.
> 
> Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
> doesn't work after S3, but only if no external power is applied during
> the resume. mac80211 reports mostly timeouts for responses to probe
> requests, but analysis with wireshark shows no frames from the BCM4331
> on the air. The only way I've found to recover is to reload both b43 and
> bcma; reloading b43 alone is not enough.

Yikes. I recently did suspend/resume and hibernate testing with BCM43224
(so brcmsmac and bcma), but my system was on AC. I will execute them
again on battery. I want to make sure it is not a BCM4331 specific issue.

> I've checked the values of MACCTL and the DMA TXCTL registers, since
> these are the ones used by brcmsmac to mute tx, but those look okay. Any
> suggestions of other things to check? My next step would be to start
> looking at the state of the phy and radio, but since we don't have much
> information about what the registers there actually do some suggestions
> would be helpful.

When going to S3 the driver is told by mac80211 .stop callback to abort
driver operation so I do not expect b43 has a problem. Instead we
probably have to look at the host PCI code in bcma, but before going
there let me execute my tests.

Can you tell me on what kernel version you see this issue. I would also
like to have a look at your kernel log.

> Thanks,
> Seth
> 


