Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29475 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdFLOvk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 10:51:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,3/3] ath10k: Set rxnss_override for QCA9888
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170609110750.14950-3-sven.eckelmann@openmesh.com>
References: <20170609110750.14950-3-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Sven Eckelmann" <sven.eckelmann@openmesh.com>
Message-ID: <1d5e14706f0f467d808e881e0ab42082@eusanexr01a.eu.qualcomm.com> (sfid-20170612_165144_134521_48A84985)
Date: Mon, 12 Jun 2017 07:51:36 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

> QCA9888 supports VHT80 with 2x2. But it only support 1x1 with VHT160 or
> VHT80+80. Inform userspace and the the QCA firmware about that limitation
> whenever VHT80+80 or VHT160 is configured.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This also had similar warnings, fixed in pending branch:

drivers/net/wireless/ath/ath10k/mac.c:4444:52: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/mac.c:4444:52:    expected restricted __le16 [assigned] [usertype] rx_highest
drivers/net/wireless/ath/ath10k/mac.c:4444:52:    got int
drivers/net/wireless/ath/ath10k/mac.c:4445:52: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/mac.c:4445:52:    expected restricted __le16 [assigned] [usertype] tx_highest
drivers/net/wireless/ath/ath10k/mac.c:4445:52:    got int


-- 
https://patchwork.kernel.org/patch/9778089/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
