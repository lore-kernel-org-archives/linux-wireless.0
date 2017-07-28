Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:24725 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751631AbdG1Lce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 07:32:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: fix more-data flag for buffered multicast packets
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170725174616.81638-1-nbd@nbd.name>
References: <20170725174616.81638-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <f9957eaf4655464bb6d93c814aa09e31@euamsexm01a.eu.qualcomm.com> (sfid-20170728_133239_178637_FC9C1AC1)
Date: Fri, 28 Jul 2017 13:32:22 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> The flag needs to be cleared for the last packet in the list, not the
> first one. Fixes some issues with multicast packet loss for powersave
> clients connected to an ath9k AP.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Failed to compile:

drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_cabq’:
drivers/net/wireless/ath/ath9k/xmit.c:2454:2: error: implicit declaration of function ‘ath9k_set_moredata’ [-Werror=implicit-function-declaration]
  ath9k_set_moredata(sc, bf, false);
  ^
cc1: some warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/ath9k/xmit.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9862603/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
