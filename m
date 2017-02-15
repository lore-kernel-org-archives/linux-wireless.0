Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36443 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdBOJW3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:22:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: use correct OTP register offsets for the AR9340 and AR9550
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170214191030.31070-1-chunkeey@googlemail.com>
References: <20170214191030.31070-1-chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "QCA ath9k Development" <ath9k-devel@qca.qualcomm.com>,
        Chris Blake <chrisrblake93@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>, <stable@vger.kernel.org>
Message-ID: <3266b4742b924a8dab9769be36a1a758@eusanexr01a.eu.qualcomm.com> (sfid-20170215_102233_489075_3305A5C8)
Date: Wed, 15 Feb 2017 01:22:22 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> This patch fixes the OTP register definitions for the AR934x and AR9550
> WMAC SoC.
> 
> Previously, the ath9k driver was unable to initialize the integrated
> WMAC on an Aerohive AP121:
> 
> | ath: phy0: timeout (1000 us) on reg 0x30018: 0xbadc0ffe & 0x00000007 != 0x00000004
> | ath: phy0: timeout (1000 us) on reg 0x30018: 0xbadc0ffe & 0x00000007 != 0x00000004
> | ath: phy0: Unable to initialize hardware; initialization status: -5
> | ath9k ar934x_wmac: failed to initialize device
> | ath9k: probe of ar934x_wmac failed with error -5
> 
> It turns out that the AR9300_OTP_STATUS and AR9300_OTP_DATA
> definitions contain a typo.
> 
> Cc: Gabor Juhos <juhosg@openwrt.org>
> Cc: stable@vger.kernel.org
> Fixes: add295a4afbdf5852d0 "ath9k: use correct OTP register offsets for AR9550"
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> Signed-off-by: Chris Blake <chrisrblake93@gmail.com>

Patch applied to ath-next branch of ath.git, thanks.

c9f1e3260081 ath9k: use correct OTP register offsets for the AR9340 and AR9550

-- 
https://patchwork.kernel.org/patch/9572541/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
