Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42252 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2FGNpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:45:19 -0400
Message-ID: <4FD0B062.1080606@hauke-m.de> (sfid-20120607_154523_314351_9CAD244D)
Date: Thu, 07 Jun 2012 15:45:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/18] brcmsmac: add some workarounds for other chips
 again
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-14-git-send-email-hauke@hauke-m.de> <4FCF2AF1.8020200@broadcom.com>
In-Reply-To: <4FCF2AF1.8020200@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 12:03 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> This adds some workarounds for the BCM4716, BCM47162, BCM43421, BCM5357
>> and BCM6362 to the phy code again. This patch reverts the following
> 
> Has brcmsmac been tested for all these chips? At this moment I do not
> have any bandwidth to do that. I am not too comfortable adding this code
> without having some testing coverage. It was the reason to remove the
> snippets from brcmsmac.
I have just tested BCM4716 and BCM5357, BCM5357 is not working. ;-)
I do not have all the devices to test this and for the BCM6362 some
infrastructure code is still missing.
The adding of the BCM5357 is part of my start adding support for that
chip, which is not complete. As the device detection code in brcmsmac
is not changed in this commit, no more devices are detected by brcmsmac
now. I talked to Jonas Gorski about the BCM6362 and he thinks about
adding support for that device to the Linux kernel in some time.

I could reduce the code into adding support for the BCM4716 and BCM5357
if that is fine with you and if someone else wants to add support for
some other chip in the future he has to add the code again.

> 
>> patch expect the part with the workaround for the BCM43236, which is an
>> usb chip and will be unsupported by brcmsmac.
> 
> 'expect' should be 'except'. Indeed, BCM43236 is a fullmac usb chip and
> as such supported by brcmfmac.
Yes that's the reason I removed it here because this will never be
supported by this code.
> 
> Gr. AvS
> 

