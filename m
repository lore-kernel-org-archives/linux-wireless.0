Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2EYONp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 10:13:45 -0400
Date: Fri, 25 May 2012 09:13:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: BCM4331 tx failures after S3
Message-ID: <20120525141339.GB2895@thinkpad-t410> (sfid-20120525_161349_209488_58463A41)
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com>
 <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com>
 <20120524212115.GD26760@thinkpad-t410>
 <4FBEA96D.8030207@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBEA96D.8030207@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 11:34:37PM +0200, Hauke Mehrtens wrote:
> Hi Seth,
> 
> rmmod and insmod of b43 does not help but doing this with b43 and bcma
> works is that correct?
> Have you tried to add this code from bcma_host_pci_probe() to resume:
> 
> 	/* Disable the RETRY_TIMEOUT register (0x41) to keep
> 	 * PCI Tx retries from interfering with C3 CPU state */
> 	pci_read_config_dword(dev, 0x40, &val);
> 	if ((val & 0x0000ff00) != 0)
> 		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
> 
> Could you also try to run bcma_sprom_get() after resume.

Okay, this one fixes it. The part that's needed seems to be:

        if (bus->chipinfo.id == 0x4331)
                bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);

I could have sworn I tried adding this to resume before, but apparently
I didn't.

Hmm. It turns out that BCMA_CC_CHIPCTL is completely reset to 0 when on
S3 without AC power, meaning all other fields in the register get
cleared as well. On this MBP that's affecting
BCMA_CHIPCTL_4331_BT_COEXIST. So we could save the value at suspend and
restore it during resume, but maybe the initialization of this register
also needs to be improved. Thoughts?

Thanks,
Seth

