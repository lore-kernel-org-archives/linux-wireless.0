Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41130 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031553AbeBNQEU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 11:04:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel\@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: mark RSSI as invalid if frame received during channel setup
References: <AM4PR0101MB2305369CE7574F25AA0AB680E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Date: Wed, 14 Feb 2018 18:04:16 +0200
In-Reply-To: <AM4PR0101MB2305369CE7574F25AA0AB680E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
        (Jean Pierre TOSONI's message of "Wed, 14 Feb 2018 14:47:23 +0000")
Message-ID: <87sha3mubj.fsf@purkki.adurom.net> (sfid-20180214_170424_318812_04191DEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Pierre TOSONI <jp.tosoni@acksys.fr> writes:

> ath9k returns a wrong RSSI value for frames received in a 30ms time window after
> a channel change. The correct value is typically 10dB below the returned value.
>
> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083 cards),
> during offchannel scans.
>
> Mark the signal value as invalid in this case.
>
> Signed-off-by: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
> ---
>  .../a995-b-acksys-ath9k-wait-channel-change.patch  |   39 ++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
>  create mode 100644 package/kernel/mac80211/patches/a995-b-acksys-ath9k-wait-channel-change.patch

This looks like a patch for LEDE, not for a Linux kernel tree.

-- 
Kalle Valo
