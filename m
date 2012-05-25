Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3625 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2EYQrl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 12:47:41 -0400
Message-ID: <4FBFB79F.4060609@broadcom.com> (sfid-20120525_184745_589488_0E5BDC12)
Date: Fri, 25 May 2012 18:47:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: BCM4331 tx failures after S3
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com> <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com> <20120524212115.GD26760@thinkpad-t410>
 <4FBEA96D.8030207@hauke-m.de> <20120525141339.GB2895@thinkpad-t410>
In-Reply-To: <20120525141339.GB2895@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 04:13 PM, Seth Forshee wrote:
> On Thu, May 24, 2012 at 11:34:37PM +0200, Hauke Mehrtens wrote:
>> Hi Seth,
>>
>> rmmod and insmod of b43 does not help but doing this with b43 and bcma
>> works is that correct?
>> Have you tried to add this code from bcma_host_pci_probe() to resume:
>>
>> 	/* Disable the RETRY_TIMEOUT register (0x41) to keep
>> 	 * PCI Tx retries from interfering with C3 CPU state */
>> 	pci_read_config_dword(dev, 0x40, &val);
>> 	if ((val & 0x0000ff00) != 0)
>> 		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
>>
>> Could you also try to run bcma_sprom_get() after resume.
> 
> Okay, this one fixes it. The part that's needed seems to be:
> 
>         if (bus->chipinfo.id == 0x4331)
>                 bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
> 
> I could have sworn I tried adding this to resume before, but apparently
> I didn't.
> 
> Hmm. It turns out that BCMA_CC_CHIPCTL is completely reset to 0 when on
> S3 without AC power, meaning all other fields in the register get
> cleared as well. On this MBP that's affecting
> BCMA_CHIPCTL_4331_BT_COEXIST. So we could save the value at suspend and
> restore it during resume, but maybe the initialization of this register
> also needs to be improved. Thoughts?
> 
> Thanks,
> Seth
> 
> 

Well let me explain some behaviour. Upon suspend mac80211 takes down the
driver with the last callback being .stop(). Upon resume mac80211 calls
the driver with .start() callback.

The brcmsmac driver has two bool states that are in play here: driver_up
and hw_up. Upon .stop() callback the driver_up is set to false, but
hw_up remains true. A subsequent .start() will perform some
reconfiguration and driver_up will be made true.

The suspend/resume scenario is different for brcmsmac. bcma will call
brcmsmac .suspend() callback in which we set hw_up to false. This
changes the behaviour of the .start() callback after resume. Basically,
it reinitializes the hardware.

Not sure why having AC connected would make a difference. Maybe the
device is not completely turned off (for WoWL maybe?).

Gr. AvS

