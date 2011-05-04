Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1EDNZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:25:53 -0400
Date: Wed, 4 May 2011 15:26:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn: crash when unloading the module
Message-ID: <20110504132602.GA2183@redhat.com> (sfid-20110504_152557_712732_5E745274)
References: <87iptsgk5y.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87iptsgk5y.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2011 at 01:20:25PM +0300, Kalle Valo wrote:
> I noticed today a crash when removing iwlagn module. I can see the
> crash everytime on my lenovo x201 (x86 64bit, i5) with this wireless
> chip:
> 
> [   19.484551] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R)
> Ultimate-N 6300 AGN, REV=0x74
> 
> As I'm travelling I only have two bad quality screenshots and 40 MB
> video of the crash :) From the stacktrace it looks that this is iommu
> related:
> 
> http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/1.png
> http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/2.png
> 
> This is a new laptop and most likely I haven't removed iwlagn module
> before. So this shouldn't be a regression.

We can not exclude iwlagn problem only triggered with intel iommu,
because problem does not happen with other modules, or does it?
Except test patch pointed by Johannes, I suggest turning on
CONFIG_DMA_API_DEBUG and test with intel_iommu=on and intel_iommu=off.

Stanislaw
