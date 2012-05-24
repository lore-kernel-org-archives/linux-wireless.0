Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab2EXVVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 17:21:20 -0400
Date: Thu, 24 May 2012 16:21:15 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: BCM4331 tx failures after S3
Message-ID: <20120524212115.GD26760@thinkpad-t410> (sfid-20120524_232124_532758_4502B846)
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com>
 <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBE0110.5020209@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 11:36:16AM +0200, Arend van Spriel wrote:
> On 05/23/2012 03:55 PM, Seth Forshee wrote:
> > On Wed, May 23, 2012 at 11:30:38AM +0200, Arend van Spriel wrote:
> >> On 05/22/2012 06:52 PM, Seth Forshee wrote:
> >>> Hi Arend,
> >>>
> >>> I've inquired about this issue on the list once before, but I thought
> >>> I'd try once again to see if Broadcom can offer any suggestions.
> >>>
> >>> Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
> >>> doesn't work after S3, but only if no external power is applied during
> >>> the resume. mac80211 reports mostly timeouts for responses to probe
> >>> requests, but analysis with wireshark shows no frames from the BCM4331
> >>> on the air. The only way I've found to recover is to reload both b43 and
> >>> bcma; reloading b43 alone is not enough.
> >>
> >> Yikes. I recently did suspend/resume and hibernate testing with BCM43224
> >> (so brcmsmac and bcma), but my system was on AC. I will execute them
> >> again on battery. I want to make sure it is not a BCM4331 specific issue.
> > 
> > I'm also testing a Macbook Air with BCM43224 using brcmsmac, and it does
> > not suffer from the same issue.
> 
> Good to know. I will check whether there are any known issues with
> BCM4331 that could explain this.
> 
> >>> I've checked the values of MACCTL and the DMA TXCTL registers, since
> >>> these are the ones used by brcmsmac to mute tx, but those look okay. Any
> >>> suggestions of other things to check? My next step would be to start
> >>> looking at the state of the phy and radio, but since we don't have much
> >>> information about what the registers there actually do some suggestions
> >>> would be helpful.
> >>
> >> When going to S3 the driver is told by mac80211 .stop callback to abort
> >> driver operation so I do not expect b43 has a problem. Instead we
> >> probably have to look at the host PCI code in bcma, but before going
> >> there let me execute my tests.
> >>
> >> Can you tell me on what kernel version you see this issue. I would also
> >> like to have a look at your kernel log.
> > 
> > I'm still seeing it in both 3.4 and wireless-testing. Attached is dmesg
> > from wireless-testing.
> 
> Nothing really looks wrong in there, but then again there are not much
> b43/bcma related messages.

I don't know if this helps, but I can do a successful passive scan when
tx isn't working. So it seems rx still works, only tx is broken. I also
forgot to state explicitly that it only matters that AC power isn't
present during the resume; i.e. I can suspend with AC connected, remove
AC, then resume, and I will still get tx failures.

I've been going through the suspend/resume paths for bcma and pci, and I
can't find anything that would account for differing behavior depending
on whether or not AC power is present. Even the ACPI _PS* methods for
the device appear to be (effectively) no-ops.

The only other thing that comes to mind that might be disabling tx is
firmware, either system firmware or the BCM4331's firmware. Perhaps
there's something that bcma or b43 is not initializing that's usually in
the needed state? That's mostly just a guess, but I'm at a loss for
other explanations at this point.

Cheers,
Seth

