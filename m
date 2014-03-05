Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:11029 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaCEQPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 11:15:33 -0500
Message-ID: <53174D9F.6010803@broadcom.com> (sfid-20140305_171537_261196_889A5C6C)
Date: Wed, 5 Mar 2014 17:15:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac NVRAM files
References: <20140217150640.GJ18868@zurbaran> <20140217163315.GA22010@zurbaran> <53023E51.90202@Uni-Oldenburg.DE> <530248DD.1050408@broadcom.com> <20140217180033.GM18868@zurbaran> <53032EAB.5070905@broadcom.com> <20140305023151.GG17664@zurbaran> <5316E88D.7010605@broadcom.com> <20140305102408.GB14401@zurbaran>
In-Reply-To: <20140305102408.GB14401@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/14 11:24, Samuel Ortiz wrote:
> I'm attaching the log corresponding to a modprobe brcmfmac debug=0x31416
> &&  ifconfig wlan0 up sequence.
> I have modified this in the driver, to make it less aggressive about
> SDIO sleeps:
>
> sdio_host.h:
> #define BRCMF_WD_POLL_MS        200
>
> dhd_sdio.c:
> #define BRCMF_IDLE_INTERVAL     20

So this log looks fine, because due to the changes above it never goes 
to sleep. The log actually show it is a backport, right?

>> >  I also have 2 question for you;-)
> Sorry if I sounded a bit rude, I didn't mean it :-/

I did not take it as rude so no worries.

>> >  - what mmc host controller is used?
> So this is sdhci-acpi.
>
>> >  - do you have CONFIG_RUNTIME_PM enabled?
> CONFIG_PM_RUNTIME is enabled, yes. Do you want me to test with it
> disabled ?
>

I am asking because Russell King recently discovered that SDHCI based 
host controller drivers disable the SDIO interrupt. This would explain 
the timeout on the scan as the scan results are events from the device 
that require this interrupt. Even with your patches this may still 
happen. You can probably disable it for the host controller through sysfs.

Regards,
Arend
