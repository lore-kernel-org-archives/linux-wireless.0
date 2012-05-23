Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2EWNvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 09:51:39 -0400
Date: Wed, 23 May 2012 08:51:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: BCM4331 tx failures after S3
Message-ID: <20120523135134.GA30165@thinkpad-t410> (sfid-20120523_155143_114919_DE9A8E52)
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAA9C.10209@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBCAA9C.10209@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2012 at 11:15:08AM +0200, Hauke Mehrtens wrote:
> On 05/22/2012 06:52 PM, Seth Forshee wrote:
> > Hi Arend,
> > 
> > I've inquired about this issue on the list once before, but I thought
> > I'd try once again to see if Broadcom can offer any suggestions.
> > 
> > Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
> > doesn't work after S3, but only if no external power is applied during
> > the resume. mac80211 reports mostly timeouts for responses to probe
> > requests, but analysis with wireshark shows no frames from the BCM4331
> > on the air. The only way I've found to recover is to reload both b43 and
> > bcma; reloading b43 alone is not enough.
> > 
> > I've checked the values of MACCTL and the DMA TXCTL registers, since
> > these are the ones used by brcmsmac to mute tx, but those look okay. Any
> > suggestions of other things to check? My next step would be to start
> > looking at the state of the phy and radio, but since we don't have much
> > information about what the registers there actually do some suggestions
> > would be helpful.
> > 
> > Thanks,
> > Seth
> 
> Hi Seth,
> 
> as reloading bcma helps could you try the attached patch which runs the
> code for pci core initialisation on resume again. I saw some comments
> about some functions which should be called on resume for pci core
> initialisation in brcmsmac.
> 
> The other patch adds some pci workarounds for recent apple devices like
> yours.
> 
> Both patches are not even compile tested.

Hi Hauke,

Thanks for the suggestions. I had actually already tried all of these
workarounds a while back without success (the pci reinitialization was
the very first thing I thought of as well). I went ahead and tried you
patches on top of wireless-next anyway, and still no joy.

Thanks,
Seth

