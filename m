Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23948 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbLANBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 08:01:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Steve deRosier <derosier@gmail.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Julian Calaby" <julian.calaby@gmail.com>,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: Re: [PATCH v3 1/2] ath6kl_sdio: Add reset gpio module parameter for CHIP_PWD_L pin
In-Reply-To: <1448237747-20037-2-git-send-email-steve.derosier@lairdtech.com>
	(Steve deRosier's message of "Sun, 22 Nov 2015 16:15:46 -0800")
References: <1448237747-20037-1-git-send-email-steve.derosier@lairdtech.com>
	<1448237747-20037-2-git-send-email-steve.derosier@lairdtech.com>
Date: Tue, 1 Dec 2015 15:01:08 +0200
Message-ID: <87zixugw6j.fsf@kamboji.qca.qualcomm.com> (sfid-20151201_140124_366304_9365A3DF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> Many ath6k chips have a reset pin, usually labeled CHIP_PWD_L. This pin can
> be pulled low by the host processor to hold the wifi chip in reset. By
> holding the chip in reset, the lowest power consumption available can be
> achieved.
>
> This adds a module parameter so the ath6kl_sdio driver can control the
> CHIP_PWD_L pin if the implementer so desires. This code is only available
> if GPIOLIB is configured.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

I haven't reviewed the patch yet but at least it doesn't compile on
32bit x86:

  CC [M]  drivers/net/wireless/ath/ath6kl/sdio.o
drivers/net/wireless/ath/ath6kl/sdio.c:81:38: error: ‘ARCH_NR_GPIOS’
undeclared here (not in a function)

-- 
Kalle Valo
