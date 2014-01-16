Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42328 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAPVlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 16:41:36 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21208.20686.79159.966434@gargle.gargle.HOWL> (sfid-20140116_224139_261790_6C9AFC9A)
Date: Fri, 17 Jan 2014 03:06:14 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52D7C62F.2030307@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
	<21204.319.492595.58625@gargle.gargle.HOWL>
	<52D402C3.3070606@neratec.com>
	<21204.1991.201080.986559@gargle.gargle.HOWL>
	<21204.2384.710460.402183@gargle.gargle.HOWL>
	<21204.3832.404821.109119@gargle.gargle.HOWL>
	<52D63EBB.7020607@neratec.com>
	<21206.17284.157496.206327@gargle.gargle.HOWL>
	<52D6472B.2060207@neratec.com>
	<21207.48441.292580.481850@gargle.gargle.HOWL>
	<21207.49245.151249.759167@gargle.gargle.HOWL>
	<52D7C62F.2030307@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> I guess I won't be able to reproduce bad scan results with wireless 
> testing since I have
> changed scan reporting to pure rssi in my openwrt compat.
> In normal case you get a sum of rssi and noise floor and it will be 
> correct i.e. when
> NF is shifted by 14db so will be rssi.
> So it's just my use case.
> 
> Anyway I have just solved the issue by applying calibrated noise floor 
> values from eeprom
> instead of nominal in nf_get functions and nf histogram. Now the rssi 
> seems stable in my test
> environment. I have just started testing but it looks promising.

I don't see how that would fix the issue. The race still remains since
there is a window between NF cal init and completion. The results
of the calibration depends on the environment and using default values
from the eeprom will not fix this, I think.

Sujith
