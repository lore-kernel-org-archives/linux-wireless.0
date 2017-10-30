Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:49185 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbdJ3IjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 04:39:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Message-ID: <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com> (sfid-20171030_093931_832947_D0061DAF)
Date: Mon, 30 Oct 2017 09:39:16 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
> on host (mac80211) rather than firmware. Rebuild cipher header
> in every received data frames (that are notified through those
> HTT interfaces) from the rx_hdr_status tlv available in the
> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
> flag for the packets which requires mac80211 PN/TSC check support
> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
> QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the
> rebuilding of cipher header to perform PN/TSC check for replay
> attack.
> 
> Please note that removing crypto tail for CCMP-256, GCMP and GCMP-256 ciphers
> in raw mode needs to be fixed. Since Rx with these ciphers in raw
> mode does not work in the current form even without this patch and
> removing crypto tail for these chipers needs clean up, raw mode related
> issues in CCMP-256, GCMP and GCMP-256 can be addressed in follow up
> patches.
> 
> Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

7eccb738fce5 ath10k: rebuild crypto header in rx data frames

-- 
https://patchwork.kernel.org/patch/10028621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
