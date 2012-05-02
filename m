Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60610 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab2EBWea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 18:34:30 -0400
Message-ID: <4FA1B66A.4060901@hauke-m.de> (sfid-20120503_003434_685099_E807C226)
Date: Thu, 03 May 2012 00:34:18 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com>
In-Reply-To: <4FA0CF03.9060307@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2012 08:06 AM, Arend van Spriel wrote:
> On 04/29/2012 10:13 AM, Arend van Spriel wrote:
>> On 04/29/2012 02:50 AM, Hauke Mehrtens wrote:
>>> I have not completely runtime tested these patches as I do not have a
>>> PCI(e) devices currently supported by brcmsmac. My SoC (BCM4718) and
>>> the PCI devices connected to my SoC (BCM43224) are currently not
>>> working with brcmsmac, but they are failing much later that without
>>> these patches.
>>
>> I will test this patch series as well on PCI(e) devices. So you do have
>> a bcm43224 card, but no laptop to fit it in? Just wondering. I will send
>> the results.
>>
>> Gr. AvS
>>
> 
> Hi Hauke,
> 
> I have tested this patch series including the other two series as I
> suspect there is a dependancy so:
> 
> [PATCH 0/8] ssb/bcma/bcm47xx: extend boardinfo and sprom
> [PATCH 0/4] bcma: add PCI functions from brcmsmac

Yes these patch series are mostly providing some stuff needed by brcmsmac.

> I only did some basic testing, but wanted to let you know the results so
> far:
> 
> BCM43224/OTP/64-bit/2.4G: 63 Mbps
> BCM43224/OTP/64-bit/5G: 57 Mbps
> BCM43224/SPROM/32-bit/2.4G: 65 Mbps
> BCM43224/SPROM/32-bit/5G: 63 Mbps
> 
> These are pretty normal numbers. I will add the test branch to my
> nightly regression testing for the next couple of days.
> 
> First impression: Great job!

Hi Arend,

thanks for testing.

Have you tried suspend/resume and hibernate/resume? I think some of the
workaround in drivers/bcma/driver_pci.c should be called in the resume
path and not only in the initialization path.

Hauke
