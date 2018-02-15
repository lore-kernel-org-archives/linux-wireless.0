Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39832 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033423AbeBOOpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 09:45:51 -0500
Subject: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ab149f51-bd2e-871c-b429-2772dfa1b48c@nbd.name> (sfid-20180215_154554_921414_ADA70E81)
Date: Thu, 15 Feb 2018 15:45:48 +0100
MIME-Version: 1.0
In-Reply-To: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-14 17:26, Jean Pierre TOSONI wrote:
> ath9k returns a wrong RSSI value for frames received in a 30ms time
> window after a channel change. The correct value is typically 10dB
> below the returned value.
> 
> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083
> cards), during offchannel scans.
> 
> Mark the signal value as invalid in this case.
> 
> Signed-off-by: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
It seems that this will potentially cause a lot of scan results with
RSSI information missing, which I think may be worse than a 10 db
fluctuation.
Actually, it could also be that the hardware is reporting accurate RSSI
values (they're reported as SNR relative to the noise floor) and this is
just a blip caused by the fact that the hw is updating its internal
noise floor value based on running measurements.

Does the same fluctuation also happen if you set update = false for
calls to ath9k_hw_start_nfcal?

- Felix
