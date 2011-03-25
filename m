Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33203 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1CYUSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 16:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Zh2mY8SDRR6431=ykGOLAZJfmgAoDp09aV+O_@mail.gmail.com>
References: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com>
 <AANLkTimvLzgO1VHAbYz0uh-TVBGdLr-aDcyaGyzS2QMi@mail.gmail.com>
 <AANLkTimevrNU+JC=KvMzpGfip7cimPMo2cmBzvPiMb9R@mail.gmail.com> <AANLkTi=Zh2mY8SDRR6431=ykGOLAZJfmgAoDp09aV+O_@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 25 Mar 2011 22:17:43 +0200
Message-ID: <AANLkTi=ASQ8KduLFrdERqwdmA=kaqVAncYJA+cbw2Cw+@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] sdio: add power_restore support with
 MMC_PM_KEEP_POWER mode
To: Wilson Loi <wlsloi@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2011 at 7:08 PM, Wilson Loi <wlsloi@gmail.com> wrote:
> Therefore, there is a case that we power save for the host CPU and let the
> firmware handle the wlan state.
> WLAN card will wake up the host by SDIO IRQ or GPIO if there is a new
> incoming packet later.

Then you're talking about keeping the card powered during system
suspend, which is already supported (as mentioned by Nicolas and
Chris), but your patches really changed SDIO's runtime PM path (which
is not needed since anyway the driver fully controls it).
