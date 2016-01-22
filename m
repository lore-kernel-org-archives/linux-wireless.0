Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55934 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbcAVVIC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 16:08:02 -0500
Subject: Re: [PATCH] bcma: init serial console directly from ChipCommon code
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
References: <1453482174-11021-1-git-send-email-zajec5@gmail.com>
From: Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <56A29A2F.2040800@hauke-m.de> (sfid-20160122_220806_984067_66A99209)
Date: Fri, 22 Jan 2016 22:07:59 +0100
MIME-Version: 1.0
In-Reply-To: <1453482174-11021-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2016 06:02 PM, Rafał Miłecki wrote:
> UART is connected to and controlled over ChipCommon core. It doesn't
> have much to do with MIPS core (where we initialize it currently)
> except just existing on embedded systemms. There isn't point of such
> cross-core initialization (and we needed #ifdef anyway) so just handle
> it in ChipCommon.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Reviewed-by: Hauke Mehrtens <hauke@hauke-m.de>

This looks good.

We should probably also move the registration of the serial console from
arch/mips/bcm47xx to bcma and ssb.

Hauke
