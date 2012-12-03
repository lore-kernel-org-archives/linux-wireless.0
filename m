Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3367 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2LCUk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 15:40:26 -0500
Message-ID: <50BD0E35.8030807@broadcom.com> (sfid-20121203_214029_946261_9ECD60EB)
Date: Mon, 3 Dec 2012 21:40:21 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: brcmsmac: Data bus error in reading tsf_random
References: <50BAB095.2070103@hauke-m.de>
In-Reply-To: <50BAB095.2070103@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2012 02:36 AM, Hauke Mehrtens wrote:
> Hi Arend,
> 
> I am getting a Data bus error when brcmsmac tries to read tsf_random in
> brcms_c_wme_setparams. This does not happen when I add a printk
> somewhere near that read of tsf_random or when I replace the read with a
> constant. In b43 this code works, without this error for me, see
> b43_qos_params_upload(). With the BCM4716 I do not have this problem. It
> could be that this is caused by the broken PCIe controller in the BCM4716.

I can look for known workarounds but I am afraid you know way more about
the BCM4716 than I do.

> I am using brcmsmac from compat-wireless 2012-09-07, but I have also
> tried the most recent brcmsmac code from wireless-testing. brcmsmac uses
> the normal firmware from linux-firmware and I have also tried the new
> firmware posted some days ago with the same result.
> 
> I am using a BCM43224 connected to the PCIe controller of the BCM4716.
> 
> Are there any special requirements for reading tsf_random under mips?

Not that I recall.

> To make my BCM43224 work I use this patch [0], the "printk("dummy\n");"
> is a hack to workaround the problem I am describing here.

That kind of hacks always make me suspicious about the compiler. I guess
you checked that both brcmsmac and b43 read the same register offset to
get tsf_random, right?

Regards,
Arend

