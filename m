Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbaCEQu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 11:50:56 -0500
Date: Wed, 5 Mar 2014 17:50:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac NVRAM files
Message-ID: <20140305165049.GE14401@zurbaran> (sfid-20140305_175059_063816_FCCF0264)
References: <20140217150640.GJ18868@zurbaran>
 <20140217163315.GA22010@zurbaran>
 <53023E51.90202@Uni-Oldenburg.DE>
 <530248DD.1050408@broadcom.com>
 <20140217180033.GM18868@zurbaran>
 <53032EAB.5070905@broadcom.com>
 <20140305023151.GG17664@zurbaran>
 <5316E88D.7010605@broadcom.com>
 <20140305102408.GB14401@zurbaran>
 <53174D9F.6010803@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53174D9F.6010803@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2014 at 05:15:27PM +0100, Arend van Spriel wrote:
> On 03/05/14 11:24, Samuel Ortiz wrote:
> >I'm attaching the log corresponding to a modprobe brcmfmac debug=0x31416
> >&&  ifconfig wlan0 up sequence.
> >I have modified this in the driver, to make it less aggressive about
> >SDIO sleeps:
> >
> >sdio_host.h:
> >#define BRCMF_WD_POLL_MS        200
> >
> >dhd_sdio.c:
> >#define BRCMF_IDLE_INTERVAL     20
> 
> So this log looks fine, because due to the changes above it never
> goes to sleep. The log actually show it is a backport, right?
That's correct, yes.

 
> >>>  I also have 2 question for you;-)
> >Sorry if I sounded a bit rude, I didn't mean it :-/
> 
> I did not take it as rude so no worries.
> 
> >>>  - what mmc host controller is used?
> >So this is sdhci-acpi.
> >
> >>>  - do you have CONFIG_RUNTIME_PM enabled?
> >CONFIG_PM_RUNTIME is enabled, yes. Do you want me to test with it
> >disabled ?
> >
> 
> I am asking because Russell King recently discovered that SDHCI
> based host controller drivers disable the SDIO interrupt.
You mean they do so from their runtime_suspend hook ?
I see the thread now:

http://www.spinics.net/lists/arm-kernel/msg308757.html

It seems those patches have not been reviewed nor merged...
I'll watch that thread closely ;)

> This would
> explain the timeout on the scan as the scan results are events from
> the device that require this interrupt. Even with your patches this
> may still happen. You can probably disable it for the host
> controller through sysfs.
I did so, and things seem to be more stable. The throughput is a lot
better. Better is expected but 20x better is something else.
I still get fairly weak signal, typically -75 dBm for APs that are a few
meters away. Does that sound like reasonable values to you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
